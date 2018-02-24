//
//  OneAdaptor.m
//  test
//
//  Created by 王广峰 on 2018/2/24.
//  Copyright © 2018年 frank. All rights reserved.
//

#import "OneAdaptor.h"

@implementation OneAdaptor
- (NSDictionary *)reformDataWithNetRequest:(NetRequest *)netRequest {
    NSDictionary * result = @{
                              @"a":netRequest.param[@"one"],
                              @"b":netRequest.param[@"two"]
                              };
    return result;
}
@end
