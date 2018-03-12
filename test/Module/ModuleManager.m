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
- (id)performWithTarget:(NSObject*)target Selector:(SEL)selector Param:(NSDictionary*)param;
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
    
    NSString * classString = [NSString stringWithFormat:@"Target_%@",targetName];
    NSString * selectorString = [NSString stringWithFormat:@"Action_%@",actionName];
    Class targetClass;
    
    id target = self.targetCache[classString];
    if (target == nil) {
        targetClass = NSClassFromString(classString);
        target = [[targetClass alloc] init];
        if (isCacheTarget) self.targetCache[classString] = target;
    }
    SEL selector = NSSelectorFromString(actionName);
    return [self performWithTarget:target Selector:selector Param:param];
}

- (id)performWithTarget:(NSObject*)target Selector:(SEL)selector Param:(NSDictionary*)param {
    
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
