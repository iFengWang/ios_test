//
//  XSYDetailFeedView.m
//  ingage
//
//  Created by 王桐 on 2018/3/21.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYDetailFeedView.h"
#import "MainPageFeedViewController.h"
#import "Masonry.h"
#import "XSYUserDefaults.h"
#import "feedModel.h"
static inline CGFloat calDetailViewControllerHeight(UIViewController *vc) {
    if ([vc respondsToSelector:@selector(tableView)]) {
        UITableView *t = [vc performSelector:@selector(tableView)];
        return t.contentSize.height;
    } else {
        return 0;
    }
}

@interface XSYDetailFeedView ()
@property (nonatomic, strong) MainPageFeedViewController *feedViewController;
@end

@implementation XSYDetailFeedView
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
            [[[RequestModel alloc]
                initWithGetUrlAndParam:kFeedUnderAccount
                                 param:@{@"objectId": recordId, @"page": @"1", @"size": @"25"}.mutableCopy
                                  type:FromNetWork
                               success:^(id<Element> e) {
                                   if (kSuccessed) {
                                       feedModel *fmodel = [e getBody];
                                       NSMutableArray *feedList = fmodel.feedList;
                                       _feedViewController = [[MainPageFeedViewController alloc]
                                           initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
                                       [self addSubview:_feedViewController.tableView];
                                       _feedViewController.tableView.backgroundColor = [UIColor redColor];
                                       [_feedViewController reloadFeedTableView:feedList];

                                       CGFloat tableViewH = calDetailViewControllerHeight(_feedViewController);
                                       _feedViewController.tableView.scrollEnabled = NO;
                                       [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                           make.height.mas_offset(tableViewH);
                                       }];
                                       _viewHeight = [XSYListenable listenableWithValue:@(tableViewH) setterAction:nil];
                                       _feedViewController.tableView.height = tableViewH;
                                   }
                               }
                                  fail:^(NSError *operation){

                                  }] start];

        } break;

        default:
            break;
    }
}

- (NSString *)viewID {
    return @"xsyDetailFeed";
}

@end
