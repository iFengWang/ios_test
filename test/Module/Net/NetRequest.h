//
//  NetRequest.h
//  test
//
//  Created by 王广峰 on 2018/2/24.
//  Copyright © 2018年 frank. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NetRequest;

typedef NS_ENUM(NSInteger) {
    Get = 0,
    Post
} RequestMethod;

@protocol AdaptorProtocol <NSObject>
- (NSDictionary*)reformDataWithNetRequest:(NetRequest*)netRequest;
@end

@protocol NetRequestProtocol <NSObject>
- (void)onSuccessWithNetRequest:(NetRequest*)netRequest;
- (void)onFailWithNetRequest:(NetRequest*)netRequest;
@end

@interface NetRequest : NSURLRequest
@property (nonatomic, strong) NSString * router;
@property (nonatomic, assign) RequestMethod method;
@property (nonatomic, strong) NSDictionary * param;
@property (nonatomic, weak) id<NetRequestProtocol> delegate;

- (void)callApiWithParam:(NSDictionary*)param;
- (NSDictionary*)fetchDataWithAdaptor:(id<AdaptorProtocol>)adaptor;
@end
