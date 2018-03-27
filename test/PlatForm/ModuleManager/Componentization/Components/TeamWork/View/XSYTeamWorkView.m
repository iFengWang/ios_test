//
//  XSYTeamWorkView.m
//  ingage
//
//  Created by AJ-1993 on 2018/3/5.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYTeamWorkView.h"
#import "Masonry.h"
#import "NSArray+Functional.h"
#import "RequestToolApi.h"
#import "TeamMemberCell.h"
#import "UserNewViewController.h"
#import "XSYTeamWorkCell.h"
#import "XSYTeamWorkModel.h"
#import "XSYUserDefaults.h"

@interface XSYTeamWorkView () <UITableViewDataSource, UITableViewDelegate, TeamMemberCellDelegate,
                               XSYTeamWorkCellDelegate>

@property (nonatomic, strong) UITableView *teamTableView;
@property (nonatomic, strong) NSMutableArray *ownerMember;
@property (nonatomic, strong) NSMutableArray *otherMembers;
@property (nonatomic, strong) NSMutableDictionary *status;
@property (nonatomic, strong) NSMutableArray *colleagues;

@property (nonatomic, assign) BOOL canUpdateGroupMember;
@property (nonatomic, assign) NSInteger tableViewH;

@property (nonatomic, strong) UIView *moreView;
@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, assign) BOOL isMoreView;

@end

@implementation XSYTeamWorkView
@synthesize ownerMember, otherMembers, status, colleagues, canUpdateGroupMember;
@synthesize viewHeight = _viewHeight;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _viewHeight = [XSYListenable listenableWithDefaultValue:@(200)];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createUI:(BOOL)isMoreView {
    self.isMoreView = isMoreView;
    if (isMoreView) {
        [self addSubview:self.moreView];
        [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_offset(30);
            make.width.mas_offset(kScreenWidth);
        }];
        [self.moreView addSubview:self.moreButton];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.moreView).with.offset(10);
            make.width.mas_offset(150);
            make.height.equalTo(self.moreView);
            make.centerY.equalTo(self.moreView);
        }];
        [self addSubview:self.teamTableView];
        [self.teamTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.bottom.equalTo(self.moreView.mas_top).with.offset(-10);
            make.width.mas_offset(kScreenWidth);
        }];
    } else {
        [self addSubview:self.teamTableView];
        [self.teamTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
    }
}
- (void)selectMoreButton:(UIButton *)bt {
}
#pragma mark - XSYEntityDetailComponentIdentifier

- (NSString *)viewID {
    return @"xsyGroupMember";
}

