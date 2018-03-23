//
//  XSYProvider+Internal.h
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYProvider.h"

@class XSYCancellable;

NS_ASSUME_NONNULL_BEGIN

@interface XSYProvider (Internal)

- (id<CancellableInterface>)requestNormal:(id<XSYTargetInterface>)target
                                 progress:(nullable XSYProgressBlock)progress
                               completion:(XSYCompletionBlock)completion
                                  inQueue:(nullable dispatch_queue_t)queue;

@end

NS_ASSUME_NONNULL_END
