//
//  XSYQuickOperationCollectionCell.m
//  ingage
//
//  Created by AJ-1993 on 2018/2/28.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYQuickOperationCollectionCell.h"
#import "XSYQuickOperationModel.h"
#import "UIImage+SVG.h"

@interface XSYQuickOperationCollectionCell()

@property (strong, nonatomic) UIImageView *quickIcon;
@property (strong, nonatomic) UILabel *quickTitle;

@end

@implementation XSYQuickOperationCollectionCell
@synthesize model;
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.quickIcon autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.quickIcon autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [self.quickTitle autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.quickTitle autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.quickIcon withOffset:10];
}

- (void)setModel:(XSYQuickOperationModel *)model {
    model = model;
    self.quickIcon.image = [UIImage imageNamed:model.icon];
    self.quickIcon.image = [UIImage svgImageNamed:@"approval_flow_icon.svg" tintColor:[UIColor redColor]];
    self.quickTitle.text = model.name;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (UIImageView *)quickIcon {
    if (!_quickIcon) {
        UIImageView *quickIcon = [[UIImageView alloc] init];
        quickIcon.size = CGSizeMake(35, 35);
        [self.contentView addSubview:(_quickIcon = quickIcon)];
    }
    return _quickIcon;
}

- (UILabel *)quickTitle {
    if (!_quickTitle) {
        UILabel *quickTitle = [[UILabel alloc] init];
        quickTitle.font = [UIFont systemFontOfSize:12];
        quickTitle.numberOfLines = 2.;
        [self.contentView addSubview:(_quickTitle = quickTitle)];
    }
    return _quickTitle;
}


@end
