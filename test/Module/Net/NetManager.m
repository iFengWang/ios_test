//
//  NetManager.m
//  test
//
//  Created by 王广峰 on 2018/2/24.
//  Copyright © 2018年 frank. All rights reserved.
//

#import "NetManager.h"

@interface NetManager()
@property (nonatomic, strong) NSURLSession * netManager;
@end

@implementation NetManager

+ (instancetype)shardInstance {
    static NetManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
            instance.netManager = [NSURLSession sharedSession];
        }
    });
    return instance;
}

- (void)callApiWithNetRequest:(NetRequest *)netRequest success:(onSuccess)success fail:(onFail)fail {
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:netRequest.router]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:netRequest.timeoutInterval];
    NSURLSessionDataTask * task = [self.netManager dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            success(data, response);
        } else {
            fail(error);
        }
    }];
    [task resume];
}

@end
