//
//  XSYWorkFlowView.m
//  ingage
//
//  Created by 朱洪伟 on 2018/3/2.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYWorkFlowView.h"
#import "XSYWorkFlowViewModel.h"
#import "Masonry.h"
@interface XSYWorkFlowView ()
@property (nonatomic,strong)UIImageView * titleImg;
@property (nonatomic,strong)UILabel * titleLable;
@property (nonatomic,strong)UIView * commintView;
@property (nonatomic,strong)UIView * rightView;
@property (nonatomic,strong)UILabel * tagText;
@property (nonatomic,assign)BOOL isShowTag;
@property (nonatomic,strong)UIImageView * tagArrowimg;
@property (nonatomic,strong)UILabel * tagTextLable;
@end

@implementation XSYWorkFlowView

-(id)init{
    self = [super init];
    if (self) {
        
        [self installView];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = RGBCOLOR(240, 240, 240);
        [self installView];
    }
    return self;
}

- (void)installView{
    self.backgroundColor = RGBCOLOR(240, 240, 240);
    
    [self addSubview:self.titleImg];
    [self.titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).with.offset(10);
        make.height.width.mas_equalTo(18);
    }];
    self.titleLable.text = @"当前状态：未认证 >";
    [self addSubview:self.titleLable];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(10));
        make.left.equalTo(self.titleImg.mas_right).with.offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(150);
    }];

}
- (void)setModel:(id)model{

    XSYWorkFlowViewModel * data = model;
    if (data.flowType==WorkFlowTypeStart) { //开始
        [self addSubview:self.rightView];
        [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(10));
            make.right.equalTo(self.mas_right).with.offset(-15);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(70);
        }];
        self.tagText.text = @"初始操作";
        [self.rightView addSubview:self.tagText];
        [self.tagText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(0));
            make.left.equalTo(@(0));
            make.height.width.equalTo(self.rightView);
        }];
        self.titleLable.textColor =RGBCOLOR(111, 172, 238);
        self.titleLable.text = @"当前状态：未认证 >";
    }else if(data.flowType==WorkFlowTypeShow){ //可展开
        [self addSubview:self.rightView];
        [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(10));
            make.right.equalTo(self.mas_right).with.offset(-15);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(70);
        }];
        self.rightView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectMoreAction:)];
        [self.rightView addGestureRecognizer:tapGesturRecognizer];
        
        self.tagArrowimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"opportunity_stage_title_arrow_down"]];
        [self.rightView addSubview:self.tagArrowimg];
        [self.tagArrowimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.rightView.mas_right).with.offset(-15);
            make.height.mas_equalTo(10);
            make.width.mas_equalTo(15);
        }];
        
        self.tagTextLable = [ViewCreatorHelper createLabelWithTitle:@"" font:[UIFont systemFontOfSize:15.0f] frame:CGRectZero textColor:RGBCOLOR(51, 51, 51) textAlignment:NSTextAlignmentLeft];
        [self.rightView addSubview:self.tagTextLable];
        self.tagTextLable.text = @"推进";
        [self.tagTextLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.tagArrowimg.mas_left);
            make.left.equalTo(self.rightView.mas_left);
            make.height.equalTo(self.rightView);
        }];
         self.titleLable.textColor =RGBCOLOR(111, 172, 238);
        self.titleLable.text = @"当前状态：认证中 >";
    }else if(data.flowType==WorkFlowTypeNone){ //空
       
        self.titleLable.textColor = RGBCOLOR(74, 163, 83);
        self.titleLable.text = @"当前状态：认证通过 >";
    }else if(data.flowType==WorkFlowTypeFiled){ //重新认证
        self.titleLable.textColor = RGBCOLOR(255, 0, 0);
        self.titleLable.text = @"当前状态：认证失败 >";
        
        [self addSubview:self.rightView];
        [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(10));
            make.right.equalTo(self.mas_right).with.offset(-15);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(70);
        }];
        self.tagText.text = @"重新认证";
        [self.rightView addSubview:self.tagText];
        [self.tagText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(0));
            make.left.equalTo(@(0));
            make.height.width.equalTo(self.rightView);
        }];
    }

}
- (void)selectMoreAction:(id)obj{
    self.isShowTag = !self.isShowTag;
    if (!self.isShowTag) {
        self.tagArrowimg.image = [UIImage imageNamed:@"opportunity_stage_title_arrow_down"];
        self.tagTextLable.text = @"推进";
    }else{
        self.tagArrowimg.image = [UIImage imageNamed:@"opportunity_stage_title_arrow_up"];
        self.tagTextLable.text = @"收起";
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
- (NSString *)viewID {
    return @"";
}
-(UIImageView*)titleImg{
    if (!_titleImg) {
        UIImage * img = [UIImage imageNamed:@"indexmore_followup_workFlow"];
        _titleImg = [[UIImageView alloc] initWithImage:img];
    }
    return _titleImg;
}
-(UILabel*)titleLable{
    if (!_titleLable) {
        _titleLable = [ViewCreatorHelper createLabelWithTitle:@"" font:[UIFont systemFontOfSize:15.0f] frame:CGRectZero textColor:RGBCOLOR(51, 51, 51) textAlignment:NSTextAlignmentLeft];
    }
    return _titleLable;
}
- (UIView*)rightView{
    if (!_rightView) {
        _rightView = [UIView new];
        _rightView.backgroundColor = RGBCOLOR(84, 171, 235);
        _rightView.layer.masksToBounds = YES;
        _rightView.layer.cornerRadius = 5;
    
    }
    return _rightView;
}
-(UILabel*)tagText{
    if (!_tagText) {
        _tagText = [ViewCreatorHelper createLabelWithTitle:@"" font:[UIFont systemFontOfSize:14.0f] frame:CGRectZero textColor:RGBCOLOR(255, 255, 255) textAlignment:NSTextAlignmentCenter];
    }
    return _tagText;
}
@end
