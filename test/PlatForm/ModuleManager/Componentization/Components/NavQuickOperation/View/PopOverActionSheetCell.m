//
//  PopOverActionSheetCell.m
//  ingage
//
//  Created by 姚任金 on 15/4/23.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "PopOverActionSheetCell.h"

@interface PopOverActionSheetCell ()
@property (nonatomic, assign) CGFloat oldWidthConstaint;
@property (nonatomic, assign) CGFloat oldLeadConstraint;
@property (nonatomic, strong) PopOverSheetModel *sheetModel;
@end

@implementation PopOverActionSheetCell
@synthesize oldWidthConstaint, oldLeadConstraint, sheetModel;

- (void)awakeFromNib {
    // Initialization co
    [super awakeFromNib];
    self.backgroundColor = [UIColor hexChangeFloat:@"393c3f"];

    self.contentView.backgroundColor = [UIColor hexChangeFloat:@"393c3f"];

    self.rightLabel.backgroundColor = [UIColor clearColor];
    self.rightLabel.numberOfLines = 0;
    self.rightLabel.preferredMaxLayoutWidth = 100;
    self.leftImageView.backgroundColor = [UIColor clearColor];
}

- (void)initModel:(id)model {
    self.sheetModel = model;

    [self setImageViewConstraint:self.sheetModel];

    self.rightLabel.text = self.sheetModel.title;

    if (self.sheetModel.color != nil) {
        self.rightLabel.textColor = self.sheetModel.color;
    }

    [self layoutIfNeeded];
}

- (void)setImageViewConstraint:(PopOverSheetModel *)sheetModel_ {

    UIImage *image = [UIImage imageNamed:sheetModel_.imageName];

    self.leftImageView.image = image;

    if (self.imageViewWidthConstraint.constant != 0) {
        self.oldWidthConstaint = self.imageViewWidthConstraint.constant;

        self.oldLeadConstraint = self.imageViewLeadConstraint.constant;
    }

    if (nil == self.leftImageView.image) {
        self.imageViewWidthConstraint.constant = 0;

        self.imageViewLeadConstraint.constant = 0;
    } else {

        if (self.oldWidthConstaint == 0) {
            self.oldLeadConstraint = 15.f;
        }

        self.imageViewWidthConstraint.constant = self.oldWidthConstaint;

        self.imageViewLeadConstraint.constant = self.oldLeadConstraint;
    }
}

- (CGFloat)getCellHeightFloat {
    [self layoutIfNeeded];

    CGFloat height = CGRectGetMaxY(self.rightLabel.frame);

    CGFloat maxFloat = height + 15;

    return maxFloat;
}

- (void)setListCellType:(ListCellType)listCellType_ {
    [super setListCellType:listCellType_];

    [self changeSeletedBool:self.sheetModel.isSeletedBool];
}

- (UIImage *)selectedAccessoryImage {
    return [UIImage imageNamed:@"UserNew_index_Dashboardscreening"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
