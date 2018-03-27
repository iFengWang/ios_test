//
//  PopOverActionSheet.m
//  ingage
//
//  Created by 姚任金 on 15/4/23.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "PopOverActionSheet.h"
#import "UIViewController+Utils.h"
#define kMaxCount 5
@interface PopOverActionSheet ()

@property (nonatomic, strong) NSMutableArray *sectionArry;

@property (nonatomic, assign) CGFloat tableViewHeightFloat;

@end

@implementation PopOverActionSheet
@synthesize delegate, sectionArry, textColor, tableViewHeightFloat;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    [viewTool setExtraCellLineHidden:self.tableView];

    self.sectionArry = [[NSMutableArray alloc] init];
    UIImage *image = [UIImage imageNamed:@"index_moreBackGroundView"];
    image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:12];
    self.backGroupImageView.image = image;

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor hexChangeFloat:@"43474A" alpha:1.0];
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventAllEvents];

    self.hidden = YES;

    [self defineFrame];
}

- (void)initModel:(id)model {
    [self handlePopOverSheetModelArryWithIsAddAllModelBool:NO];

    if ([self.delegate respondsToSelector:@selector(setTableViewProperty:)]) {
        [self.delegate setTableViewProperty:self.tableView];
    }

    if ([self.delegate respondsToSelector:@selector(getSheetTextColor)]) {
        self.textColor = [self.delegate getSheetTextColor];
    }

    [self.tableView reloadData];

    [self defineImageViewFrame];
}

- (void)handlePopOverSheetModelArryWithIsAddAllModelBool:(BOOL)isAddAllModelBool {
    NSMutableArray *sheetModleArry = [self.delegate getPopOverSheetModelArry];

    NSMutableArray *tmpSheetModelArry = [[NSMutableArray alloc] init];

    for (NSMutableArray *arry in sheetModleArry) {

        if ([sheetModleArry indexOfObject:arry] != 0) {

            for (PopOverSheetModel *model in arry) {

                model.imageName = nil;
            }
        }
    }

    if (sheetModleArry.count == 2) {
        [tmpSheetModelArry addObjectsFromArray:[sheetModleArry firstObject]];

        if (isAddAllModelBool) {
            [tmpSheetModelArry addObjectsFromArray:[sheetModleArry lastObject]];
        } else {
            [tmpSheetModelArry addObject:[self createSheetModel]];
        }
    } else {
        [tmpSheetModelArry addObjectsFromArray:[sheetModleArry firstObject]];
    }

    [self.sectionArry removeAllObjects];

    [self.sectionArry addObject:tmpSheetModelArry];
}

- (PopOverSheetModel *)createSheetModel {
    PopOverSheetModel *model = [[PopOverSheetModel alloc] init];
    model.title = kMoreOperationString;
    return model;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopOverActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopOverActionSheetCell"];
    if (nil == cell) {
        cell = (PopOverActionSheetCell *)[viewTool loadXibWithName:@"PopOverActionSheetCell"
                                                        withObject:nil
                                                       withOptions:nil];

        CGRect rect = cell.frame;
        rect.size.width = tableView.frame.size.width;
        cell.frame = rect;
    }

    PopOverSheetModel *sheetModel = [[self.sectionArry objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    if (self.textColor != nil) {
        sheetModel.color = self.textColor;
    }

    [cell initModel:sheetModel];

    if ([self.delegate respondsToSelector:@selector(getListCellType)]) {
        cell.listCellType = [self.delegate getListCellType];
    } else {
        cell.listCellType = ListCellType_Define;
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 10);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopOverActionSheetCell *cell = (PopOverActionSheetCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];

    return [cell getCellHeightFloat];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionArry count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)[self.sectionArry objectAtIndex:section] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    PopOverSheetModel *sheetModel = [[self.sectionArry objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    if ([sheetModel.title isEqualToString:kMoreOperationString]) {
        [self handlePopOverSheetModelArryWithIsAddAllModelBool:YES];

        [tableView reloadData];

        [self defineImageViewFrame];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[(NSArray *)[self.sectionArry lastObject] count] - 1
                                                    inSection:self.sectionArry.count - 1];

        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];

    } else {

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{

            [self.delegate didSelectPopOverSheetModel:sheetModel];

            self.hidden = YES;

        }];
    }
}

- (void)defineFrame {
    CGRect rect = self.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = kScreenWidth;
    rect.size.height = kScreenHeight;
    self.frame = rect;
}

- (IBAction)btnClick:(id)sender {
    self.hidden = YES;
}

- (void)defineImageViewFrame {
    CGPoint point;

    CGFloat widthFloat = 0;

    if ([self.delegate respondsToSelector:@selector(getTableViewWidth)]) {
        widthFloat = [self.delegate getTableViewWidth];
    } else {
        widthFloat = [self getTableViewWidthFloat];
    }

    if ([self.delegate respondsToSelector:@selector(getPointActionSheet)]) {
        point = [self.delegate getPointActionSheet];
    } else {
        point.x = kScreenWidth - [self getTableViewWidthFloat] - 10;
        point.y = 64.f;
    }

    self.imageWidthConstraint.constant = widthFloat;

    self.imageViewTopConstraint.constant = point.y;

    [self layoutIfNeeded];

    self.tableViewHeightFloat = [self getTableViewHeight];

    self.imageViewHeightConstraint.constant = self.tableViewHeightFloat;

    [self layoutIfNeeded];
}

- (CGFloat)getTableViewWidthFloat {
    return kTableViewWidthFloat;
}

- (CGFloat)getTableViewHeight {
    [self layoutIfNeeded];

    if (self.tableView.contentSize.height >= kTableViewMaxHeight) {
        CGFloat maxHeight = kTableViewMaxHeight;

        return maxHeight;
    } else {
        return self.tableView.contentSize.height + 7;
    }
}

- (void)showInViewController:(UIViewController *)Sview {
    if (self.sectionArry.count == 0 || [(NSArray *)[self.sectionArry firstObject] count] == 0) {
        return;
    }

    if (Sview == nil) {
        UIViewController *viewController = [UIViewController currentViewController];
        [viewController.navigationController.view addSubview:self];
    } else {
        [Sview.view addSubview:self];
    }
}

- (void)showInView:(UIView *)inView {
    if (inView == nil) {

        [self showInViewController:nil];
    } else {
        [inView addSubview:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
