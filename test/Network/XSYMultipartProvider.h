//
//  XSYMultipartProvider.h
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XSYMultipartType) {
    XSYMultipartFile = 0,
    XSYMultipartData = 1,
};

/**
 Represents "multipart/form-data" for an upload.
 */
@interface XSYMultipartProvider : NSObject

- (instancetype)initWithName:(NSString *)name
                    fileName:(nullable NSString *)fileName
                    mimeType:(nullable NSString *)mimeType;

@property (readonly, nonatomic, copy) NSString *name;

@property (nullable, readonly, nonatomic, copy) NSString *fileName;

@property (nullable, readonly, nonatomic, copy) NSString *mimeType;

@property (readonly, nonatomic, assign) XSYMultipartType type;

@end

@interface XSYFileMultipart : XSYMultipartProvider

- (instancetype)initWithFileURL:(NSURL *)fileURL
                           name:(NSString *)name
                       fileName:(nullable NSString *)fileName
                       mimeType:(nullable NSString *)mimeType;

@property (readonly, nonatomic, strong) NSURL *url;

@end

@interface XSYDataMultipart : XSYMultipartProvider

- (instancetype)initWithData:(NSData *)data
                        name:(NSString *)name
                    fileName:(nullable NSString *)fileName
                    mimeType:(nullable NSString *)mimeType;

@property (readonly, nonatomic, strong) NSData *data;

@end

NS_ASSUME_NONNULL_END
