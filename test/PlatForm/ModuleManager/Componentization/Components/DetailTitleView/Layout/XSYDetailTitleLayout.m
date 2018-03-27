//
//  XSYDetailTitleLayout.m
//  ingage
//
//  Created by 邹功梁 on 2018/3/15.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYDetailTitleLayout.h"
#import "NSArray+Functional.h"
#import "NSString+Extra.h"
#import "UIColor+Hex.h"
#import "XSYEntityDetailLayout.h"
#import <YYModel/YYModel.h>

@implementation XSYDetailTitleTextLinePositionModifier
- (instancetype)init {
    self = [super init];
    if (IOS9AndAfter) {
        _lineHeightMultiple = 1.34; // for PingFang SC
    } else {
        _lineHeightMultiple = 1.3125; // for Heiti SC
    }
    return self;
}

- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {
    CGFloat ascent = _font.ascender;
    //    CGFloat ascent = _font.pointSize * 0.88;

    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row * lineHeight;
        line.position = position;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    XSYDetailTitleTextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
    CGFloat ascent = _font.ascender;
    CGFloat descent = -_font.descender;
    //    CGFloat ascent = _font.pointSize * 0.88;
    //    CGFloat descent = _font.pointSize * 0.14;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}
@end

@implementation XSYDetailTitleLabelModelLayout
- (instancetype)initWithTitleLabelModel:(XSYDetailTitleLabelModel *)labelModel {
    self = [super init];
    _labelModel = labelModel;
    [self _layout];
    return self;
}
- (void)_layout {
    _totalHeight = 0;
    _itemNameWidth = 0;
    _itemNameHeight = 20;
    _itemValueHeight = 0;
    [self _layoutItemName];
    [self _layoutItemValue];

    _totalHeight = _itemNameHeight > _itemValueHeight ? _itemNameHeight : _itemValueHeight;
}
- (void)_layoutItemName {
    if (!_labelModel.itemName) return;
    NSMutableAttributedString *text =
        [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ :", _labelModel.itemName]];
    text.yy_font = [UIFont boldSystemFontOfSize:_labelModel.itemSize.floatValue];
    text.yy_color = [UIColor colorWithHexString:@"#8899A6"];

    XSYDetailTitleTextLinePositionModifier *modifier = [XSYDetailTitleTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:_labelModel.itemSize.floatValue];
    modifier.paddingTop = 0;
    modifier.paddingBottom = 0;

    YYTextContainer *container =
        [YYTextContainer containerWithSize:CGSizeMake(HUGE, _labelModel.itemSize.floatValue + 5)];
    container.maximumNumberOfRows = 2;
    container.linePositionModifier = modifier;

    CGSize size = CGSizeMake(CGFLOAT_MAX, _labelModel.itemSize.floatValue + 5);
    _itemNameLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (_itemNameLayout.textBoundingSize.width > 70) {
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(70, HUGE)];
        container.maximumNumberOfRows = 2;
        container.linePositionModifier = modifier;

        _itemNameLayout = [YYTextLayout layoutWithContainer:container text:text];
        _itemNameWidth = 70;
        _itemNameHeight = [modifier heightForLineCount:_itemNameLayout.rowCount];
    } else {
        _itemNameWidth = _itemNameLayout.textBoundingSize.width;
        _itemNameHeight = _labelModel.itemSize.floatValue + 5;
    }
}
- (void)_layoutItemValue {
    if (!_labelModel.itemValue) return;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_labelModel.itemValue];
    text.yy_font = [UIFont boldSystemFontOfSize:_labelModel.itemSize.floatValue];
    text.yy_color = [UIColor colorWithHexString:_labelModel.itemColor];

    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(0, 0, 0, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = [UIColor clearColor];
    NSRange range = NSMakeRange(0, _labelModel.itemValue.length);

    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setBackgroundBorder:highlightBorder];
    // 数据信息，用于稍后用户点击
    highlight.userInfo = @{@"info": _labelModel};
    [text yy_setTextHighlight:highlight range:range];

    XSYDetailTitleTextLinePositionModifier *modifier = [XSYDetailTitleTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:_labelModel.itemSize.floatValue];
    modifier.paddingTop = 0;
    modifier.paddingBottom = 0;

    CGFloat maxWidth = _labelModel.lineWidth / _labelModel.itemCountForLine;
    if (_labelModel.showType != XSYDetailTitleLabelModelShowTypeNone) {
        maxWidth -= 5;
        maxWidth -= 12;
        maxWidth -= 15;
    }
    maxWidth -= 15;
    maxWidth -= _itemNameWidth;
    maxWidth -= 5;

    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(maxWidth, HUGE)];
    container.maximumNumberOfRows = 2;
    container.linePositionModifier = modifier;

    CGSize size = CGSizeMake(CGFLOAT_MAX, _labelModel.itemSize.floatValue + 5);
    _itemValueLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (_itemValueLayout.textBoundingSize.width > maxWidth) {
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(maxWidth, HUGE)];
        container.maximumNumberOfRows = 2;
        container.linePositionModifier = modifier;

        _itemValueLayout = [YYTextLayout layoutWithContainer:container text:text];
        _itemValueWidth = maxWidth;
        _itemValueHeight = [modifier heightForLineCount:_itemNameLayout.rowCount];
    } else {
        _itemValueWidth = _itemValueLayout.textBoundingSize.width;
        _itemValueHeight = _labelModel.itemSize.floatValue + 5;
    }
}
@end

