//
//  XSYMultipartProvider.m
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYMultipartProvider.h"

@implementation XSYMultipartProvider

- (instancetype)initWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    if (self = [super init]) {
        _name = name;
        _fileName = fileName;
        _mimeType = mimeType;
    }
    return self;
}

@end

@implementation XSYFileMultipart

- (instancetype)initWithFileURL:(NSURL *)fileURL
                           name:(NSString *)name
                       fileName:(NSString *)fileName
                       mimeType:(NSString *)mimeType {
    if (self = [super initWithName:name fileName:fileName mimeType:mimeType]) {
        _url = fileURL;
    }
    return self;
}

- (XSYMultipartType)type {
    return XSYMultipartFile;
}

@end

@implementation XSYDataMultipart

- (instancetype)initWithData:(NSData *)data
                        name:(NSString *)name
                    fileName:(NSString *)fileName
                    mimeType:(NSString *)mimeType {
    if (self = [super initWithName:name fileName:fileName mimeType:mimeType]) {
        _data = data;
    }
    return self;
}

- (XSYMultipartType)type {
    return XSYMultipartData;
}

@end
