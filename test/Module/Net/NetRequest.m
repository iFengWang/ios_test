//
//  NetRequest.m
//  test
//
//  Created by 王广峰 on 2018/2/24.
//  Copyright © 2018年 frank. All rights reserved.
//

#import "NetRequest.h"
#import "NetManager.h"

@implementation NetRequest

#pragma mark - call api function
- (void)callApiWithParam:(NSDictionary*)param {
    NetManager * manager = [NetManager shardInstance];
    [manager callApiWithNetRequest:self success:^(id data, NSURLResponse *response) {
        if ([self.delegate respondsToSelector:@selector(onSuccessWithNetRequest:)]) {
            [self.delegate onSuccessWithNetRequest:self];
        }
    } fail:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(onFailWithNetRequest:)]) {
            [self.delegate onFailWithNetRequest:self];
        }
    }];
}

- (NSDictionary *)fetchDataWithAdaptor:(id<AdaptorProtocol>)adaptor {
    return [adaptor reformDataWithNetRequest:self];
}

@end
