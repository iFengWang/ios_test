//
//  UIViewController+Hook.m
//  test
//
//  Created by 王广峰 on 2018/2/5.
//  Copyright © 2018年 frank. All rights reserved.
//

#import "UIViewController+Hook.h"
#import <objc/runtime.h>

@implementation UIViewController (Hook)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class selfClass = [self class];
        SEL origSel = @selector(viewWillAppear:);
        Method origMethod = class_getInstanceMethod(selfClass, origSel);
        SEL custSel = @selector(viewWillAppearHook:);
        Method custMethod = class_getInstanceMethod(selfClass, custSel);
        BOOL isHave = class_addMethod(selfClass, origSel, method_getImplementation(custMethod), method_getTypeEncoding(custMethod));
        if (isHave) {
            class_addMethod(selfClass, custSel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
            method_exchangeImplementations(origMethod, custMethod);
        }
    });
}

#pragma mark - hook collection
- (void)viewWillAppearHook:(BOOL)isAnimation {
    NSLog(@"hook1..........................");
    [self viewWillAppearHook:isAnimation];
}

@end
