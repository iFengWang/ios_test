//
//  XSYProcessVisualView.h
//  ingage
//
//  Created by 朱洪伟 on 2018/3/2.
//  Copyright © 2018年 com. All rights reserved.
//
/*
 流程可视化组件
 */
#import <UIKit/UIKit.h>
#import "XSYEntityDetailInterface.h"


@interface XSYProcessVisualView : UIView<XSYEntityDetailComponent>

@property(nonatomic,copy) void (^actionProcessNext)(NSInteger tag);
- (void)actionProcessBlock:(void (^)(NSInteger tag))completion;
@end
