//
//  XSYAccessTokenPlugin.m
//  ingage
//
//  Created by 郭源 on 2018/2/28周三.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYAccessTokenPlugin.h"

@interface XSYAccessTokenPlugin ()

@property (readonly, nonatomic, copy) NSString * (^tokenBlock)();

@end

@implementation XSYAccessTokenPlugin

- (instancetype)initWithTokenBlock:(NSString *_Nonnull (^)())block {
    if (self = [super init]) {
        _tokenBlock = block;
    }
    return self;
}

- (NSURLRequest *)prepare:(NSURLRequest *)request target:(id<XSYTargetInterface>)target {
    if (![target conformsToProtocol:@protocol(XSYAccessTokenAuthorizable)]) {
        return request;
    }

    XSYAuthorizationType authorizationType = ((id<XSYAccessTokenAuthorizable>)target).authorizationType;

    NSMutableURLRequest *mutableRequest = request.mutableCopy;

    switch (authorizationType) {
        case XSYAuthorizationTypeBasic: {
            NSString *authValue = [NSString stringWithFormat:@"Basic %@", self.tokenBlock()];
            [mutableRequest addValue:authValue forHTTPHeaderField:@"Authorization"];
            break;
        }
        case XSYAuthorizationTypeBearer: {
            NSString *authValue = [NSString stringWithFormat:@"Bearer %@", self.tokenBlock()];
            [mutableRequest addValue:authValue forHTTPHeaderField:@"Authorization"];
            break;
        }
        case XSYAuthorizationTypeNone:
            break;
    }
    return mutableRequest;
}

@end
