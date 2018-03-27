//
//  XSYDetailTitleView.m
//  ingage
//
//  Created by 朱洪伟 on 2018/2/26.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYDetailTitleView.h"
#import "Masonry.h"
#import "NSArray+Functional.h"
#import "TitleViewContentLabel.h"
#import "UIButton+WebCache.h"
#import "UIImage+SVG.h"
#import "UIView+Extension.h"
#import "XSYDetailTitleLayout.h"
#import "XSYDetailTitleModel.h"
#import "XSYEntityDetailLayout.h"
#import "XSYUserDefaults.h"
#import <YYModel/YYModel.h>
#import <YYText/YYText.h>

@interface XSYDetailTitleView () <TitleViewContentLabelDelegate>
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *contentLabels;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *titleIconView;
@property (nonatomic, strong) UIButton *titleCompanyIconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *titleBussinessIconView;
@property (nonatomic, strong) UIButton *titleFavouriteIconView;
@property (nonatomic, strong) UIButton *showMoreBtn;

@property (nonatomic, strong) XSYDetailTitleLayout *titleLayout;
@end

@implementation XSYDetailTitleView
@synthesize viewHeight = _viewHeight;
- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _viewHeight = [XSYListenable listenableWithValue:@(200)
                                            setterAction:^(id value){

                                            }];
    }
    return self;
}
- (void)startRequest {
}
#pragma mark -
#pragma mark - XSYEntityDetailComponentIdentifier
- (void)setModel:(id)model {

    XSYDetailTitleLayout *data = model;
    _titleLayout = model;
    _contentLabels = @[].mutableCopy;
    [self drawIconView];
    [self drawTitleView];
    [self drawContentView];
    [self drawShowMoreView];

    CGFloat backViewHeight = _titleLayout.currentHeight;
    _viewHeight.value = @(backViewHeight);
}
- (void)drawIconView {
    [self.titleIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backView).offset(15);
        make.top.equalTo(_backView).offset(20);
        if (_titleLayout.isShowPic) {
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(70);
        } else {
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }
    }];

    [_titleIconView setImageWithURL:[NSURL URLWithString:_titleLayout.picValue ?: @""]
                           forState:UIControlStateNormal
                   placeholderImage:[UIImage svgImageNamed:@"none_state.svg"
                                                 tintColor:[UIColor colorWithRed:0.91 green:0.96 blue:1 alpha:1]]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){

                          }];
}
- (void)drawTitleView {
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];

    if (!_titleLayout.titleName) {
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleIconView.mas_right);
            make.right.equalTo(self.backView);
            make.top.equalTo(self.backView).offset(5);
            make.height.mas_equalTo(0);
        }];
        return;
    }

    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleIconView.mas_right);
        make.right.equalTo(self.backView);
        make.top.equalTo(self.backView).offset(20);
        make.height.mas_equalTo(_titleLayout);
    }];
    [self.titleCompanyIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleView).offset(15);
        make.centerY.equalTo(_titleView);
        make.width.and.height.mas_equalTo(20);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleCompanyIconView.mas_right).offset(15);
        make.centerY.and.height.equalTo(_titleView);
    }];
    [self.titleBussinessIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(15);
        make.height.and.width.mas_equalTo(20);
        make.centerY.equalTo(_titleView);
    }];
    [self.titleFavouriteIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleBussinessIconView.mas_right).offset(15);
        make.right.equalTo(_titleView).offset(-15);
        make.centerY.equalTo(_titleView);
        make.width.and.height.mas_equalTo(20);
    }];

    _titleLabel.text = _titleLayout.titleName;
    UIImage *titleCompanyIconSvgImage =
        [UIImage svgImageNamed:@"none_state.svg" tintColor:[UIColor colorWithRed:0 green:0.8 blue:0.6 alpha:1]];
    [_titleCompanyIconView setImage:titleCompanyIconSvgImage forState:UIControlStateNormal];

    UIImage *titleBusinessIconSvgImage =
        [UIImage svgImageNamed:@"bussiness_info_exist.svg"
                     tintColor:[UIColor colorWithRed:0.13 green:0.56 blue:0.9 alpha:1]];
    [_titleBussinessIconView setImage:titleBusinessIconSvgImage forState:UIControlStateNormal];

    UIImage *titleFavouriteIconSvgImage =
        [UIImage svgImageNamed:@"unfavourite.svg" tintColor:[UIColor colorWithRed:0.58 green:0.64 blue:0.69 alpha:1]];
    [_titleFavouriteIconView setImage:titleFavouriteIconSvgImage forState:UIControlStateNormal];
}
- (void)drawContentView {
    __block CGFloat top = 0;
    @weakify(self);
    [_titleLayout.titleLabels forEach:^(NSArray<XSYDetailTitleLabelModelLayout *> *labelModelArr, NSUInteger idx) {
        CGFloat labelWidth = _titleLayout.lineWidth / labelModelArr.count;
        NSMutableArray *labelArr = @[].mutableCopy;
        CGFloat height = [_titleLayout.titleLabelLineHeights[idx] floatValue];
        CGFloat leftOffetSet = _titleLayout.isShowPic ? (90 + 15) : 0;
        for (NSUInteger index = 0; index < labelModelArr.count; index++) {
            XSYDetailTitleLabelModelLayout *labelLayout = labelModelArr[index];
            TitleViewContentLabel *contentLabel = [[TitleViewContentLabel alloc] init];
            contentLabel.delegate = self;
            [self.backView addSubview:contentLabel];

            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.backView).offset(index * labelWidth + leftOffetSet);
                make.top.equalTo(self.titleView.mas_bottom).offset(top);
                make.width.mas_equalTo(labelWidth);
                make.height.mas_equalTo(height);
            }];
            contentLabel.labelLayout = labelLayout;
            [labelArr addObject:contentLabel];
        }
        top += height;
        top += 5;
        [_contentLabels addObject:labelArr];
    }];
}
- (void)drawShowMoreView {
    self.showMoreBtn.hidden = YES;
    if (!_titleLayout.isShowMoreBtn) return;
    self.showMoreBtn.hidden = NO;
    [self.showMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_backView);
        make.bottom.equalTo(_backView);
        make.height.mas_equalTo(32);
    }];
}
- (NSString *)viewID {
    return @"xsyTitleInfo";
}

