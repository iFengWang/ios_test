//
//  NSMutableDictionary+Hook.m
//  test
//
//  Created by 王广峰 on 2018/3/14.
//  Copyright © 2018年 frank. All rights reserved.
//

#import "NSMutableDictionary+Hook.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (Hook)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//
//        SEL oriSel = @selector(setObject:forKey:);
//        Method oriMethod = class_getInstanceMethod(class, oriSel);
//
//        SEL cusSel = @selector(hook_setObject:forKey:);
//        Method cusMethod = class_getInstanceMethod(class, cusSel);
//
//        BOOL isHave = class_addMethod(class, oriSel, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
//        if (isHave) {
//            class_replaceMethod(class, cusSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
//        } else {
//            method_exchangeImplementations(oriMethod, cusMethod);
//        }
        
        Class originalClass = NSClassFromString(@"__NSDictionaryM");
        Class swizzledClass = [self class];
        
        SEL originalSelector = @selector(setObject:forKey:);
        Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
        
        SEL swizzledSelector = @selector(safe_setObject:forKey:);
        Method swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);

        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
    
}

//- (void)hook_setObject:(id)value forKey:(NSString*)key {
//    if (value) {
//        [self hook_setObject:value forKey:key];
//    } else {
//        [self hook_setObject:[NSNull null] forKey:key];
//    }
//}

- (void)safe_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject && aKey) {
        [self safe_setObject:anObject forKey:aKey];
    }
    else if (aKey) {
//        [(NSMutableDictionary *)self removeObjectForKey:aKey];
        [self safe_setObject:@"*******" forKey:aKey];
    }
}

@end
