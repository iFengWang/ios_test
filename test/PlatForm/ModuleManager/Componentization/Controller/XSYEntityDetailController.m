//
//  XSYEntityDetailController.m
//  ingage
//
//  Created by 郭源 on 2018/2/6周二.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYEntityDetailController.h"
#import "NSArray+Functional.h"
#import "PopOverActionSheet.h"
#import "RequestModelApi.h"
#import "XSYApprovalFlowController.h"
#import "XSYDetailPermissionsModel.h"
#import "XSYDetailPhotoShowViewController.h"
#import "XSYDetailTitleViewController.h"
#import "XSYEnterpriseRecommendedController.h"
#import "XSYEntityDetailLayout.h"
#import "XSYPageViewController.h"
#import "XSYProcessVisualController.h"
#import "XSYQuickOperationController.h"
#import "XSYTeamWorkController.h"
#import "XSYUserDefaults.h"
#import <Masonry/Masonry.h>
#import <YYModel/YYModel.h>

@interface XSYEntityDetailController () <PopOverActionSheetDelegate>

@property (readonly, nonatomic, copy) NSString *apiKey;
@property (readonly, nonatomic, copy) NSString *objectId;
@property (readonly, nonatomic, copy) NSString *recordId;

@property (nonatomic, strong) PopOverActionSheet *actionSheetView;
@property (nonatomic, strong) XSYDetailPermissionsModel *permissionsModel; //用户Layout权限model
@property (nonatomic, strong) XSYEntityDetailLayout *layoutModel;          //页面布局

@end

@implementation XSYEntityDetailController

- (instancetype)initWithObjectApiKey:(NSString *)apiKey objectId:(NSString *)objectId recordId:(NSString *)recordId {
    if (self = [super init]) {
        _apiKey = apiKey;
        _objectId = objectId;
        _recordId = recordId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setLeftItemWithTarget:self action:@selector(gotoLastPage) image:BackItemImage];

    self.view.backgroundColor = UIColor.whiteColor;
    [self requestLayoutPermissions];
}

- (void)layoutDistribution {
    UIViewController *vc = [self.childViewControllers lastObject];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];

    XSYEntityDetailConfigLayout *config = self.layoutModel.layoutConfig;

    XSYPageViewController *mobileDetailPage = [[XSYPageViewController alloc] initWithObjectApiKey:self.apiKey
                                                                                         objectId:self.objectId
                                                                                         recordId:self.recordId
                                                                                           layout:config];
    [mobileDetailPage willMoveToParentViewController:self];
    [self addChildViewController:mobileDetailPage];
    [mobileDetailPage didMoveToParentViewController:self];
    [self.view addSubview:mobileDetailPage.view];
    mobileDetailPage.view.frame = self.view.bounds;
    self.navigationItem.titleView = mobileDetailPage.selectView;

    if ([config.attributes[@"topRight"] isEqualToString:@"more"]) {
        [self.navigationItem setRightMoreWithTarget:self action:@selector(popAddActionSheet)];
    }
}
- (void)requestLayoutPermissions {
    /* 通过用户权限接口获取自定义layout 布局ID 如果没有数据需要获取默认布局ID
     */
    NSDictionary *dic = @{ @"layoutType": @(106), @"xobjectApiKey": _apiKey };
    RequestModelApi *request = [[RequestModelApi alloc] initWithGetUrlAndParam:@"/data/v2.0/privacies/layoutPermissions"
        param:dic.mutableCopy
        type:FromNetWork
        success:^(id<Element> e) {
            NSDictionary *json = [e toDict];
            NSDictionary *data = [json objectForKey:@"data"] ?: @{};
            NSArray *records = [data objectForKey:@"records"];
            if (records.count == 0) {
                [self requestPermissionsLayout];
            } else {
                NSLog(@"%@", records);
            }

        }
        fail:^(NSError *operation) {
            NSLog(@"%@", operation);
            [self requestPermissionsLayout];
        }];
    [request start];
}
- (void)requestPermissionsLayout {
    /* 1：通过用户权限接口获取到用户默认布局列表 取出customFlg==flase（系统默认布局）
       2：通过 layout得到布局ID 并紧接着获取layout布局
     */
    if ([ingageTool isEmpty:_apiKey]) {
        [[ingAlertView sharedAlertViewWithTitle:@"apiKey 异常"] showAlert:YES];
        return;
    }
    NSDictionary *dic = @{ @"layoutType": @(106), @"xobjectApiKey": _apiKey };
    RequestModelApi *request = [[RequestModelApi alloc] initWithGetUrlAndParam:@"/metadata/v2.0/layouts"
        param:dic.mutableCopy
        type:FromNetWork
        success:^(id<Element> e) {
            NSDictionary *json = [e toDict];
            NSDictionary *records = [[json objectForKey:@"data"] objectForKey:@"records"];
            NSArray *layouts = [records objectForKey:@"layouts"];
            NSDictionary *dic = [layouts lastObject];
            self.permissionsModel = [XSYDetailPermissionsModel mj_objectWithKeyValues:dic];
            [self requestLayout:self.permissionsModel];
//            [layouts forEach:^(NSDictionary *obj, NSUInteger idx) {
//                NSNumber *customFlg = [obj objectForKey:@"customFlg"];
//                if (!customFlg.boolValue) {
//                    self.permissionsModel = [XSYDetailPermissionsModel mj_objectWithKeyValues:obj];
//                    [self requestLayout:self.permissionsModel];
//                    return;
//                }
//            }];
        }
        fail:^(NSError *operation) {
            self.permissionsModel = [XSYDetailPermissionsModel mj_objectWithKeyValues:dic];
            self.permissionsModel.layoutId = @(1610695);
            [self requestLayout:self.permissionsModel];
            NSLog(@"%@", operation);

        }];
    [request start];
}

