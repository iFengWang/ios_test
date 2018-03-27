//
//  PopOverActionSheet.h
//  ingage
//
//  Created by 姚任金 on 15/4/23.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "PopOverActionSheet.h"
#import "PopOverActionSheetCell.h"
#import "PopOverSheetModel.h"
#import <UIKit/UIKit.h>
#define kMoreOperationString kValue(@"common_btn_moreoperation")
#define kTableViewMaxHeight (kMaxCount * 48 + 6 + 24)
#define kTableViewWidthFloat 155.f

@protocol PopOverActionSheetDelegate <NSObject>
@optional
- (NSMutableArray *)getPopOverSheetModelArry;
- (void)didSelectPopOverSheetModel:(PopOverSheetModel *)sheetModel;
@optional
//设置tableview的属性
- (void)setTableViewProperty:(UITableView *)tableView;
//设置tableViewCell
- (UIColor *)getSheetTextColor;
//是否是被选择的
- (ListCellType)getListCellType;
//获取ActionSheet的位置
- (CGPoint)getPointActionSheet;
// tableview的宽度
- (CGFloat)getTableViewWidth;

@end

@interface PopOverActionSheet : UITableViewCell <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) UIColor *textColor;
@property (nonatomic, weak) id<PopOverActionSheetDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *backGroupImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;
- (void)initModel:(id)model;
- (void)showInViewController:(UIViewController *)Sview;
- (void)showInView:(UIView *)inView;
- (void)defineFrame;
- (IBAction)btnClick:(id)sender;

@end
