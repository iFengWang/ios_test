//
//  XSYquickOperationFlowLayout.h
//  ingage
//
//  Created by AJ-1993 on 2018/3/1.
//  Copyright © 2018年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSYquickOperationFlowLayout : UICollectionViewFlowLayout

//  一行中cell的个数
@property (nonatomic, assign) NSUInteger itemCountPerRow;

//  一页显示多少行
@property (nonatomic, assign) NSUInteger rowCount;

//  数据页数
@property (nonatomic, assign) NSUInteger dataCount;

@end
