//
//  XSYNetworkConst.h
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#ifndef XSYNetworkConst_h
#define XSYNetworkConst_h

#import <AFNetworking.h>

typedef AFURLSessionManager Manager;

#define XSY_SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })

/**
 Types enum for XSYRequest.
 */
typedef NS_ENUM(NSInteger, XSYRequestType) {
    XSYRequestNormal = 0,   ///< Normal HTTP request type, such as GET, POST, ...
    XSYRequestUpload = 1,   ///< Upload request type
    XSYRequestDownload = 2, ///< Download request type
};

/**
 HTTP methods enum for XSYRequest.
 */
typedef NS_ENUM(NSUInteger, XSYHTTPMethodType) {
    XSYHTTPMethodGET = 0,    ///< GET
    XSYHTTPMethodPOST = 1,   ///< POST
    XSYHTTPMethodHEAD = 2,   ///< HEAD
    XSYHTTPMethodDELETE = 3, ///< DELETE
    XSYHTTPMethodPUT = 4,    ///< PUT
    XSYHTTPMethodPATCH = 5,  ///< PATCH
};

typedef NS_ENUM(NSInteger, XSYRequestSerializerType) {
    XSYRequestSerializerRAW = 0,   ///< Encodes parameters to a query string and put it into HTTP body, setting the
                                   ///< `Content-Type` of the encoded request to default value
                                   ///< `application/x-www-form-urlencoded`.
    XSYRequestSerializerJSON = 1,  ///< Encodes parameters as JSON using `NSJSONSerialization`, setting the
                                   ///< `Content-Type` of the encoded request to `application/json`.
    XSYRequestSerializerPlist = 2, ///< Encodes parameters as Property List using `NSPropertyListSerialization`, setting
                                   ///< the `Content-Type` of the encoded request to `application/x-plist`.
};

// typedef NS_ENUM(NSInteger, XSYResponseSerializerType) {
//    XSYResponseSerializerRAW =
//        0, ///< Validates the response status code and content type, and returns the default response data.
//    XSYResponseSerializerJSON = 1,  ///< Validates and decodes JSON responses using `NSJSONSerialization`, and returns
//    a
//                                    ///< NSDictionary/NSArray/... JSON object.
//    XSYResponseSerializerPlist = 2, ///< Validates and decodes Property List responses using
//                                    ///< `NSPropertyListSerialization`, and returns a property list object.
//    XSYResponseSerializerXML = 3,   ///< Validates and decodes XML responses as an `NSXMLParser` objects.
//};

NS_ASSUME_NONNULL_BEGIN

typedef NSDictionary<NSString *, id> XSYParameters;

typedef NSDictionary<NSString *, NSString *> XSYHttpHeaderFields;

@class XSYRequestTask;

@protocol XSYTargetInterface <NSObject>

@property (readonly, nonatomic, strong) NSURL *baseURL;

@property (readonly, nonatomic, copy) NSString *path;

@property (readonly, nonatomic, assign) XSYHTTPMethodType method;

@property (readonly, nullable, nonatomic, strong) XSYParameters *parameters;

@property (readonly, nullable, nonatomic, strong) XSYHttpHeaderFields *headers;

@property (readonly, nonatomic, strong) XSYRequestTask *task;

@end

/** Protocol to define the opaque type returned from a request. */
@protocol CancellableInterface <NSObject>

/** A Boolean value stating whether a request is cancelled. */
@property (readonly, nonatomic, assign) BOOL isCancelled;

/** Cancels the represented request. */
- (void)cancel;

@end

@class XSYResponse, XSYResult<__covariant ObjectType>;
@protocol XSYRequestTypeInterface;

/**
 A plugin receives callbacks to perform side effects wherever a request is sent or received.
 */
@protocol XSYPluginInterface <NSObject>

@optional

/**
 Called to modify a request before sending.
 */
- (NSURLRequest *)prepare:(NSURLRequest *)request target:(id<XSYTargetInterface>)target;

/**
 Called immediately before a request is sent over the network (or stubbed).
 */
- (void)willSend:(id<XSYRequestTypeInterface>)requestType target:(id<XSYTargetInterface>)target;

/**
 Called after a response has been received, but before the `XSYProvider` has invoked its completion handler.
 */
- (void)didReceive:(XSYResult<XSYResponse *> *)result target:(id<XSYTargetInterface>)target;

/**
 Called to modify a result before completion.
 */
- (XSYResult<XSYResponse *> *)process:(XSYResult<XSYResponse *> *)result target:(id<XSYTargetInterface>)target;

@end

/**
 Request type used by `willSend` plugin function.

 Note: Only the last authentication plugin is valid.
 */
@protocol XSYRequestTypeInterface <NSObject>

/**
 Retrieve an `NSURLRequest` representation.
 */
@property (readonly, nonatomic, strong) NSURLRequest *request;

/**
 Authenticates the request with a username and password.
 */
- (id<XSYRequestTypeInterface>)authenticateUser:(NSString *)user
                                       password:(NSString *)password
                                    persistence:(NSURLCredentialPersistence)persistence;

/**
 Authenticates the request with an `NSURLCredential` instance.
 */
- (id<XSYRequestTypeInterface>)authenticateWithCredential:(NSURLCredential *)credential;

@end

NS_ASSUME_NONNULL_END

#endif /* XSYNetworkConst_h */
