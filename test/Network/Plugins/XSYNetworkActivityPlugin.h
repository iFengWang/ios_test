//
//  XSYNetworkActivityPlugin.h
//  ingage
//
//  Created by 郭源 on 2018/2/28周三.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYNetworkConst.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XSYNetworkActivityChangeType) {
    XSYNetworkActivityChangeTypeBegan = 0,
    XSYNetworkActivityChangeTypeEnded = 1,
};

typedef void (^XSYNetworkActivityBlock)(XSYNetworkActivityChangeType, id<XSYTargetInterface>);

@interface XSYNetworkActivityPlugin : NSObject <XSYPluginInterface>

- (instancetype)initWithNetworkActivityBlock:(XSYNetworkActivityBlock)block;

@end

NS_ASSUME_NONNULL_END
