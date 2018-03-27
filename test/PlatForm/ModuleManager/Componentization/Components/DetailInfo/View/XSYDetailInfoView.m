//
//  XSYDetailInfoView.m
//  ingage
//
//  Created by 王桐 on 2018/3/20.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYDetailInfoView.h"
#import "Masonry.h"
#import "XSYUserDefaults.h"
#import "accountDetailViewController.h"
static inline CGFloat calDetailViewControllerHeight(UIViewController *vc) {
    if ([vc respondsToSelector:@selector(tableView)]) {
        UITableView *t = [vc performSelector:@selector(tableView)];
        return t.contentSize.height;
    } else {
        return 0;
    }
}
@interface XSYDetailInfoView ()
@property (nonatomic, strong) BaseActivityDetailController *detailViewController;
@end

@implementation XSYDetailInfoView
@synthesize viewHeight = _viewHeight;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _viewHeight = [XSYListenable listenableWithValue:@(200) setterAction:nil];
    }
    return self;
}

#pragma mark -
#pragma mark - XSYEntityDetailComponentIdentifier

- (void)setModel:(id)model {
    NSDictionary *dict = model;
    NSString *objectId = dict[@"objectId"];
    NSString *recordId = dict[@"recordId"];
    switch ([objectId integerValue]) {
        case ENTITY_BELONG_ACCOUNT: {
            accountDetailViewController *controller = [accountDetailViewController new];
            controller.accountId = recordId;
            [controller getData];
            _detailViewController = controller;
            controller.canUpdateBlock = ^(BOOL canUpdate) {
                CGFloat tableViewH = calDetailViewControllerHeight(_detailViewController);
                _detailViewController.tableView.scrollEnabled = NO;
                [self mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_offset(tableViewH);
                }];
                _viewHeight = [XSYListenable listenableWithValue:@(tableViewH) setterAction:nil];
                _detailViewController.tableView.height = tableViewH;
            };
            [self addSubview:controller.tableView];
        } break;

        default:
            break;
    }
}

- (NSString *)viewID {
    return @"xsyDetailInfo";
}

@end
