//
//  XSYRequestTask+Internal.h
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYRequestTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface XSYRequestTask (Internal)

@property (readonly, nonatomic, strong) AFHTTPRequestSerializer *xsy_requestSerializer;

//@property (readonly, nonatomic, strong) AFHTTPResponseSerializer *xsy_responseSerializer;

@end

NS_ASSUME_NONNULL_END
