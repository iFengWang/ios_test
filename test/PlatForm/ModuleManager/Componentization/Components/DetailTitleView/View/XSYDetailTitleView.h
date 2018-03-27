//
//  XSYDetailTitleView.h
//  ingage
//
//  Created by 朱洪伟 on 2018/2/26.
//  Copyright © 2018年 com. All rights reserved.
//
/*
 详情页头部和标题组件
 用来标示一条数据最关键信息的组件。通过此组件，用户能够很明显的识别出当前访问的是哪条数据
 */
#import "XSYEntityDetailInterface.h"
#import <UIKit/UIKit.h>
@class XSYDetailTitleLabelModel;
@protocol XSYDetailTitleViewDelegate;
@interface XSYDetailTitleView : UIView <XSYEntityDetailComponent>

@property (nonatomic, weak) id<XSYDetailTitleViewDelegate> delegate;

@end

@protocol XSYDetailTitleViewDelegate <NSObject>

@optional
;
- (void)XSYDetailTitleViewDidClickItem:(XSYDetailTitleLabelModel *)labelModel;

@end
