//
//  XSYEnterpriseRecommendedCell.h
//  ingage
//
//  Created by 朱洪伟 on 2018/3/6.
//  Copyright © 2018年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XSYEnterpriseRecommendedModel.h"

@protocol XSYEnterpriseRecommendedCellDelegate <NSObject>
- (void)enterpriseDeleteAlction;//删除按钮
- (void)gotoEnterpriseDetailAlction;//点击企业详情
@end

@interface XSYEnterpriseRecommendedCell : UICollectionViewCell
@property (nonatomic,assign)id<XSYEnterpriseRecommendedCellDelegate>delegate;
- (void)setModel:(XSYEnterpriseRecommendedModel*)model;
@end
