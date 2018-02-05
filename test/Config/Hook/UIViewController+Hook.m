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
    
    [self createClass];
    
    [self viewWillAppearHook:isAnimation];
}

#pragma mark - dynamic create class
- (void)createClass {
    Class MyClass = objc_allocateClassPair([NSObject class], "anClass", 0);
    if (class_addIvar(MyClass, "title", sizeof(NSString **), 0, "@")) {
        NSLog(@"create property title success!");
    }
    
    if (class_addMethod(MyClass, @selector(showMessageSelector:), (IMP)showMessage, "v@:")) {
        NSLog(@"create method showMessage success!");
    }
    objc_registerClassPair(MyClass);
    
    id obj = [[MyClass alloc] init];
    [obj setValue:@"frank" forKey:@"title"];
    [obj showMessageSelector:10];
}

static void showMessage(id self, SEL _cmd, int p) {
    Ivar varKey = class_getInstanceVariable([self class], "title");
    id varValue = object_getIvar(self, varKey);
    NSLog(@"key: %@.....value: %d", varValue, p);
}

@end
