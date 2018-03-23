//
//  XSYProvider+Default.m
//  ingage
//
//  Created by 郭源 on 2018/2/6周二.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYNetworkLoggerPlugin.h"
#import "XSYProvider+Default.h"
#import "XSYResponse.h"
#import "XSYResult.h"
#import "XSYUserDefaults.h"

XSYEndpoint *DefaultEndpointBlock(id<XSYTargetInterface> target) {
    NSString *urlString = [NSURL URLWithString:target.path relativeToURL:target.baseURL].absoluteString;
    XSYEndpoint *endpoint = [XSYEndpoint endpointWithURL:urlString
                                                  method:target.method
                                              parameters:target.parameters
                                                    task:target.task
                                        httpHeaderFields:target.headers];
    NSMutableDictionary *headers = [NSMutableDictionary
        dictionaryWithObject:XSYUserDefaults.currentLanguage.value ?: NSLocale.preferredLanguages.firstObject
                      forKey:@"Accept-Language"];
    NSString * name = kTokenKeyName;
    NSString * tolenStr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserToken];
    if (![ingageTool isEmpty:tolenStr]) {
      [headers setValue:[NSString stringWithFormat:@"%@=%@",name,tolenStr] forKey:@"Cookie"];
    }
    [headers setValue:@"application/json" forKey:@"Content-Type"];
//    !XSYUserDefaults.uid.value ?: [headers setObject:XSYUserDefaults.uid.value forKey:@"xsy-user-id"];
//    !XSYUserDefaults.tenantID.value ?: [headers setObject:XSYUserDefaults.tenantID.value forKey:@"xsy-tenant-id"];
    return [endpoint addNewHttpHeaderFields:headers];
}

void DefaultRequestBlock(XSYEndpoint *endpoint, RequestResultBlock result) { result(endpoint.urlRequest); }

NSErrorDomain const XSYResponseObjectCodeErrorDomain = @"com.XSYNetworking.error.code.object.response";

NSErrorUserInfoKey const XSYResponseObjectCodeErrorKey = @"code";
NSErrorUserInfoKey const XSYResponseObjectMsgErrorKey = @"msg";
NSErrorUserInfoKey const XSYResponseObjectInfoErrorKey = @"errorInfo";

static Manager *_defaultManager = nil;

static XSYNetworkLoggerPlugin *_loggerPlugin = nil;

@implementation XSYProvider (Default)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager =
            [[Manager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

#if DEBUG
        _loggerPlugin = [[XSYNetworkLoggerPlugin alloc] initWithVerbose:YES
                                                                 output:nil
                                                   requestDataFormatter:nil
                                                  responseDataFormatter:nil];
#endif
    });
}

+ (Manager *)defaultManager {
    return _defaultManager;
}

+ (XSYProvider *)defaultProvider {
    return [XSYProvider defaultProviderWithPlugins:[NSArray array]];
}

+ (instancetype)defaultProviderWithPlugins:(NSArray<id<XSYPluginInterface>> *)plugins {
    return [XSYProvider providerWithEndpoint:^XSYEndpoint *(id<XSYTargetInterface> _Nonnull target) {
        return DefaultEndpointBlock(target);
    }
        request:^(XSYEndpoint *_Nonnull endpoint, RequestResultBlock _Nonnull result) {
            DefaultRequestBlock(endpoint, result);
        }
        manager:_defaultManager
        plugins:plugins];
}

+ (void)setupDefaultManager:(Manager *)manager {
    @synchronized(self) {
        _defaultManager = manager;
    }
}

- (id<CancellableInterface>)requestWithTarget:(id<XSYTargetInterface>)target
                                  transformer:(XSYProviderTransformer)transformer
                                   completion:(void (^)(XSYResult<id> *))completion {
    return [self requestWithTarget:target
                        completion:^(XSYResult<XSYResponse *> *_Nonnull result) {
                            if (result.value) {
                                NSDictionary *json = result.value.responseObject;
                                if ([json[XSYResponseObjectCodeErrorKey] isEqualToString:@"200"]) {
                                    id model = transformer(json[@"data"]);
                                    completion([XSYResult resultWithValue:model]);
                                } else {
                                    NSError *error = [NSError
                                        errorWithDomain:XSYResponseObjectCodeErrorDomain
                                                   code:0
                                               userInfo:@{
                                                          XSYResponseObjectCodeErrorKey: json[XSYResponseObjectCodeErrorKey] ?: @"",
                                                   XSYResponseObjectMsgErrorKey: json[XSYResponseObjectMsgErrorKey] ?: @"",
                                                   XSYResponseObjectInfoErrorKey: json[XSYResponseObjectInfoErrorKey] ?: @""
                                               }];
                                    completion([XSYResult resultWithError:error]);
                                }
                            } else {
                                completion(result);
                            }
                        }];
}

@end
