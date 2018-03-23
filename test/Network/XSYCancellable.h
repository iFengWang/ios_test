//
//  XSYCancellable.h
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYNetworkConst.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XSYCancellable : NSObject <CancellableInterface>

+ (instancetype)cancellableWithTask:(nullable NSURLSessionTask *)task;

@end

NS_ASSUME_NONNULL_END
