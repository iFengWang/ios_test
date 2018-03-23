//
//  XSYRequestTask.m
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYRequestTask.h"

@implementation XSYRequestTask

+ (instancetype)taskWithRequestSerializerType:(XSYRequestSerializerType)requestSerializer {
    return [[XSYRequestTask alloc] initWithRequestSerializerType:requestSerializer];
}

- (instancetype)initWithRequestSerializerType:(XSYRequestSerializerType)requestSerializer {
    if (self = [super init]) {
        _requestSerializer = requestSerializer;
    }
    return self;
}

- (XSYTaskType)type {
    return XSYTaskRequest;
}

@end

@implementation XSYUploadFileTask

- (XSYTaskType)type {
    return XSYTaskUploadFile;
}

@end

@implementation XSYUploadFormDataTask

- (XSYTaskType)type {
    return XSYTaskUploadFormData;
}

@end

@implementation XSYDownloadTask

- (XSYTaskType)type {
    return XSYTaskDownload;
}

@end
