//
//  ModuleManager+mainTab.m
//  test
//
//  Created by 王广峰 on 2018/3/12.
//  Copyright © 2018年 frank. All rights reserved.
//

#import "ModuleManager+mainTab.h"

@implementation ModuleManager (mainTab)
- (UIViewController*)mainTabViewController {
    return [self callWithTarget:@"" Action:@"" Param:@{} isCacheTarget:YES];
}
@end
