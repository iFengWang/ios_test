//
//  XSYTeamWorkCell.h
//  ingage
//
//  Created by AJ-1993 on 2018/3/5.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYTeamWorkModel.h"
#import <UIKit/UIKit.h>

@protocol XSYTeamWorkCellDelegate <NSObject>

- (void)refreshCell:(NSIndexPath *)index;

- (void)cancelAction:(NSIndexPath *)index;

- (IBAction)delAction:(NSIndexPath *)index;

@end

@interface XSYTeamWorkCell : UITableViewCell

@property (nonatomic, weak) id<XSYTeamWorkCellDelegate> delegate;

@property (nonatomic, strong) XSYTeamWorkModel *model;
@property (strong, nonatomic) member *currentMember;
@property (strong, nonatomic) NSIndexPath *index;
@property (weak, nonatomic) IBOutlet UIView *UpBgView;
@property (weak, nonatomic) IBOutlet UIView *iconBgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIImageView *iconBadgeImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *operaterButton;
- (IBAction)operatAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *markButton;
- (IBAction)markAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *convertImage;
@property (weak, nonatomic) IBOutlet UIImageView *specialTag;

@property (weak, nonatomic) IBOutlet UIView *downBgView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)cancelAction:(id)sender;
- (IBAction)delAction:(id)sender;

- (void)initWithModel:(member *)m
          withifOwner:(BOOL)ifO
        withifManager:(BOOL)ifM
           withStatus:(NSInteger)status
              canEdit:(BOOL)canEidt;

@end
