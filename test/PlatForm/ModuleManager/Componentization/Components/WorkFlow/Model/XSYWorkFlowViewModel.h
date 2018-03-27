//
//  XSYWorkFlowViewModel.h
//  ingage
//
//  Created by 朱洪伟 on 2018/3/9.
//  Copyright © 2018年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSYNetwork.h"
#import "XSYEntityDetailInterface.h"

typedef NS_ENUM(NSInteger, WorkFlowViewType) {
    WorkFlowTypeStart      = 0,
    WorkFlowTypeShow       = 1, //可展开
    WorkFlowTypeNone       = 2, //空
    WorkFlowTypeFiled      = 3, //失败情况
    
} NS_ENUM_AVAILABLE_IOS(6_0);

@interface XSYWorkFlowViewModel : NSObject
@property (nonatomic,assign)WorkFlowViewType flowType; //页面进度类型

@end

@interface XSYWorkFlowViewTarget: NSObject <XSYTargetInterface, XSYRequestable>

+ (instancetype)targetWithObjectApiKey:(NSString *)apiKey recordId:(NSString *)recordId;

@end
