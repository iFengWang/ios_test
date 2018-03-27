//
//  XSYDetailTitleLayout.h
//  ingage
//
//  Created by 邹功梁 on 2018/3/15.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYDetailTitleModel.h"
#import <Foundation/Foundation.h>
#import <YYText/YYText.h>

typedef NS_ENUM(NSUInteger, XSYDetailTitleLabelModelShowType) {
    XSYDetailTitleLabelModelShowTypeNone = 0,
    XSYDetailTitleLabelModelShowTypeArrowIcon,
    XSYDetailTitleLabelModelShowTypeQuestionIcon,
    XSYDetailTitleLabelModelShowTypeEditIcon,
};

@interface XSYDetailTitleLabelModel : NSObject

@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, copy) NSString *itemValue; /// description
@property (nonatomic, copy) NSString *itemid;
@property (nonatomic, copy) NSString *itemName; /// item name
@property (nonatomic, copy) NSString *entityType;
@property (nonatomic, copy) NSNumber *arrListNum;
@property (nonatomic, copy) NSNumber *itemSize;
@property (nonatomic, copy) NSString *itemColor;
@property (nonatomic, assign) NSUInteger itemCountForLine;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) XSYDetailTitleLabelModelShowType showType;

@end

@interface XSYDetailTitleTextLinePositionModifier : NSObject <YYTextLinePositionModifier>

@property (nonatomic, strong) UIFont *font;               // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop;         //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom;      //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;

@end

@interface XSYDetailTitleLabelModelLayout : NSObject

@property (nonatomic, strong) XSYDetailTitleLabelModel *labelModel;
@property (nonatomic, strong) YYTextLayout *itemNameLayout;
@property (nonatomic, strong) YYTextLayout *itemValueLayout;
@property (nonatomic, assign) CGFloat itemNameHeight;
@property (nonatomic, assign) CGFloat itemNameWidth;
@property (nonatomic, assign) CGFloat itemValueHeight;
@property (nonatomic, assign) CGFloat itemValueWidth;
@property (nonatomic, assign) CGFloat totalHeight;

- (instancetype)initWithTitleLabelModel:(XSYDetailTitleLabelModel *)labelModel;

@end

@interface XSYDetailTitleLayout : NSObject

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat picHeight;
@property (nonatomic, assign) CGFloat totalHeight;
@property (nonatomic, assign) CGFloat currentHeight;

@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, strong) NSArray<NSArray<XSYDetailTitleLabelModelLayout *> *> *titleLabels;
@property (nonatomic, strong) NSMutableArray *titleLabelLineHeights;
@property (nonatomic, strong) XSYDetailTitleModel *titleModel;
@property (nonatomic, copy) NSString *picValue;
@property (nonatomic, assign) BOOL isShowPic;
@property (nonatomic, assign) BOOL isShowMoreBtn;

- (instancetype)initWithTitleModel:(XSYDetailTitleModel *)titleModel;
- (void)layout;

@end
