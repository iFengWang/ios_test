//
//  XSYResult.m
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYResult.h"

@implementation XSYResult

+ (instancetype)resultWithValue:(id)value {
    return [[self alloc] initWithValue:value error:nil];
}

+ (instancetype)resultWithError:(NSError *)error {
    return [[self alloc] initWithValue:nil error:error];
}

- (instancetype)initWithValue:(id _Nullable)value error:(NSError *_Nullable)error {
    if (self = [super init]) {
        _value = value;
        _error = error;
    }
    return self;
}

@end
