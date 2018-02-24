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
//        Class origClass = objc_getClass([self class]);
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
//    [self createClass];
    [self viewWillAppearHook:isAnimation];
}

#pragma mark - dynamic create class
- (void)createClass {
    Class MyClass = objc_allocateClassPair([NSObject class], "MyClass", 0);
    
    //添加成员变量
    if (class_addIvar(MyClass, "title", sizeof(NSString **), 0, "@")) {
        NSLog(@"create property title success!");
    }
    
    //添加属性
    objc_property_attribute_t type = { "T", "@\"NSString\"" };
    objc_property_attribute_t isCopy = { "C", "" }; // C = copy
    objc_property_attribute_t ownership = { "N", "" }; // N = nonatomic
    objc_property_attribute_t backingivar  = { "V", "_privateName" };
    objc_property_attribute_t attrs[] = { type, isCopy, ownership, backingivar };
    BOOL isOk = class_addProperty(MyClass, "detail", attrs, 4);
    if (isOk) {
        //
    }
    
    class_addMethod(MyClass, @selector(getDetail), (IMP)nameGetter, "@@:");
    class_addMethod(MyClass, @selector(setDetail:), (IMP)nameSetter, "v@:@");

    //添加方法
    if (class_addMethod(MyClass, @selector(showMessageSelector:), (IMP)showMessage, "v@:")) {
        NSLog(@"create method showMessage success!");
    }
    objc_registerClassPair(MyClass);
    
    id obj = [[MyClass alloc] init];
    [obj setValue:@"frank" forKey:@"title"];    //给成员变量赋值
    [obj setDetail:@"动态方法"];               //给属性赋值
    NSLog(@"property........%@", [obj getDetail]);
    [obj showMessageSelector:10];
}

- (void)showMessageSelector:(int)p {}

static void showMessage(id self, SEL _cmd, int p) {
    Ivar varKey = class_getInstanceVariable([self class], "title");
    id varValue = object_getIvar(self, varKey);
    NSLog(@"varValue: %@.....p: %d", varValue, p);
    
//    objc_property_t detail = class_getProperty([self class], "detail");
//    NSLog(@"property....%s.....%s", property_getName(detail), property_getAttributes(detail));
}

- (NSString*)getDetail {return @"";}
- (void)setDetail:(NSString*)detail {}

//get方法
NSString *nameGetter(id self, SEL _cmd) {
    Ivar ivar = class_getInstanceVariable([self class], "_privateName");
    return object_getIvar(self, ivar);
}

//set方法
void nameSetter(id self, SEL _cmd, NSString *newName) {
    Ivar ivar = class_getInstanceVariable([self class], "_privateName");
    id oldName = object_getIvar(self, ivar);
    if (oldName != newName) object_setIvar(self, ivar, [newName copy]);
}

@end
