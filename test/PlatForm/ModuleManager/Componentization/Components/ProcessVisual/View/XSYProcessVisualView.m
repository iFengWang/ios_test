//
//  XSYProcessVisualView.m
//  ingage
//
//  Created by 朱洪伟 on 2018/3/2.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYProcessVisualView.h"
#import "XSYProcessArrowView.h"
#import "Masonry.h"
#import "XSYUserDefaults.h"

@interface XSYProcessVisualView ()

@property (nonatomic,strong)UIScrollView * processBackView;//进度条
@property (nonatomic,strong)UILabel * processTitleLable;//名称
@property (nonatomic,strong)UILabel * processTextLable;//说明
@property (nonatomic,strong)UIView  * processButtonView;
@property (nonatomic,strong)UILabel  * processButtonTitle;
@end

@implementation XSYProcessVisualView
@synthesize viewHeight = _viewHeight;

-(id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = RGBCOLOR(240, 240, 240);
//        [self installView];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBCOLOR(240, 240, 240);
//        [self installView];
        _viewHeight = [XSYListenable listenableWithValue:@(100) setterAction:nil];

    }
    return self;
}
- (void)installView{
    
    self.processButtonView.backgroundColor = [UIColor orangeColor];
    
    [self.processButtonView addSubview:self.processButtonTitle];
    UIImageView * img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    [self.processButtonView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.processButtonView).with.offset(5);
        make.centerY.equalTo(self.processButtonView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    self.processButtonTitle.text = @"阶段推进";
    [self.processButtonTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.processButtonView).offset(5);
        make.centerY.equalTo(self.processButtonView.mas_centerY);
        make.right.equalTo(img.mas_left).with.offset(-5);
        make.height.mas_equalTo(@25);
    }];
    [self addSubview:self.processTitleLable];
    [self.processTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(@50);
    }];
    [self addSubview:self.processTextLable];
    self.processTextLable.text = @"2.业务跟进";
    [self.processTextLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.processTitleLable.mas_right).with.offset(5);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.height.mas_equalTo(@25);
    }];
    self.processBackView.backgroundColor =[UIColor clearColor];
    [self.processBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).with.offset(20);
        make.width.equalTo(self.mas_width).with.offset(-20);
        make.height.mas_equalTo(@25);
    }];
    
    NSArray * processList = @[@"",@"",@"",@"",@"",@""];
    NSInteger count = processList.count;
    CGFloat processWidth =0;
    if (processList.count>5) {
        processWidth = 90;
    }else{
        processWidth = self.width/processList.count;
    }
    self.processBackView.contentSize = CGSizeMake(processWidth*count, self.processBackView.height);

    NSInteger arrowLeft = 0;
    for (int i=0; i<count;i++) {
        XSYProcessArrowView * view2 = [[XSYProcessArrowView alloc] initWithFrame:CGRectMake(arrowLeft, 5, processWidth, 15)];
        if (i==1) {
            [view2 setCurreType:1];
        }
        view2.index = i;
        UITapGestureRecognizer * tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectProcessArrowAction:)];
        [view2 addGestureRecognizer:tapGesturRecognizer];
        [self.processBackView addSubview:view2];
        arrowLeft+= (processWidth-6);
    }
    
}
- (void)actionProcessBlock:(void (^)(NSInteger tag))completion{
    self.actionProcessNext = completion;
}
- (void)selectProcessAction:(id)tag{
    if (self.actionProcessNext) {
        self.actionProcessNext(1);
    }
}
- (void)selectProcessArrowAction:(UITapGestureRecognizer*)tag{
   
    XSYProcessArrowView * view = (XSYProcessArrowView*)tag.view;
    NSLog(@"%d",view.index);
}
- (void)setModel:(id)model{
    [self installView];
}
- (NSString *)viewID {
    return @"";
}
- (UIScrollView*)processBackView{
    if (!_processBackView) {
        _processBackView = [UIScrollView new];
        //是否显示滚动条
        //水平方向
        _processBackView.showsHorizontalScrollIndicator = NO;
//        //垂直方向
        _processBackView.showsVerticalScrollIndicator = NO;
        [self addSubview:_processBackView];
    }
    return _processBackView;
}
- (UIView*)processButtonView
{
    if (!_processButtonView) {
        _processButtonView = [UIView new];
        [self addSubview:_processButtonView];
        [_processButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(@30);
        }];
        _processButtonView.layer.masksToBounds = YES;
        _processButtonView.layer.cornerRadius = 5;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectProcessAction:)];
        [_processButtonView addGestureRecognizer:tapGesturRecognizer];

    }
    return _processButtonView;
}
- (UILabel*)processTitleLable{
    if (!_processTitleLable) {
        _processTitleLable = [ViewCreatorHelper createLabelWithTitle:@"阶段：" font:[UIFont systemFontOfSize:15.0f] frame:CGRectZero textColor:RGBCOLOR(135, 135, 135) textAlignment:NSTextAlignmentLeft];
    }
    return _processTitleLable;
}
- (UILabel*)processTextLable{
    if (!_processTextLable) {
        _processTextLable = [ViewCreatorHelper createLabelWithTitle:@"" font:[UIFont boldSystemFontOfSize:18.0f] frame:CGRectZero textColor:RGBCOLOR(51, 51, 51) textAlignment:NSTextAlignmentLeft];
    }
    return _processTextLable;
}
    
- (UILabel*)processButtonTitle{
    if (!_processButtonTitle) {
        _processButtonTitle = [ViewCreatorHelper createLabelWithTitle:@"" font:[UIFont systemFontOfSize:15.0f] frame:CGRectZero textColor:RGBCOLOR(255, 255, 255) textAlignment:NSTextAlignmentLeft];
    }
    return _processButtonTitle;
}
@end
