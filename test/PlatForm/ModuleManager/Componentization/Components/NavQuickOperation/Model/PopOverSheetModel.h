//
//  PopOverSheetModel.h
//  ingage
//
//  Created by 姚任金 on 15/4/23.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PopOverSheetModel : NSObject

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UIColor *color;
@property (nonatomic, copy) NSString *selectorString;
@property (nonatomic, strong) NSObject *customize;
@property (nonatomic, assign) BOOL isSeletedBool;
@end