#pragma mark -
#pragma mark - view初始化
- (UIButton *)titleIconView {
    if (!_titleIconView) {
        _titleIconView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backView addSubview:_titleIconView];
    }
    return _titleIconView;
}
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        [self.backView addSubview:_titleView];
    }
    return _titleView;
}
- (UIButton *)titleCompanyIconView {
    if (!_titleCompanyIconView) {
        _titleCompanyIconView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleCompanyIconView addTarget:self
                                  action:@selector(titleCompanyIconViewDidClick)
                        forControlEvents:UIControlEventTouchUpInside];
        [self.titleView addSubview:_titleCompanyIconView];
    }
    return _titleCompanyIconView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [ViewCreatorHelper createLabelWithTitle:@""
                                                         font:[UIFont systemFontOfSize:18.0f]
                                                        frame:CGRectZero
                                                    textColor:RGBCOLOR(51, 51, 51)
                                                textAlignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 2;
        [self.titleView addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (UIButton *)titleBussinessIconView {
    if (!_titleBussinessIconView) {
        _titleBussinessIconView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.titleView addSubview:_titleBussinessIconView];
    }
    return _titleBussinessIconView;
}
- (UIButton *)titleFavouriteIconView {
    if (!_titleFavouriteIconView) {
        _titleFavouriteIconView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.titleView addSubview:_titleFavouriteIconView];
    }
    return _titleFavouriteIconView;
}
- (UIButton *)showMoreBtn {
    if (!_showMoreBtn) {
        _showMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showMoreBtn addTarget:self
                         action:@selector(showMoreBtnDidClick)
               forControlEvents:UIControlEventTouchUpInside];

        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor colorWithRed:0.63 green:0.7 blue:0.75 alpha:1];
        titleLabel.text = kValue(@"components_detail_title_show_all");
        titleLabel.font = [UIFont systemFontOfSize:12];
        [_showMoreBtn addSubview:titleLabel];

        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = [UIImage svgImageNamed:@"title_arrow_down.svg"
                                            tintColor:[UIColor colorWithRed:0.63 green:0.7 blue:0.75 alpha:1]];
        [_showMoreBtn addSubview:arrowImageView];

        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_showMoreBtn);
            make.height.mas_equalTo(20);
        }];

        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_showMoreBtn);
            make.left.equalTo(titleLabel.mas_right).offset(5);
            make.width.and.height.mas_equalTo(10);
            make.right.equalTo(_showMoreBtn).offset(-150);
        }];

        _showMoreBtn.backgroundColor = [UIColor whiteColor];
        [self.backView addSubview:_showMoreBtn];
    }
    return _showMoreBtn;
}
- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.clipsToBounds = YES;
    }
    return _backView;
}
- (void)didClickItemValueLabel:(YYLabel *)itemValueLabel textRange:(NSRange)textRange {
    NSAttributedString *text = itemValueLabel.textLayout.text;
    if (textRange.location >= text.length) return;
    YYTextHighlight *highlight = [text yy_attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    if (info.count == 0) return;
    if (info[@"info"]) {
        XSYDetailTitleLabelModel *labelModel = info[@"info"];

        if (self.delegate && [self.delegate respondsToSelector:@selector(XSYDetailTitleViewDidClickItem:)]) {
            [self.delegate XSYDetailTitleViewDidClickItem:labelModel];
        }
    }
}
- (void)showMoreBtnDidClick {
    CGFloat backViewHeight = _titleLayout.totalHeight;
    _showMoreBtn.hidden = YES;
    _viewHeight.value = @(backViewHeight);
}
- (void)titleCompanyIconViewDidClick {
    NSLog(@"sdasdadadadadad");
}
@end
