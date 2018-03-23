//
//  XSYProvider.h
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYEndpoint.h"
#import "XSYNetworkConst.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XSYResponse, XSYProgressResponse, XSYEndpoint, XSYResult<ObjectType>;

/** Closure to be executed when a request has completed. */
typedef void (^XSYCompletionBlock)(XSYResult<XSYResponse *> *);

/** Closure to be executed when progress changes. */
typedef void (^XSYProgressBlock)(XSYProgressResponse *);

/** Closure that defines the endpoints for the provider. */
typedef XSYEndpoint * (^EndpointBlock)(id<XSYTargetInterface>);

/** Closure that decides if and what request should be performed. */
typedef void (^RequestResultBlock)(XSYResult<NSURLRequest *> *);

/** Closure that resolves an `XSYEndpoint` into a `RequestResultBlock`. */
typedef void (^RequestBlock)(XSYEndpoint *, RequestResultBlock);

@interface XSYProvider : NSObject

/**
 Initializes a provider.

 @param endpointBlock A closure responsible for mapping a `XSYTargetInterface` to an `XSYEndpoint`.
 @param requestBlock A closure deciding if and what request should be performed.
 */
+ (instancetype)providerWithEndpoint:(EndpointBlock)endpointBlock
                             request:(RequestBlock)requestBlock
                             manager:(Manager *)manager
                             plugins:(NSArray<id<XSYPluginInterface>> *)plugins;

/**
 The manager for the session.
 */
@property (readonly, nonatomic, strong) Manager *manager;

@property (readonly, nonatomic, copy) EndpointBlock endpointBlock;

@property (readonly, nonatomic, copy) RequestBlock requestBlock;

/**
 A list of plugins.
 e.g. for logging, netowrk activity indicator or credentials.
 */
@property (readonly, nonatomic, strong) NSArray<id<XSYPluginInterface>> *plugins;

///---------------------
/// @name Request
///---------------------

/**
 Designated request-making method.

 @param queue If `NULL` , the main queue will be used.
 @return Returns a `CancellableInterface` token to cancel the request later.
 */
- (id<CancellableInterface>)requestWithTarget:(id<XSYTargetInterface>)target
                                     progress:(nullable XSYProgressBlock)progress
                                   completion:(XSYCompletionBlock)completion
                                      inQueue:(nullable dispatch_queue_t)queue;

- (id<CancellableInterface>)requestWithTarget:(id<XSYTargetInterface>)target
                                     progress:(nullable XSYProgressBlock)progress
                                   completion:(XSYCompletionBlock)completion;

- (id<CancellableInterface>)requestWithTarget:(id<XSYTargetInterface>)target completion:(XSYCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
