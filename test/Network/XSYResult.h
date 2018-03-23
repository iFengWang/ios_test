//
//  XSYResult.h
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XSYResult <__covariant ObjectType> : NSObject

+ (instancetype)resultWithValue:(ObjectType)value;

+ (instancetype)resultWithError:(NSError *)error;

@property (nullable, readonly, nonatomic, strong) ObjectType value;

@property (nullable, readonly, nonatomic, strong) NSError *error;

@end

NS_ASSUME_NONNULL_END
