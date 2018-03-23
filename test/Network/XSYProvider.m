//
//  XSYProvider.m
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYProvider.h"
#import "XSYCancellable.h"
#import "XSYEndpoint+Internal.h"
#import "XSYEndpoint.h"
#import "XSYMultipartProvider.h"
#import "XSYProvider+Internal.h"
#import "XSYRequestTask.h"
#import "XSYResult.h"

@implementation XSYProvider

+ (instancetype)providerWithEndpoint:(EndpointBlock)endpointBlock
                             request:(RequestBlock)requestBlock
                             manager:(Manager *)manager
                             plugins:(nonnull NSArray<id<XSYPluginInterface>> *)plugins {
    return [[self alloc] initWithEndpoint:endpointBlock request:requestBlock manager:manager plugins:plugins];
}

- (instancetype)initWithEndpoint:(EndpointBlock)endpointBlock
                         request:(RequestBlock)requestBlock
                         manager:(Manager *)manager
                         plugins:(NSArray<id<XSYPluginInterface>> *)plugins {
    if (self = [super init]) {
        _endpointBlock = endpointBlock;
        _requestBlock = requestBlock;
        _manager = manager;
        _plugins = plugins;
    }
    return self;
}

- (id<CancellableInterface>)requestWithTarget:(id<XSYTargetInterface>)target completion:(XSYCompletionBlock)completion {
    return [self requestWithTarget:target progress:nil completion:completion];
}

- (id<CancellableInterface>)requestWithTarget:(id<XSYTargetInterface>)target
                                     progress:(XSYProgressBlock)progress
                                   completion:(XSYCompletionBlock)completion {
    return [self requestWithTarget:target progress:progress completion:completion inQueue:nil];
}

- (id<CancellableInterface>)requestWithTarget:(id<XSYTargetInterface>)target
                                     progress:(XSYProgressBlock)progress
                                   completion:(XSYCompletionBlock)completion
                                      inQueue:(dispatch_queue_t)queue {
    return
        [self requestNormal:target progress:progress completion:completion inQueue:queue ?: dispatch_get_main_queue()];
}

@end
