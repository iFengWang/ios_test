//
//  ModuleManager.h
//  test
//
//  Created by 王广峰 on 2018/3/12.
//  Copyright © 2018年 frank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModuleManager : NSObject
+ (instancetype)shardInstance;
- (void)loadWithUrl:(NSURL*)url Operation:(NSDictionary*)param;
- (id)callWithTarget:(NSString*)targetName Action:(NSString*)actionName Param:(NSDictionary*)param isCacheTarget:(BOOL)isCacheTarget;
@end
