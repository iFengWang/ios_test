//
//  XSYNetworkLoggerPlugin.h
//  ingage
//
//  Created by 郭源 on 2018/2/28周三.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYNetworkConst.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * (^XSYRequestDataFormatterBlock)(NSData *);
typedef NSString * (^XSYResponseDataFormatterBlock)(id);

@interface XSYNetworkLoggerPlugin : NSObject <XSYPluginInterface>

- (instancetype)initWithVerbose:(BOOL)verbose
                         output:(nullable void (^)(NSArray<NSString *> *))output
           requestDataFormatter:(nullable XSYRequestDataFormatterBlock)requestDataFormatter
          responseDataFormatter:(nullable XSYResponseDataFormatterBlock)responseDataFormatter;

@property (nullable, readonly, nonatomic, copy) XSYRequestDataFormatterBlock requestDataFormatter;

@property (nullable, readonly, nonatomic, copy) XSYResponseDataFormatterBlock responseDataFormatter;

@end

NS_ASSUME_NONNULL_END
