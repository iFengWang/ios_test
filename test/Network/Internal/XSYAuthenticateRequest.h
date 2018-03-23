//
//  XSYAuthenticateRequest.h
//  ingage
//
//  Created by 郭源 on 2018/2/28周三.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYNetworkConst.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XSYAuthenticateRequest : NSObject <XSYRequestTypeInterface>

- (instancetype)initWithRequest:(NSURLRequest *)request manager:(Manager *)manager;

@end

NS_ASSUME_NONNULL_END
