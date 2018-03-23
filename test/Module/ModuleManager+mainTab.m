//
//  ModuleManager+mainTab.m
//  test
//
//  Created by 王广峰 on 2018/3/12.
//  Copyright © 2018年 frank. All rights reserved.
//

#import "ModuleManager+mainTab.h"

NSString * const kA = @"A";
NSString * const kCreateViewController = @"nativeCreateAnViewController";

@implementation ModuleManager (mainTab)
- (UIViewController*)mainTabViewController {
    return [self callWithTarget:kA Action:kCreateViewController Param:@{} isCacheTarget:YES];
}
@end
