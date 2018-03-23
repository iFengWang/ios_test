//
//  XSYAuthenticateRequest.m
//  ingage
//
//  Created by 郭源 on 2018/2/28周三.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYAuthenticateRequest.h"

@implementation XSYAuthenticateRequest {
    NSURLRequest *_privateRequest;
    Manager *_manager;
}

- (instancetype)initWithRequest:(NSURLRequest *)request manager:(Manager *)manager {
    if (self = [super init]) {
        _privateRequest = request;
        _manager = manager;
    }
    return self;
}

- (NSURLRequest *)request {
    return _privateRequest;
}

- (id<XSYRequestTypeInterface>)authenticateUser:(NSString *)user
                                       password:(NSString *)password
                                    persistence:(NSURLCredentialPersistence)persistence {
    [_manager setTaskDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(
                  NSURLSession *_Nonnull session, NSURLSessionTask *_Nonnull task,
                  NSURLAuthenticationChallenge *_Nonnull challenge,
                  NSURLCredential *__autoreleasing _Nullable *_Nullable credential) {
        NSURLCredential *credential =
            [[NSURLCredential alloc] initWithUser:user password:password persistence:persistence];
        *credential = credential;
        return NSURLSessionAuthChallengeUseCredential;
    }];
}

- (id<XSYRequestTypeInterface>)authenticateWithCredential:(NSURLCredential *)credential {
    [_manager setTaskDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(
                  NSURLSession *_Nonnull session, NSURLSessionTask *_Nonnull task,
                  NSURLAuthenticationChallenge *_Nonnull challenge,
                  NSURLCredential *__autoreleasing _Nullable *_Nullable credential) {
        *credential = credential;
        return NSURLSessionAuthChallengeUseCredential;
    }];
}

@end
