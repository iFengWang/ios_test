//
//  XSYEnterpriseRecommendedCell.m
//  ingage
//
//  Created by 朱洪伟 on 2018/3/6.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYEnterpriseRecommendedCell.h"
@interface XSYEnterpriseRecommendedCell()
@property (nonatomic,strong)UIView * backView;
@property (nonatomic,strong)UIImageView * centerImg;
@property (nonatomic,strong)UILabel * centerTextLable;
@property (nonatomic,strong)UILabel * desTextlable;
@property (nonatomic,strong)UIButton * deleteButton;
- (void)selectCloseAciton:(id)button;
- (void)selectDetailAction:(id)button;
@end

@implementation XSYEnterpriseRecommendedCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backView];
        self.centerImg.backgroundColor = RGBCOLOR(230, 230, 230);
        [self.backView addSubview:self.centerImg];
        [self.backView addSubview:self.centerTextLable];
        [self.backView addSubview:self.desTextlable];
        [self.backView addSubview:self.deleteButton];
    }
    return self;
}
- (void)setModel:(XSYEnterpriseRecommendedModel*)model{
    self.centerTextLable.text = @"测试测试测试测试测试测试测试测试";
}
- (void)selectCloseAciton:(id)button{
    if ([self.delegate respondsToSelector:@selector(enterpriseDeleteAlction)]) {
        [self.delegate enterpriseDeleteAlction];
    }
}
- (void)selectDetailAction:(id)button{
    if ([self.delegate respondsToSelector:@selector(gotoEnterpriseDetailAlction)]) {
        [self.delegate gotoEnterpriseDetailAlction];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rc = self.bounds;
    rc.origin.x = 10;
    rc.origin.y = 10;
    rc.size.width-= 20;
    rc.size.height-= 20;
    self.backView.frame = rc;
    
    CGFloat imgW =self.backView.width/2;
    rc.origin.x = (self.backView.width-imgW)/2;
    rc.origin.y = 5;
    rc.size.width = imgW;
    rc.size.height = imgW;
    self.centerImg.frame = rc;
    self.centerImg.layer.masksToBounds = YES;
    self.centerImg.layer.cornerRadius = imgW/2;
    
    rc.origin.x = 10;
    rc.origin.y = self.centerImg.bottom+5;
    rc.size.width = self.backView.width-20;
    rc.size.height = 37;
    self.centerTextLable.frame = rc;
    
    rc.origin.x = (self.backView.width-70)/2;
    rc.origin.y = self.centerTextLable.bottom+5;
    rc.size.width = 72;
    rc.size.height = 20;
    self.desTextlable.frame = rc;
    
    rc.origin.x = self.backView.width-28;
    rc.origin.y = 5;
    rc.size.width = 18;
    rc.size.height = 18;
    self.deleteButton.frame = rc;
}
- (UIView*)backView{
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 10;
        UITapGestureRecognizer * tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDetailAction:)];
        [_backView addGestureRecognizer:tapGesturRecognizer];
    }
    return _backView;
}
- (UIImageView*)centerImg{
    if (!_centerImg) {
        _centerImg = [UIImageView new];
    }
    return _centerImg;
}
-(UILabel*)centerTextLable{
    if (!_centerTextLable) {
        _centerTextLable = [ViewCreatorHelper createLabelWithTitle:@"" font:[UIFont systemFontOfSize:15.0] frame:CGRectZero textColor:RGBCOLOR(51, 51, 51) textAlignment:NSTextAlignmentCenter];
        _centerTextLable.numberOfLines = 2;
    }
    return _centerTextLable;
}
-(UILabel*)desTextlable{
    if (!_desTextlable) {
        _desTextlable = [ViewCreatorHelper createLabelWithTitle:@"相同投资方" font:[UIFont systemFontOfSize:13.0] frame:CGRectZero textColor:RGBCOLOR(156, 171, 181) textAlignment:NSTextAlignmentCenter];
        _desTextlable.backgroundColor = RGBCOLOR(246, 246, 246);
        _desTextlable.layer.masksToBounds = YES;
        _desTextlable.layer.cornerRadius = 10;
    }
    
    return _desTextlable;
}
- (UIButton*)deleteButton{
    if (!_deleteButton) {
        UIImage * img = [UIImage imageNamed:@"ad_closebutton"];
        _deleteButton = [ViewCreatorHelper createButtonWithTitle:nil frame:CGRectZero image:img hlImage:img disImage:img target:self action:@selector(selectCloseAciton:)];
    }
    return _deleteButton;
}

@end
