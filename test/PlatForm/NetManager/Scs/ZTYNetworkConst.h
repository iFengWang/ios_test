//
//  ZTYNetworkConst.h
//  test
//
//  Created by 王广峰 on 2018/3/23.
//  Copyright © 2018年 frank. All rights reserved.
//

#ifndef ZTYNetworkConst_h
#define ZTYNetworkConst_h

typedef NSDictionary<NSString*, id> ZTYRequestParams;
typedef NSDictionary<NSString*, NSString*> ZTYRequestHeaders;

typedef NS_ENUM(NSInteger, ZTYTaskType) {
    ZTYTaskRequest = 0,
    ZTYTaskUpload = 1,
    ZTYTaskDown = 2,
};

typedef NS_ENUM(NSInteger, ZTYRequestSerializerType) {
    ZTYRequestSerializerRAW = 0,
    ZTYRequestSerializerJSON = 1,
    ZTYRequestSerializerPlist = 2,
};

typedef NS_ENUM(NSInteger, ZTYHttpMethodType) {
    ZTYHttpMethodGET = 0,
    ZTYHttpMethodPOST = 1,
    ZTYHttpMethodPUP = 2,
    ZTYHttpMethodHEAD = 3,
    ZTYHttpMethodDELETE = 4,
    ZTYHttpMethodPATCH = 5,
    
};



@protocol ZTYTargetInterface<NSObject>
@property (readonly, nonatomic, strong) NSURL * baseUrl;
@property (readonly, nonatomic, copy) NSString * path;
@property (readonly, nonatomic, assign) ZTYHttpMethodType type;
@property (readonly, nonatomic, strong) ZTYRequestParams *params;
@property (readonly, nullable, nonatomic, strong) ZTYRequestHeaders *headers;
@end

#endif /* ZTYNetworkConst_h */
