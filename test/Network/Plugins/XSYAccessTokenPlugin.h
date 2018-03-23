//
//  XSYAccessTokenPlugin.h
//  ingage
//
//  Created by 郭源 on 2018/2/28周三.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYNetworkConst.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 An enum representing the header to use with an `AccessTokenPlugin`
 */
typedef NS_ENUM(NSUInteger, XSYAuthorizationType) {
    XSYAuthorizationTypeNone = 0,   ///< No header.
    XSYAuthorizationTypeBasic = 1,  ///< The `@"Basic"` header.
    XSYAuthorizationTypeBearer = 2, ///< The `@"Bearer"` header.
};

@protocol XSYAccessTokenAuthorizable <NSObject>

@property (readonly, nonatomic, assign) XSYAuthorizationType authorizationType;

@end

/**
 A plugin for adding basic or bearer-type authorization headers to requests. Example:

 ```
 Authorization: Bearer <token>
 Authorization: Basic <token>
 ```

 */
@interface XSYAccessTokenPlugin : NSObject <XSYPluginInterface>

- (instancetype)initWithTokenBlock:(NSString * (^)())block;

@end

NS_ASSUME_NONNULL_END