@implementation XSYDetailTitleLabelModel
+ (nullable NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"showType"];
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"itemid": @"id", @"itemSize": @"size", @"itemName": @"label"};
}
@end

@implementation XSYDetailTitleLayout

- (instancetype)initWithTitleModel:(XSYDetailTitleModel *)titleModel {
    self = [super init];
    _titleModel = titleModel;
    _titleLabelLineHeights = @[].mutableCopy;
    [self layout];
    return self;
}
- (void)layout {
    [self _layout];
}
- (void)_layout {
    _titleHeight = 0;
    _picHeight = 0;
    _totalHeight = 0;
    _currentHeight = 0;
    _lineWidth = kScreenWidth;

    XSYDetailTitleModel *data = self.titleModel;
    NSDictionary *attributes = data.layout.attributes;
    NSDictionary *titleData = data.objectData.data;
    NSArray *fieldRule = [attributes objectForKey:@"fieldRule"] ?: @[];
    NSArray *keyItems = [attributes objectForKey:@"keyItems"] ?: @[];

    _isShowPic = NO;
    NSNumber *showPicField = [attributes objectForKey:@"showPicField"];
    if (showPicField.boolValue) {
        NSString *picItem = [attributes objectForKey:@"picItem"];
        NSString *picValue = [titleData objectForKey:picItem];
        _isShowPic = YES;
        _picHeight = 90;
        _lineWidth = kScreenWidth - 90 - 30;

        NSLog(@"头部组件图片：%@", picValue);
        _picValue = picValue;
    }

    NSString *titleItem = [attributes objectForKey:@"titleItem"];
    NSString *titleName = [titleData objectForKey:titleItem];
    _titleName = titleName;

    if (titleName) {
        _currentHeight += 20;
        _titleHeight = 50;
    } else {
        _currentHeight += 5;
    }
    _currentHeight += _titleHeight;
    _totalHeight += _currentHeight;

    NSMutableArray *fieldRuleList = [NSMutableArray new];
    _titleLabelLineHeights = @[].mutableCopy;
    __block NSInteger index = 0;
    [fieldRule forEach:^(NSNumber *obj, NSUInteger idx) {
        NSMutableArray *fieldRules = [NSMutableArray arrayWithCapacity:obj.integerValue];
        CGFloat height = 0;
        for (int i = index; i < obj.integerValue + index && i < keyItems.count; i++) {
            NSString *entityType = [keyItems[i] objectForKey:@"entityType"];
            NSInteger arrowType = [self isShowArrow:entityType.integerValue];

            XSYDetailTitleLabelModel *lableModel = [XSYDetailTitleLabelModel yy_modelWithJSON:keyItems[i]];
            lableModel.showType = arrowType;
            lableModel.itemCountForLine = obj.integerValue;
            lableModel.lineWidth = _lineWidth;

            XSYDetailTitleLabelModelLayout *labelModelLayout =
                [[XSYDetailTitleLabelModelLayout alloc] initWithTitleLabelModel:lableModel];
            [fieldRules addObject:labelModelLayout];

            height = height < labelModelLayout.totalHeight ? labelModelLayout.totalHeight : height;
        }
        [fieldRuleList addObject:fieldRules];
        [_titleLabelLineHeights addObject:@(height)];
        index += obj.integerValue;
    }];
    self.titleLabels = fieldRuleList;

    [_titleLabelLineHeights forEach:^(NSNumber *lineHeight, NSUInteger idx) {
        if (idx < 4) {
            _currentHeight += 5;
            _currentHeight += lineHeight.floatValue;
            _totalHeight += 5;
            _totalHeight += lineHeight.floatValue;
        } else {
            _totalHeight += 5;
            _totalHeight += lineHeight.floatValue;
        }
    }];

    if (_titleLabelLineHeights.count > 4) {
        _isShowMoreBtn = YES;
        _currentHeight += 32;
    } else {
        _isShowMoreBtn = NO;
        if (_currentHeight < _picHeight) {
            _currentHeight = _picHeight;
        }
    }
}
//是否可跳转
- (NSInteger)isShowArrow:(NSInteger)entityType {
    // showMoreIcon 0 = none; 1 = arrow; 2 = question icon
    if (entityType == 16) { //公海池
        return 2;
    } else if (entityType >= 99) {
        return 0;
    }
    return 1;
}
@end
