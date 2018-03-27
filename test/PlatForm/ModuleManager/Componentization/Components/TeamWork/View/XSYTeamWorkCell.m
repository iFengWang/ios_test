//
//  XSYTeamWorkView.m
//  ingage
//
//  Created by AJ-1993 on 2018/3/5.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYTeamWorkCell.h"

@interface XSYTeamWorkCell ()

@property (assign, nonatomic) BOOL isManager;
@property (assign, nonatomic) BOOL isOwner;
@end

@implementation XSYTeamWorkCell
@synthesize isManager, isOwner;
@synthesize index;
@synthesize UpBgView, iconBgView, iconImage, iconBadgeImage, nameLabel, operaterButton, markButton;
@synthesize downBgView, cancelButton, deleteButton;
@synthesize currentMember, convertImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    //    downBgView.backgroundColor = [UIColor hexChangeFloat:@"e4f1fb"];
    [self createUI];
}
- (void)createUI {
    downBgView.hidden = NO;
    [operaterButton setTitle:kValue(@"crm_btn_memberpermission") forState:UIControlStateNormal];
    [operaterButton setTitleColor:[UIColor hexChangeFloat:@"b2bdc5"] forState:UIControlStateNormal];

    [cancelButton setTitleColor:[UIColor hexChangeFloat:@"55acee"] forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor hexChangeFloat:@"55acee"] forState:UIControlStateNormal];
    [deleteButton setTitle:kValue(@"common_btn_delete") forState:UIControlStateNormal];
    [iconImage.layer setMasksToBounds:YES];
    iconImage.layer.cornerRadius = 4;
}
- (void)initWithModel:(member *)member
          withifOwner:(BOOL)ifO
        withifManager:(BOOL)ifM
           withStatus:(NSInteger)status
              canEdit:(BOOL)canEidt {
    currentMember = member;
    nameLabel.text = member.name;
    [iconImage setImageWithURL:[NSURL URLWithString:member.icon] placeholderImage:[UIImage imageNamed:kPersonImage]];
    canEidt = YES;
    self.isOwner = ifO;
    self.isManager = ifM;
    if ((self.isOwner && self.isManager) || !canEidt) {
        markButton.hidden = YES;
    } else {
        markButton.hidden = NO;
    }
    if (self.isOwner || self.isManager) {
        operaterButton.hidden = NO;
        iconBadgeImage.hidden = NO;
        [cancelButton setTitle:kValue(@"crm_btn_cancelowner") forState:UIControlStateNormal];
        [convertImage setImage:[UIImage imageNamed:@"cancel_owner"]];
    } else {
        [cancelButton setTitle:kValue(@"crm_btn_setowner") forState:UIControlStateNormal];
        [convertImage setImage:[UIImage imageNamed:@"set_owner"]];
        iconBadgeImage.hidden = YES;
        operaterButton.hidden = YES;
    }
    downBgView.hidden = !status;
    if ([member.isSpecialTag isEqualToString:@"1"]) {
        _specialTag.hidden = NO;
    } else {
        _specialTag.hidden = YES;
    }

    [self updata];
}
- (void)resetMark {
    NSString *imgName = downBgView.hidden ? @"today_accessory_normal" : @"today_accessory_select";
    [markButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}
- (void)toggleCell {
    if (self.isOwner && self.isManager) {
        return;
    }
    downBgView.hidden = !downBgView.hidden;
    [self resetMark];
    if ([self.delegate respondsToSelector:@selector(refreshCell:)]) {
        [self.delegate refreshCell:index];
    }
}

- (void)updata {
}

- (IBAction)cancelAction:(id)sender {
    NSString *tips = (self.isOwner || self.isManager) ? @"cancel_teamMember" : @"";
    if (![ingageTool isEmpty:tips]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kValue(@"common_title_tip")
                                                            message:kValue(tips)
                                                           delegate:self
                                                  cancelButtonTitle:kValue(@"common_title_cancel")
                                                  otherButtonTitles:kValue(@"common_btn_ok"), nil];
        alertView.tag = 2;
        [alertView show];
    } else {
        [self cancelMember];
    }
}
- (IBAction)delAction:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kValue(@"common_title_tip")
                                                        message:kValue(@"del_teamMember")
                                                       delegate:self
                                              cancelButtonTitle:kValue(@"common_title_cancel")
                                              otherButtonTitles:kValue(@"common_btn_ok"), nil];
    alertView.tag = 1;
    [alertView show];
}
- (IBAction)markAction:(id)sender {
    [self toggleCell];
}
- (IBAction)operatAction:(id)sender {
    [self toggleCell];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)delMember {
    if ([self.delegate respondsToSelector:@selector(delAction:)]) {
        [self.delegate delAction:index];
    }
}
- (void)cancelMember {
    if ([self.delegate respondsToSelector:@selector(cancelAction:)]) {
        [self.delegate cancelAction:index];
    }
}
#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == 1) {
            [self delMember];
        } else if (alertView.tag == 2) {
            [self cancelMember];
        }
    }
}
@end
