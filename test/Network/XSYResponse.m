//
//  XSYResponse.m
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYResponse.h"
#import "XSYResult.h"

NSErrorDomain const XSYResponseStatusCodeErrorDomain = @"com.XSYNetworking.error.statusCode.response";

@implementation XSYResponse

+ (instancetype)responseWithStatusCode:(NSInteger)statusCode
                        responseObject:(NSData *)responseObject
                               request:(NSURLRequest *)request
                              response:(NSHTTPURLResponse *)response {
    return [[self alloc] initWithStatusCode:statusCode responseObject:responseObject request:request response:response];
}

- (instancetype)initWithStatusCode:(NSInteger)statusCode
                    responseObject:(NSData *)responseObject
                           request:(NSURLRequest *)request
                          response:(NSHTTPURLResponse *)response {
    if (self = [super init]) {
        _statusCode = statusCode;
        _responseObject = responseObject;
        _request = request;
        _response = response;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Status Code: %ld, Data: %@", (long)self.statusCode, self.responseObject];
}

- (NSString *)debugDescription {
    return self.description;
}

- (BOOL)isEqualToResponse:(XSYResponse *)response {
    return self.statusCode == response.statusCode && [self.responseObject isEqual:response.responseObject] &&
           [self.response isEqual:response.response];
}

@end

@implementation XSYResponse (Extension)

- (XSYResponse *)filterWithStatusCodes:(NSRange)range error:(NSError *__autoreleasing *)error {
    if (self.statusCode >= range.location && self.statusCode <= NSMaxRange(range)) {
        return self;
    }
    if (error) {
        *error = [NSError errorWithDomain:XSYResponseStatusCodeErrorDomain code:self.statusCode userInfo:nil];
    }

    return nil;
}

- (XSYResponse *)filterWithStatusCode:(NSInteger)statusCode error:(NSError *__autoreleasing *)error {
    return [self filterWithStatusCodes:NSMakeRange(statusCode, 0) error:error];
}

- (XSYResponse *)filterSuccessfulStatusCodesWithError:(NSError *__autoreleasing *)error {
    return [self filterWithStatusCodes:NSMakeRange(200, 99) error:error];
}

- (XSYResponse *)filterSuccessfulStatusAndRedirectCodesWithError:(NSError *__autoreleasing *)error {
    return [self filterWithStatusCodes:NSMakeRange(200, 199) error:error];
}

@end

@implementation XSYProgressResponse

+ (instancetype)responseWithProgress:(NSProgress *)progress response:(XSYResponse *)response {
    return [[self alloc] initWithProgress:progress response:response];
}

- (instancetype)initWithProgress:(NSProgress *)progress response:(XSYResponse *)response {
    if (self = [super init]) {
        _progressObj = progress;
        _response = response;
    }
    return self;
}

- (double)progress {
    return self.progressObj ? self.progressObj.fractionCompleted : 1.0;
}

- (BOOL)completed {
    return self.progress == 1.0 && self.response != nil;
}

@end
