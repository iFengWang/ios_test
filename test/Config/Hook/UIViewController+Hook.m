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
            class_replaceMethod(selfClass, custSel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
            method_exchangeImplementations(origMethod, custMethod);
        }
    });
}

- (void)quickSqrtWithAry:(NSMutableArray*)ary Left:(NSInteger)left Right:(NSInteger)right {
    if (left >= right) return;
    NSInteger pl = left;
    NSInteger pr = right;
    NSInteger mid = [ary[left] integerValue];
    
    while(pl != pr) {
        while ([ary[pr] integerValue]>=mid && pr>pl) {pr--;}
        while ([ary[pl] integerValue]<=mid && pl<pr) {pl++;}
        if (pl<pr) {
            NSNumber *tmp = ary[pl];
            ary[pl] = ary[pr];
            ary[pr] = tmp;
        }
    }
    
    NSNumber *tmp = ary[pl];
    ary[pl] = @(mid);
    ary[left] = tmp;
    
    [self quickSqrtWithAry:ary Left:left Right:pl-1];
    [self quickSqrtWithAry:ary Left:pl+1 Right:right];
}


#pragma mark - hook collection
- (void)viewWillAppearHook:(BOOL)isAnimation {
    NSLog(@"hook1..........................");
    //快速排序
    NSMutableArray *ary = [NSMutableArray arrayWithObjects:@5, @3, @9, @2, @8, @4, @7, @6, @1, nil];
    NSLog(@"1.....%@",ary);
    [self quickSqrtWithAry:ary Left:0 Right:ary.count-1];
    NSLog(@"2.....%@",ary);
    
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
