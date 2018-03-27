//
//  PopOverSheetModel.m
//  ingage
//
//  Created by 姚任金 on 15/4/23.
//  Copyright (c) 2015年 com. All rights reserved.
//

@implementation PopOverSheetModel
@synthesize imageName, title, color, selectorString, isSeletedBool, customize;

- (void)setTitle:(NSString *)title_ {
    title = title_;

    self.imageName = [viewTool getImageNamePopOverActionSheetCellWithTitleString:title_];
}

@end
