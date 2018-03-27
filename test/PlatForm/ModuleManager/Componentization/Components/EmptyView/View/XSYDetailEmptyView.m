

//
//  XSYDetailEmptyView.m
//  ingage
//
//  Created by 朱洪伟 on 2018/3/16.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYDetailEmptyView.h"
#import "Masonry.h"
#import "XSYUserDefaults.h"

@interface XSYDetailEmptyView ()
@property (nonatomic, strong) UILabel *emptyLable;
@property (nonatomic, strong) UILabel *lineLable; //线条
@end

@implementation XSYDetailEmptyView

@synthesize viewHeight = _viewHeight;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //        [self installView:nil];
        _viewHeight = [XSYListenable listenableWithValue:@(200) setterAction:nil];
    }
    return self;
}
- (void)setModel:(id)model {

    [self.emptyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    [self.lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(.5);
        make.width.mas_equalTo(kScreenWidth);
    }];
    self.lineLable.backgroundColor = RGBCOLOR(200, 200, 200);
}
- (NSString *)viewID {
    return @"xsyTitleInfo";
}

- (UILabel *)emptyLable {
    if (!_emptyLable) {
        _emptyLable = [ViewCreatorHelper createLabelWithTitle:@"研发中..."
                                                         font:[UIFont systemFontOfSize:15.0f]
                                                        frame:CGRectZero
                                                    textColor:[UIColor blackColor]
                                                textAlignment:NSTextAlignmentLeft];
        [self addSubview:_emptyLable];
    }
    return _emptyLable;
}
- (UILabel *)lineLable {
    if (!_lineLable) {
        _lineLable = [ViewCreatorHelper createLabelWithTitle:@""
                                                        font:[UIFont systemFontOfSize:15.0f]
                                                       frame:CGRectZero
                                                   textColor:[UIColor blackColor]
                                               textAlignment:NSTextAlignmentLeft];
        [self addSubview:_lineLable];
    }
    return _lineLable;
}
@end
