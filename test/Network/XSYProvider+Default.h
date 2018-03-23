//
//  XSYProvider+Default.h
//  ingage
//
//  Created by 郭源 on 2018/2/6周二.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYProvider.h"

NS_ASSUME_NONNULL_BEGIN

///---------------------
/// @name These functions are default mappings to `XSYProvider`'s properties: endpoints, requests, manager, etc.
///---------------------

#ifdef __cplusplus
extern "C" {
#endif

XSYEndpoint *DefaultEndpointBlock(id<XSYTargetInterface>);

void DefaultRequestBlock(XSYEndpoint *, RequestResultBlock);

#ifdef __cplusplus
}
#endif

FOUNDATION_EXPORT NSErrorDomain const XSYResponseObjectCodeErrorDomain;

FOUNDATION_EXPORT NSErrorUserInfoKey const XSYResponseObjectCodeErrorKey;
FOUNDATION_EXPORT NSErrorUserInfoKey const XSYResponseObjectMsgErrorKey;
FOUNDATION_EXPORT NSErrorUserInfoKey const XSYResponseObjectInfoErrorKey;

typedef id (^XSYProviderTransformer)(NSDictionary<NSString *, id> *);

@interface XSYProvider (Default)

@property (class, readonly, strong) Manager *defaultManager;

+ (void)setupDefaultManager:(Manager *)manager;

@property (class, readonly, strong) XSYProvider *defaultProvider;
+ (instancetype)defaultProviderWithPlugins:(NSArray<id<XSYPluginInterface>> *)plugins;

///---------------------
/// @name Request
///---------------------

- (id<CancellableInterface>)requestWithTarget:(id<XSYTargetInterface>)target
                                  transformer:(XSYProviderTransformer)transformer
                                   completion:(void (^)(XSYResult<id> *))completion;

@end

NS_ASSUME_NONNULL_END
