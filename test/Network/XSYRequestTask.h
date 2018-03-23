//
//  XSYRequestTask.h
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYNetworkConst.h"
#import <Foundation/Foundation.h>

@class XSYMultipartProvider;

typedef NS_ENUM(NSUInteger, XSYTaskType) {
    XSYTaskRequest = 0,
    XSYTaskUploadFile = 1,
    XSYTaskUploadFormData = 2,
    XSYTaskDownload = 3,
};

NS_ASSUME_NONNULL_BEGIN

@interface XSYRequestTask : NSObject

+ (instancetype)taskWithRequestSerializerType:(XSYRequestSerializerType)requestSerializer;

@property (readonly, nonatomic, assign) XSYTaskType type;

@property (readonly, nonatomic, assign) XSYRequestSerializerType requestSerializer;

@end

@interface XSYUploadFileTask : XSYRequestTask

@property (nonatomic, strong) NSURL *url;

@end

@interface XSYUploadFormDataTask : XSYRequestTask

@property (nonatomic, strong) NSArray<XSYMultipartProvider *> *formDatas;

@end

typedef NSURL * (^XSYDownloadDestinationBlock)(NSURL *targetPath, NSURLResponse *response);

typedef NS_ENUM(NSUInteger, XSYDownloadOptions) {
    XSYDownloadCreateIntermediateDirectories = 0,
    XSYDownloadRemovePreviousFile = 1,
};

@interface XSYDownloadTask : XSYRequestTask

@property (nonatomic, assign) XSYDownloadOptions options;

@property (nonatomic, copy) XSYDownloadDestinationBlock destination;

@end

NS_ASSUME_NONNULL_END
