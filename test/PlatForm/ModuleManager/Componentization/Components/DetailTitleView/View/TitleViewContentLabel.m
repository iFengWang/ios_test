//
//  TitleViewContentLabel.m
//  ingage
//
//  Created by 邹功梁 on 2018/3/15.
//  Copyright © 2018年 com. All rights reserved.
//

#import "TitleViewContentLabel.h"
#import "UIColor+Hex.h"
#import <Masonry.h>
@implementation TitleViewContentLabel
- (instancetype)init {
    self = [super init];
    [self initControl];
    return self;
}
- (void)initControl {
    [self addSubview:self.itemNameLabel];
    [self addSubview:self.itemValueLabel];
    [self addSubview:self.moreActionIcon];
}
- (void)setLabelLayout:(XSYDetailTitleLabelModelLayout *)labelLayout {
    _labelLayout = labelLayout;
    _itemNameLabel.textLayout = labelLayout.itemNameLayout;
    _itemValueLabel.textLayout = labelLayout.itemValueLayout;

    [_itemNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (labelLayout.itemNameHeight < labelLayout.totalHeight) {
            make.top.equalTo(self);
        } else {
            make.centerY.equalTo(self);
        }
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(labelLayout.itemNameHeight);
        make.width.mas_equalTo(labelLayout.itemNameWidth);
    }];

    [_itemValueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (labelLayout.itemValueHeight < labelLayout.totalHeight) {
            make.top.equalTo(self);
        } else {
            make.centerY.equalTo(self);
        }
        make.left.equalTo(_itemNameLabel.mas_right).offset(5);
        make.height.mas_equalTo(labelLayout.itemValueHeight);
        make.width.mas_equalTo(labelLayout.itemValueWidth);
    }];

    UIImage *image = nil;
    switch (labelLayout.labelModel.showType) {
        case XSYDetailTitleLabelModelShowTypeNone:
            break;
        case XSYDetailTitleLabelModelShowTypeArrowIcon: {
            image = [UIImage svgImageNamed:@"title_content_arrow.svg"
                                 tintColor:[UIColor colorWithRed:0.15 green:0.56 blue:0.9 alpha:1]];
        } break;
        case XSYDetailTitleLabelModelShowTypeQuestionIcon: {
            image = [UIImage svgImageNamed:@"title_content_question.svg"
                                 tintColor:[UIColor colorWithRed:0.8 green:0.84 blue:0.87 alpha:1]];
        } break;
        case XSYDetailTitleLabelModelShowTypeEditIcon: {
            image = [UIImage svgImageNamed:@"title_content_edit.svg"
                                 tintColor:[UIColor colorWithRed:0.15 green:0.56 blue:0.9 alpha:1]];
        }
        default:
            break;
    }

    _moreActionIcon.hidden = YES;
    if (image) {
        _moreActionIcon.hidden = NO;
        [_moreActionIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            if (labelLayout.itemValueHeight < labelLayout.itemNameHeight) {
                make.centerY.equalTo(_itemValueLabel);
            } else {
                make.centerY.equalTo(_itemNameLabel);
            }
            make.left.equalTo(_itemValueLabel.mas_right).offset(5);
            make.width.and.height.mas_equalTo(12);
        }];
        [_moreActionIcon setImage:image forState:UIControlStateNormal];
    }
}
- (YYLabel *)itemNameLabel {
    if (!_itemNameLabel) {
        _itemNameLabel = ({
            YYLabel *label = [[YYLabel alloc] init];
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label;
        });
    }
    return _itemNameLabel;
}
- (YYLabel *)itemValueLabel {
    if (!_itemValueLabel) {
        _itemValueLabel = ({
            YYLabel *contentLabel = [[YYLabel alloc] init];
            contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            contentLabel;
        });
        @weakify(self);
        _itemValueLabel.highlightTapAction =
            ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(didClickItemValueLabel:textRange:)]) {
                    @strongify(self);
                    [self.delegate didClickItemValueLabel:self.itemValueLabel textRange:range];
                }
            };
    }
    return _itemValueLabel;
}
- (UIButton *)moreActionIcon {
    if (!_moreActionIcon) {
        _moreActionIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreActionIcon addTarget:self
                            action:@selector(moreActionIconDidClick)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreActionIcon;
}
- (void)moreActionIconDidClick {
    NSLog(@"aaaaaaaaaaaaaaaaaa");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
