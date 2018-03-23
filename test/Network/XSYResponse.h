//
//  XSYResponse.h
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYNetworkConst.h"
#import <Foundation/Foundation.h>

@class XSYResult<ObjectType>;

NS_ASSUME_NONNULL_BEGIN

/** Represents a response to a `XSYProvider.request`. */
@interface XSYResponse : NSObject

+ (instancetype)responseWithStatusCode:(NSInteger)statusCode
                        responseObject:(id)responseObject
                               request:(nullable NSURLRequest *)request
                              response:(nullable NSHTTPURLResponse *)response;

/** The status code of the response. */
@property (readonly, nonatomic, assign) NSInteger statusCode;

/** The response data. */
@property (readonly, nonatomic, strong) id responseObject;

/** The original URLRequest for the response. */
@property (nullable, readonly, nonatomic, strong) NSURLRequest *request;

/** The NSURLResponse object. */
@property (nullable, readonly, nonatomic, strong) NSHTTPURLResponse *response;

- (BOOL)isEqualToResponse:(XSYResponse *)response;

@end

@interface XSYResponse (Extension)

/**
 Returns the `XSYResponse` if the `statusCode` falls within the specified range.

 @param range The range of acceptable status codes.
 */
- (nullable XSYResponse *)filterWithStatusCodes:(NSRange)range error:(NSError *_Nullable __autoreleasing *)error;

/**
 Returns the `XSYResponse` if it has the specified `statusCode`.

 @param statusCode The acceptable status code.
 */
- (nullable XSYResponse *)filterWithStatusCode:(NSInteger)statusCode error:(NSError *_Nullable __autoreleasing *)error;

/**
 Returns the `XSYResponse` if the `statusCode` falls within the range 200 - 299.
 */
- (nullable XSYResponse *)filterSuccessfulStatusCodesWithError:(NSError *_Nullable __autoreleasing *)error;

/**
 Returns the `Response` if the `statusCode` falls within the range 200 - 399.
 */
- (nullable XSYResponse *)filterSuccessfulStatusAndRedirectCodesWithError:(NSError *_Nullable __autoreleasing *)error;

@end

FOUNDATION_EXPORT NSErrorDomain const XSYResponseStatusCodeErrorDomain;

/** A type representing the progress of a request. */
@interface XSYProgressResponse : NSObject

/** Initializes a `XSYProgressResponse`. */
+ (instancetype)responseWithProgress:(nullable NSProgress *)progress response:(nullable XSYResponse *)response;

/** The optional response of the request. */
@property (nullable, readonly, nonatomic, strong) XSYResponse *response;

/** An object that conveys ongoing progress for a given request. */
@property (nullable, readonly, nonatomic, strong) NSProgress *progressObj;

/** The fraction of the overall work completed by the progress object. */
@property (readonly, nonatomic, assign) double progress;

/** A Boolean value stating whether the request is completed. */
@property (readonly, nonatomic, assign) BOOL completed;

@end

NS_ASSUME_NONNULL_END
