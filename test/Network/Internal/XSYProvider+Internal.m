//
//  XSYProvider+Internal.m
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import "NSArray+Functional.h"
#import "XSYAuthenticateRequest.h"
#import "XSYCancellable.h"
#import "XSYCancellableWrapper.h"
#import "XSYProvider+Internal.h"
#import "XSYRequestTask.h"
#import "XSYResponse.h"
#import "XSYResult.h"

@implementation XSYProvider (Internal)

#pragma mark -
#pragma mark - Request

- (id<CancellableInterface>)requestNormal:(id<XSYTargetInterface>)target
                                 progress:(XSYProgressBlock)progress
                               completion:(XSYCompletionBlock)completion
                                  inQueue:(dispatch_queue_t)queue {
    XSYEndpoint *endpoint = self.endpointBlock(target);
    XSYCancellableWrapper *cancellableToken = [XSYCancellableWrapper new];

    // 允许所有插件去修改 response.
    XSYCompletionBlock pluginsWithCompletion = ^(XSYResult<XSYResponse *> *result) {
        XSYResult<XSYResponse *> *processedResult = [self.plugins
            reduce:result
             block:^XSYResult<XSYResponse *> *(XSYResult<XSYResponse *> *reducedResult, id<XSYPluginInterface> plugin) {
                 return ![plugin respondsToSelector:@selector(process:target:)]
                            ? reducedResult
                            : [plugin process:reducedResult target:target];
             }];
    };

    RequestResultBlock performNetworking = ^(XSYResult<NSURLRequest *> *requestResult) {
        if (cancellableToken.isCancelled) {
            [self cancelCompletion:pluginsWithCompletion target:target];
            return;
        }

        NSURLRequest *request = nil;
        if (requestResult.value) {
            request = requestResult.value;
        } else {
            pluginsWithCompletion([XSYResult resultWithError:requestResult.error]);
            return;
        }

        NSURLRequest *preparedRequest =
            [self.plugins reduce:request
                           block:^NSURLRequest *(NSURLRequest *reducedResult, id<XSYPluginInterface> plugin) {
                               return ![plugin respondsToSelector:@selector(prepare:target:)]
                                          ? reducedResult
                                          : [plugin prepare:reducedResult target:target];
                           }];

        XSYCompletionBlock networkCompletion = ^(XSYResult<XSYResponse *> *result) {
            pluginsWithCompletion(result);
        };

        cancellableToken.innerCancellable =
            [self sendRequest:preparedRequest target:target progress:progress completion:completion inQueue:queue];
    };

    self.requestBlock(endpoint, performNetworking);

    return cancellableToken;
}

- (id<CancellableInterface>)sendRequest:(NSURLRequest *)request
                                 target:(id<XSYTargetInterface>)target
                               progress:(XSYProgressBlock)progress
                             completion:(XSYCompletionBlock)completion
                                inQueue:(nullable dispatch_queue_t)queue {

    XSYAuthenticateRequest *innterRequest =
        [[XSYAuthenticateRequest alloc] initWithRequest:request manager:self.manager];
    [self.plugins forEach:^(id<XSYPluginInterface> plugin, NSUInteger i) {
        ![plugin respondsToSelector:@selector(willSend:target:)] ?: [plugin willSend:innterRequest target:target];
    }];

    void (^progressHandler)(NSProgress *) = nil;
    if (progress) {
        progressHandler = ^(NSProgress *p) {
            XSYProgressResponse *progressResponse = [XSYProgressResponse responseWithProgress:p response:nil];
            dispatch_async(queue, ^{
                progress(progressResponse);
            });
        };
    }

    void (^completionHandler)(NSURLResponse *_Nonnull, id _Nullable, NSError *_Nullable) = nil;
    if (completion) {
        completionHandler = ^(NSURLResponse *_Nonnull response, id _Nullable responseObject, NSError *_Nullable error) {
            XSYResult<XSYResponse *> *result = nil;
            if (error) {
                result = [XSYResult resultWithError:error];
            } else {
                XSYResponse *r = [XSYResponse responseWithStatusCode:((NSHTTPURLResponse *)response).statusCode
                                                      responseObject:responseObject
                                                             request:request
                                                            response:((NSHTTPURLResponse *)response)];
                if (progress) {
                    XSYProgressResponse *pr = [XSYProgressResponse responseWithProgress:nil response:r];
                    progress(pr);
                }
                result = [XSYResult resultWithValue:r];
            }
            [self.plugins forEach:^(id<XSYPluginInterface> plugin, NSUInteger i) {
                ![plugin respondsToSelector:@selector(didReceive:target:)] ?: [plugin didReceive:result target:target];
            }];
            dispatch_async(queue, ^{
                completion(result);
            });
        };
    }

    switch (target.task.type) {
        case XSYTaskRequest:
            return [self sendRequest:request completionHandler:completionHandler];
        case XSYTaskUploadFile:
            return [self sendUploadFileRequest:request
                                    uploadTask:(XSYUploadFileTask *)target.task
                               progressHandler:progressHandler
                             completionHandler:completionHandler];
        case XSYTaskUploadFormData:
            return [self sendUploadFormDataRequest:request
                                   progressHandler:progressHandler
                                 completionHandler:completionHandler];
            ;
        case XSYTaskDownload:
            return [self sendDownloadRequest:request
                                downloadTask:(XSYDownloadTask *)target.task
                             progressHandler:progressHandler
                           completionHandler:completionHandler];
    }
}

