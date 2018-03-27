//
//  TitleViewContentLabel.h
//  ingage
//
//  Created by 邹功梁 on 2018/3/15.
//  Copyright © 2018年 com. All rights reserved.
//

#import "UIImage+SVG.h"
#import "XSYDetailTitleLayout.h"
#import <UIKit/UIKit.h>
#import <YYText/YYText.h>
@protocol TitleViewContentLabelDelegate;
@interface TitleViewContentLabel : UIView

@property (nonatomic, strong) YYLabel *itemNameLabel;
@property (nonatomic, strong) YYLabel *itemValueLabel;
@property (nonatomic, strong) UIButton *moreActionIcon;
@property (nonatomic, weak) id<TitleViewContentLabelDelegate> delegate;
@property (nonatomic, strong) XSYDetailTitleLabelModelLayout *labelLayout;

@end

@protocol TitleViewContentLabelDelegate <NSObject>

@optional
;
- (void)didClickItemValueLabel:(YYLabel *)itemValueLabel textRange:(NSRange)textRange;

@end
