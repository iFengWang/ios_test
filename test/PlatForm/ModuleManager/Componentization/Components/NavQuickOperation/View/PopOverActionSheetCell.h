//
//  PopOverActionSheetCell.h
//  ingage
//
//  Created by 姚任金 on 15/4/23.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "SelectedTableViewCell.h"
#import <UIKit/UIKit.h>

@interface PopOverActionSheetCell : SelectedTableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *leftImageView;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewLeadConstraint;

- (void)initModel:(id)model;
- (CGFloat)getCellHeightFloat;

@end
