//
//  XSYEnterpriseRecommendedView.h
//  ingage
//
//  Created by 朱洪伟 on 2018/3/5.
//  Copyright © 2018年 com. All rights reserved.
//
/*
 企业推荐组件
 */
#import <UIKit/UIKit.h>
#import "XSYEntityDetailInterface.h"


@interface XSYEnterpriseRecommendedView : UIView<XSYEntityDetailComponent>
@property(nonatomic,copy) void (^actionAllNext)();
- (void)actionAllBlock:(void (^)())completion;
@end