- (void)requestLayout:(XSYDetailPermissionsModel *)model {
    NSString *url = [NSString stringWithFormat:@"%@%@", @"/metadata/v2.0/layouts/", model.layoutId];
    [RequestModelApi get:url
        param:nil
        type:FromNetWork
        success:^(id<Element> e) {
            NSDictionary *json = [e toDict];
            NSDictionary *layout = [[[json objectForKey:@"data"] objectForKey:@"records"] objectForKey:@"layout"];
            self.layoutModel = [XSYEntityDetailLayout yy_modelWithJSON:layout];
            [self layoutDistribution];
        }
        fail:^(NSError *operation) {
            NSLog(@"%@", operation);
        }];
}

- (void)gotoLastPage {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)popAddActionSheet {

    [self createActionSheetView];
    self.actionSheetView.hidden = NO;
}
- (void)createActionSheetView {
    if (self.actionSheetView == nil) {
        self.actionSheetView =
            (PopOverActionSheet *)[viewTool loadXibWithName:@"PopOverActionSheet" withObject:nil withOptions:nil];
        self.actionSheetView.delegate = self;
        [self.actionSheetView initModel:nil];
        [self.actionSheetView showInViewController:nil];
    }

    [self.actionSheetView initModel:nil];
}
- (NSMutableArray *)getPopOverSheetModelArry {
    NSMutableArray *operationArr = [NSMutableArray new];
    NSMutableArray *firstArry = [[NSMutableArray alloc] init];

    PopOverSheetModel *model = [[PopOverSheetModel alloc] init];
    model.title = kValue(@"crm_btn_schedule_add");
    model.selectorString = @"toScheduleAddPage";
    [firstArry addObject:model];

    model = [[PopOverSheetModel alloc] init];
    model.title = kValue(@"visitplan_title_toaddpage");
    model.selectorString = @"toVisitplanAddPage";
    [firstArry addObject:model];

    model = [[PopOverSheetModel alloc] init];
    model.title = kValue(@"crm_btn_task_add");
    model.selectorString = @"toTaskAddPage";
    [firstArry addObject:model];

    [operationArr addObject:firstArry];

    return operationArr;
}

@end
