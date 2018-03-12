//
//  ModuleManager.m
//  test
//
//  Created by 王广峰 on 2018/3/12.
//  Copyright © 2018年 frank. All rights reserved.
//

#import "ModuleManager.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)

@interface ModuleManager()
@property (nonatomic, strong) NSMutableDictionary * targetCache;
- (id)performWithTarget:(NSObject*)target Selector:(SEL)action Param:(NSDictionary*)params;
@end

@implementation ModuleManager

+ (instancetype)shardInstance {
    static ModuleManager *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[ModuleManager alloc] init];
    });
    return m;
}

#pragma mark - App 外部 调用模块
- (void)loadWithUrl:(NSURL*)url Operation:(NSDictionary*)param {
//      鉴权，解析url和param，当老版本没有对应URL时提示到别处逛逛。
//    id target = nil;
//    SEL selector = nil;
//    NSDictionary *p = nil;
}

#pragma mark - App 内部 调用模块
- (id)callWithTarget:(NSString*)targetName Action:(NSString*)actionName Param:(NSDictionary*)param isCacheTarget:(BOOL)isCacheTarget {
    
    NSString * classString = [NSString stringWithFormat:@"Target_%@:",targetName];
    NSString * actionString = [NSString stringWithFormat:@"Action_%@:",actionName];
    Class targetClass;
    
    id target = self.targetCache[classString];
    if (target == nil) {
        targetClass = NSClassFromString(classString);
        target = [[targetClass alloc] init];
        if (target == nil) {
            //转向到特定target
            return nil;
        }
        if (isCacheTarget) self.targetCache[classString] = target;
    }
    
    SEL action = NSSelectorFromString(actionString);
    
    if ([target respondsToSelector:action]) {
        return [self performWithTarget:target Selector:action Param:param];
    } else {
        // 有可能target是Swift对象
        actionString = [NSString stringWithFormat:@"Action_%@WithParams:", actionName];
        action = NSSelectorFromString(actionString);
        if ([target respondsToSelector:action]) {
            return [self performWithTarget:target Selector:action Param:param];
        } else {
            // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
            SEL action = NSSelectorFromString(@"notFound:");
            if ([target respondsToSelector:action]) {
                return [self performWithTarget:target Selector:action Param:param];
            } else {
                // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
                [self.targetCache removeObjectForKey:classString];
                return nil;
            }
        }
    }
}

- (id)performWithTarget:(NSObject*)target Selector:(SEL)action Param:(NSDictionary*)params {
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
    return nil;
}

#pragma mark - getter && setter
- (NSMutableDictionary *)targetCache {
    if (_targetCache) {
        _targetCache = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _targetCache;
}

@end
