//
//  ZTYRequestTask.m
//  test
//
//  Created by 王广峰 on 2018/3/23.
//  Copyright © 2018年 frank. All rights reserved.
//

#import "ZTYRequestTask.h"

@implementation ZTYRequestTask
+ (instancetype)taskWithRequestSerializerType:(ZTYRequestSerializerType)requestSerializer {
    return [[ZTYRequestTask alloc] initWithRequestSerializerType:requestSerializer];
}

- (instancetype)initWithRequestSerializerType:(ZTYRequestSerializerType)requestSerializer {
    if (self = [super init]) {
        _requestSerializer = requestSerializer;
    }
    return self;
}

- (ZTYTaskType)type {
    return ZTYTaskRequest;
}
@end

@implementation ZTYUploadTask
- (ZTYTaskType)type {
    return ZTYTaskUpload;
}
@end

@implementation ZTYDownloadTask
- (ZTYTaskType)type {
    return ZTYTaskDown;
}
@end
