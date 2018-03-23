//
//  XSYEndpoint.m
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYEndpoint.h"
#import "NSArray+Functional.h"
#import "NSDictionary+Functional.h"
#import "XSYEndpoint+Internal.h"
#import "XSYMultipartProvider.h"
#import "XSYRequestTask+Internal.h"
#import "XSYResult.h"

static NSString *converHTTPMethod(XSYHTTPMethodType type) {
    switch (type) {
        case XSYHTTPMethodGET:
            return @"GET";
        case XSYHTTPMethodPOST:
            return @"POST";
        case XSYHTTPMethodHEAD:
            return @"HEAD";
        case XSYHTTPMethodDELETE:
            return @"DELETE";
        case XSYHTTPMethodPUT:
            return @"PUT";
        case XSYHTTPMethodPATCH:
            return @"PATCH";
    }
}

@implementation XSYEndpoint

+ (instancetype)endpointWithURL:(NSString *)url
                         method:(XSYHTTPMethodType)method
                     parameters:(XSYParameters *)parameters
                           task:(XSYRequestTask *)task
               httpHeaderFields:(XSYHttpHeaderFields *)httpHeaderFields {
    return
        [[self alloc] initWithURL:url method:method parameters:parameters task:task httpHeaderFields:httpHeaderFields];
    ;
}

- (instancetype)initWithURL:(NSString *)url
                     method:(XSYHTTPMethodType)method
                 parameters:(XSYParameters *)parameters
                       task:(XSYRequestTask *)task
           httpHeaderFields:(XSYHttpHeaderFields *)httpHeaderFields {
    if (self = [super init]) {
        _url = url;
        _method = method;
        _parameters = parameters;
        _task = task;
        _httpHeaderFields = httpHeaderFields;
    }
    return self;
}

- (XSYEndpoint *)addNewParameters:(XSYParameters *)newParameters {
    XSYParameters *params = [self addParameters:newParameters];
    return [XSYEndpoint endpointWithURL:self.url
                                 method:self.method
                             parameters:params
                                   task:self.task
                       httpHeaderFields:self.httpHeaderFields];
}

- (XSYEndpoint *)replaceNewTask:(XSYRequestTask *)newTask {
    return [XSYEndpoint endpointWithURL:self.url
                                 method:self.method
                             parameters:self.parameters
                                   task:newTask
                       httpHeaderFields:self.httpHeaderFields];
}

- (XSYEndpoint *)addNewHttpHeaderFields:(XSYHttpHeaderFields *)newHttpHeaderFields {
    XSYHttpHeaderFields *headerFields = [self addHttpHeaderFields:newHttpHeaderFields];
    return [XSYEndpoint endpointWithURL:self.url
                                 method:self.method
                             parameters:self.parameters
                                   task:self.task
                       httpHeaderFields:headerFields];
}

- (XSYResult<NSURLRequest *> *)urlRequest {
    AFHTTPRequestSerializer *requestSerializer = self.task.xsy_requestSerializer;
    NSMutableURLRequest *urlRequest = nil;
    NSError *error = nil;
    if (self.task.type == XSYTaskUploadFormData) {
        __weak typeof(self) weakSelf = self;
        urlRequest =
            [requestSerializer multipartFormRequestWithMethod:converHTTPMethod(self.method)
                                                    URLString:self.url
                                                   parameters:self.parameters
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
                                        __strong typeof(weakSelf) strongSelf = weakSelf;
                                        [((XSYUploadFormDataTask *)strongSelf.task).formDatas
                                            forEach:^(XSYMultipartProvider *_Nonnull obj, NSUInteger index) {
                                                switch (obj.type) {
                                                    case XSYMultipartData:
                                                        [strongSelf appendData:(XSYDataMultipart *)obj to:formData];
                                                        break;
                                                    case XSYMultipartFile:
                                                        [strongSelf appendFile:(XSYFileMultipart *)obj to:formData];
                                                        break;
                                                }
                                            }];
                                    }
                                                        error:&error];
    } else {
        urlRequest = [requestSerializer requestWithMethod:converHTTPMethod(self.method)
                                                URLString:self.url
                                               parameters:self.parameters
                                                    error:&error];
    }
    if (error) {
        return [XSYResult resultWithError:error];
    } else {
        urlRequest.allHTTPHeaderFields = self.httpHeaderFields;
        return [XSYResult resultWithValue:urlRequest];
    }
}

@end
