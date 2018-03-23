//
//  XSYEndpoint.h
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYNetworkConst.h"
#import <Foundation/Foundation.h>

@class XSYMultipartProvider, XSYResult<ObjectType>, XSYRequestTask;

NS_ASSUME_NONNULL_BEGIN

/** Class for reifying a target of the `XSYTargetInterface` enum unto a concrete `XSYEndpoint`. */
@interface XSYEndpoint : NSObject

+ (instancetype)endpointWithURL:(NSString *)url
                         method:(XSYHTTPMethodType)method
                     parameters:(nullable XSYParameters *)parameters
                           task:(XSYRequestTask *)task
               httpHeaderFields:(nullable XSYHttpHeaderFields *)httpHeaderFields;

/** A string representation of the URL for the request. */
@property (readonly, nonatomic, copy) NSString *url;

/** The HTTP method for the request. */
@property (readonly, nonatomic, assign) XSYHTTPMethodType method;

/** The parameters for the request. */
@property (nullable, readonly, nonatomic, strong) XSYParameters *parameters;

/** The `XSYRequestTask` for the request. */
@property (readonly, nonatomic, strong) XSYRequestTask *task;

/** The HTTP header fields for the request. */
@property (nullable, readonly, nonatomic, strong) XSYHttpHeaderFields *httpHeaderFields;

@property (readonly, nonatomic, strong) XSYResult<NSURLRequest *> *urlRequest;

/** Convenience method for creating a new `XSYEndpoint` with the same properties as the receiver, but with added
 * parameters. */
- (XSYEndpoint *)addNewParameters:(nullable XSYParameters *)newParameters;

/** Convenience method for creating a new `XSYEndpoint` with the same properties as the receiver, but with replaced
 * `task` parameter. */
- (XSYEndpoint *)replaceNewTask:(XSYRequestTask *)newTask;

/** Convenience method for creating a new `XSYEndpoint` with the same properties as the receiver, but with added HTTP
 * header fields. */
- (XSYEndpoint *)addNewHttpHeaderFields:(nullable XSYHttpHeaderFields *)newHttpHeaderFields;

@end

NS_ASSUME_NONNULL_END
