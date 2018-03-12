//
//  NetManager.h
//  test
//
//  Created by 王广峰 on 2018/2/24.
//  Copyright © 2018年 frank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequest.h"

typedef void (^onSuccess)(id data, NSURLResponse *response);
typedef void (^onFail)(NSError *error);

@interface NetManager : NSObject
+ (instancetype)shardInstance;
- (void)callApiWithNetRequest:(NetRequest*)netRequest success:(onSuccess)success fail:(onFail)fail;
@end
