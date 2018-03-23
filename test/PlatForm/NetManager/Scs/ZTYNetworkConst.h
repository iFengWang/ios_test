//
//  ZTYNetworkConst.h
//  test
//
//  Created by 王广峰 on 2018/3/23.
//  Copyright © 2018年 frank. All rights reserved.
//

#ifndef ZTYNetworkConst_h
#define ZTYNetworkConst_h

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

#endif /* ZTYNetworkConst_h */