- (id<CancellableInterface>)sendRequest:(NSURLRequest *)request
                      completionHandler:
                          (nullable void (^)(NSURLResponse *, id _Nullable, NSError *_Nullable))completionHandler {
    NSURLSessionDataTask *task = nil;
    task = [self.manager dataTaskWithRequest:request completionHandler:completionHandler];
    [task resume];

    return [XSYCancellable cancellableWithTask:task];
}

- (id<CancellableInterface>)sendUploadFileRequest:(NSURLRequest *)request
                                       uploadTask:(XSYUploadFileTask *)uploadTask
                                  progressHandler:(nullable void (^)(NSProgress *))progressHandler
                                completionHandler:(nullable void (^)(NSURLResponse *, id _Nullable,
                                                                     NSError *_Nullable))completionHandler {

    NSURLSessionDataTask *task = nil;
    task = [self.manager uploadTaskWithRequest:request
                                      fromFile:uploadTask.url
                                      progress:progressHandler
                             completionHandler:completionHandler];
    return [XSYCancellable cancellableWithTask:task];
}

- (id<CancellableInterface>)sendUploadFormDataRequest:(NSURLRequest *)request
                                      progressHandler:(nullable void (^)(NSProgress *))progressHandler
                                    completionHandler:(nullable void (^)(NSURLResponse *, id _Nullable,
                                                                         NSError *_Nullable))completionHandler {

    NSURLSessionDataTask *task = nil;
    task = [self.manager uploadTaskWithStreamedRequest:request
                                              progress:progressHandler
                                     completionHandler:completionHandler];
    return [XSYCancellable cancellableWithTask:task];
}

- (id<CancellableInterface>)sendDownloadRequest:(NSURLRequest *)request
                                   downloadTask:(XSYDownloadTask *)downloadTask
                                progressHandler:(nullable void (^)(NSProgress *))progressHandler
                              completionHandler:(nullable void (^)(NSURLResponse *, id _Nullable,
                                                                   NSError *_Nullable))completionHandler {

    XSYDownloadDestinationBlock destination = ^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *fileURL = downloadTask.destination(targetPath, response);
        switch (downloadTask.options) {
            case XSYDownloadRemovePreviousFile:
                [NSFileManager.defaultManager removeItemAtURL:fileURL error:nil];
                break;
            case XSYDownloadCreateIntermediateDirectories: {
                NSURL *directoryURL = [fileURL URLByDeletingLastPathComponent];
                [NSFileManager.defaultManager createDirectoryAtURL:directoryURL
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:nil];
                break;
            }
        }
        return fileURL;
    };

    NSURLSessionDownloadTask *task = nil;
    task = [self.manager downloadTaskWithRequest:request
                                        progress:progressHandler
                                     destination:destination
                               completionHandler:completionHandler];
    return [XSYCancellable cancellableWithTask:task];
}

#pragma mark -
#pragma mark - Other

- (void)cancelCompletion:(XSYCompletionBlock)completion target:(id<XSYTargetInterface>)target {
    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:nil];
    XSYResult *result = [XSYResult resultWithError:error];
    [self.plugins forEach:^(id<XSYPluginInterface> plugin, NSUInteger index) {
        ![plugin respondsToSelector:@selector(didReceive:target:)] ?: [plugin didReceive:result target:target];
    }];
    completion(result);
}

@end
