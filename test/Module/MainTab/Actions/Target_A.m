//
//  Target_A.m
//  test
//
//  Created by Frank on 2018/3/12.
//  Copyright © 2018年 frank. All rights reserved.
//

#import "Target_A.h"
#import "ViewController.h"

@implementation Target_A
- (UIViewController*)Action_nativeCreateAnViewController:(NSDictionary*)param {
    ViewController * vc = [[ViewController alloc] init];
    return vc;
}
@end