- (void)setModel:(id)model {
    XSYTeamWorkModel *data = model;

    ownerMember = data.ownerMember;
    otherMembers = data.otherMembers;
    status = [NSMutableDictionary dictionary];
    colleagues = [NSMutableArray array];

    self.tableViewH = (ownerMember.count * 60) + (otherMembers.count * 60) + 40 + 30 + 10;
    _viewHeight.value = @(self.tableViewH);
    if (otherMembers.count >= 20) {
        [self createUI:YES];
    } else {
        [self createUI:NO];
    }
    [self updataListHeight];
    [self.teamTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return ownerMember.count;
    } else if (section == 1) {
        return otherMembers.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (indexPath.section == 1) {
        height = [[status objectForKey:indexPath] integerValue] == 0 ? 61 : 120;
    } else {
        height = 60;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return ownerMember.count ? 20 : 0;
    } else if (section == 1) {
        return otherMembers.count ? 20 : 0;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    [label setTextColor:[UIColor hexChangeFloat:@"8899a6"]];
    label.font = [UIFont systemFontOfSize:14];
    [label setBackgroundColor:[UIColor hexChangeFloat:@"f5f8fa"]];
    if (section == 0) {
        label.text = [NSString stringWithFormat:@"  %@", kValue(@"member_title_owner")];
    } else if (section == 1) {
        label.text = [NSString stringWithFormat:@"  %@", kValue(@"member_title_other")];
    }
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XSYTeamWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XSYTeamWorkCell"];
    //(XSYTeamWorkCell *)[tableView dequeueReusableCellWithIdentifier:@"XSYTeamWorkCell" forIndexPath:indexPath];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XSYTeamWorkCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    cell.index = indexPath;
    cell.delegate = self;
    NSInteger s = [[status objectForKey:indexPath] integerValue];
    if (indexPath.section == 0) {
        [cell initWithModel:[ownerMember objectAtIndex:indexPath.row]
                withifOwner:YES
              withifManager:YES
                 withStatus:s
                    canEdit:self.canUpdateGroupMember];
    } else if (indexPath.section == 1) {
        member *m = [otherMembers objectAtIndex:indexPath.row];
        if (m.hasModifyRight) {
            [cell initWithModel:m withifOwner:YES withifManager:NO withStatus:s canEdit:self.canUpdateGroupMember];
        } else {
            [cell initWithModel:m withifOwner:NO withifManager:NO withStatus:s canEdit:self.canUpdateGroupMember];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    XSYTeamWorkCell *cell = (XSYTeamWorkCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self gotoUserInfoPage:cell.currentMember.uid type:cell.currentMember.isSpecialTag];
}
- (void)gotoUserInfoPage:(NSString *)uid type:(NSString *)type {
    if (![ingageTool isEmpty:uid]) {
        UserNewViewController *userPage = [[UserNewViewController alloc] init];
        userPage.uid = uid;
        userPage.isPartner = [type isEqualToString:@"1"] ? YES : NO;
        [[viewTool getMainController] pushViewController:userPage animated:YES];
    }
}
#pragma mark - cell delegate
- (void)refreshCell:(NSIndexPath *)index {
    if (index.section == 1) {
        NSInteger v = [[status objectForKey:index] integerValue];
        v = v == 0 ? 1 : 0;
        [self updataTableViewHeight:v];
        [status setObject:@(v) forKey:index];
        [self.teamTableView reloadData];
    }
}
- (void)updataTableViewHeight:(BOOL)isShow {
    if (!isShow) {
        self.tableViewH = self.tableViewH - 70;
    } else {
        self.tableViewH = self.tableViewH + 70;
    }
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_offset(self.tableViewH);
//    }];
//    _viewHeight = [XSYListenable listenableWithValue:@(self.tableViewH) setterAction:nil];
    _viewHeight.value = @(self.tableViewH);
    //    if (self.isMoreView) {
    //
    //    }else{
    //
    //    }
}
- (void)updataListHeight {
    self.tableViewH = (ownerMember.count * 60) + (otherMembers.count * 60) + 40 + 30 + 10;
    _viewHeight.value = @(self.tableViewH);
}
- (void)cancelAction:(NSIndexPath *)index {
    NSInteger v = [[status objectForKey:index] integerValue];
    v = v == 1 ? 0 : 0;
    [status setObject:@(v) forKey:index];
    /*
    取消权限
     */
    TeamMemberCell *cell = (TeamMemberCell *)[self.teamTableView cellForRowAtIndexPath:index];
    member *m = cell.currentMember;
    [self afterCancel:cell];
    NSString *url = [NSString stringWithFormat:@"/data/v2.0/teamwork/teamMembers/%@", m.memberId];
    NSMutableDictionary *pram = [NSMutableDictionary new];
    [pram setValue:@(m.hasModifyRight) forKey:@"ownerFlag"];
    SHOWLOADING;
    [RequestModelApi modify:url
        param:pram
        success:^(id<Element> e) {
            HIDELOADING;
            NSDictionary *dic = [e toDict];
            NSLog(@"%@", dic);
        }
        fail:^(NSError *operation) {
            HIDELOADING;
        }];
}

- (void)delAction:(NSIndexPath *)index {
    /*
     删除团队成员
     如果是展开的情况先收起
     */
    NSInteger v = [[status objectForKey:index] integerValue];
    v = v == 1 ? 0 : 0;
    [status setObject:@(v) forKey:index];

    TeamMemberCell *cell = (TeamMemberCell *)[self.teamTableView cellForRowAtIndexPath:index];
    member *m = cell.currentMember;
    [self afterDel:cell];
    SHOWLOADING;
    NSString *url = [NSString stringWithFormat:@"/data/v2.0/teamwork/teamMembers/%@", m.memberId];
    [RequestModelApi remove:url
        param:nil
        success:^(id<Element> e) {
            HIDELOADING;
            NSDictionary *dic = [e toDict];
            NSLog(@"%@", dic);
        }
        fail:^(NSError *operation) {
            HIDELOADING;
        }];
}

- (void)afterDel:(TeamMemberCell *)acell {
    member *m = acell.currentMember;
    if ([ownerMember containsObject:m]) {
        [ownerMember removeObject:m];
    } else if ([otherMembers containsObject:m]) {
        [otherMembers removeObject:m];
    }
    [self.teamTableView reloadData];
    [self updataListHeight];
}

- (void)afterCancel:(TeamMemberCell *)acell {

    member *m = acell.currentMember;
    // true:负责组员,有权限修改 false：无权限
    [otherMembers forEach:^(member *obj, NSUInteger idx) {
        if ([obj.memberId isEqualToString:m.memberId]) {
            obj.hasModifyRight = false;
        }
    }];
    [self.teamTableView reloadData];
}
#pragma mark createView
- (UITableView *)teamTableView {
    if (!_teamTableView) {
        _teamTableView = [[UITableView alloc] init];
        _teamTableView.dataSource = self;
        _teamTableView.delegate = self;
        _teamTableView.backgroundColor = [UIColor whiteColor];
        _teamTableView.scrollEnabled = NO;
    }
    return _teamTableView;
}
- (UIView *)moreView {
    if (!_moreView) {
        _moreView = [[UIView alloc] init];
    }
    return _moreView;
}
- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [ViewCreatorHelper createFrameButtonWithTitle:@"点击查看更多>>"
                                                              frame:CGRectZero
                                                             target:self
                                                             action:@selector(selectMoreButton:)];
        [_moreButton setTitleColor:RGBCOLOR(0, 152, 202) forState:UIControlStateNormal];
    }
    return _moreButton;
}
@end
