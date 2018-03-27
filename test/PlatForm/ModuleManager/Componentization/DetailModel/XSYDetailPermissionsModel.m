



//
//  XSYDetailPermissionsModel.m
//  ingage
//
//  Created by 朱洪伟 on 2018/3/14.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYDetailPermissionsModel.h"

@implementation XSYDetailPermissionsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    //特殊字断映射
    return @{@"layoutId":@"id",
             @"useDescription":@"description"
             };
}
@end
