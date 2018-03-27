//
//  XSYDetailTitleTestViewController.m
//  ingage
//
//  Created by 朱洪伟 on 2018/2/27.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYDetailTitleTestViewController.h"
#import <Masonry/Masonry.h>
#import "XSYDetailTitleViewController.h"
#import "XSYDetailPhotoShowViewController.h"
#import "XSYDetailPhotoShowView.h"
#import "XSYEnterpriseRecommendedController.h"
#import "XSYWorkFlowViewController.h"
#import "XSYProcessVisualController.h"

@interface XSYDetailTitleTestViewController ()
@property (nonatomic,strong)UIScrollView * backScrollView;
@property (nonatomic,strong)UIView * backBottomView;
@end

@implementation XSYDetailTitleTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"组件测试";

    [self.view addSubview: self.backScrollView];
    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [self.backScrollView addSubview:self.backBottomView];
    [self.backBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.backScrollView);
    }];

//    XSYDetailPhotoShowViewController * contrView1 = [[XSYDetailPhotoShowViewController alloc] initWithObjectApiKey:@"PhotoShow" recordId:@"262815" objectId:@"" layout:nil];
//    [self.backBottomView addSubview:contrView1.view];
//    [contrView1.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(0));
//        make.left.right.equalTo(self.backBottomView);
//        make.height.mas_equalTo(200);
//    }];
//    XSYDetailTitleViewController * contrView2 =[[XSYDetailTitleViewController alloc] initWithObjectApiKey:@"Process" recordId:@"262816" objectId:@""layout:nil];
//    [self.backBottomView addSubview:contrView2.view];
//    [contrView2.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contrView1.view.mas_bottom).with.offset(10);
//        make.left.right.equalTo(self.backBottomView);
//        make.height.mas_equalTo(180);
//        make.width.mas_equalTo(kScreenWidth);
//    }];
//    XSYProcessVisualController * contrView3 = [[XSYProcessVisualController alloc] initWithObjectApiKey:@"Process" recordId:@"262815" objectId:@""layout:nil];
//    [self.backBottomView addSubview:contrView3.view];
//    [contrView3.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contrView2.view.mas_bottom).with.offset(10);
//        make.left.right.equalTo(self.backBottomView);
//        make.height.mas_equalTo(100);
//        make.width.mas_equalTo(kScreenWidth);
//    }];
//
//    XSYEnterpriseRecommendedController * contrView4 =[[XSYEnterpriseRecommendedController alloc] initWithObjectApiKey:@"Process" recordId:@"262815" objectId:@""layout:nil];
//    [self.backBottomView addSubview:contrView4.view];
//    [contrView4.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contrView3.view.mas_bottom).with.offset(10);
//        make.left.right.equalTo(self.backBottomView);
//        make.height.mas_equalTo(200);
//        make.width.mas_equalTo(kScreenWidth);
//    }];
//
//    XSYWorkFlowViewController *  contrView5 =[[XSYWorkFlowViewController alloc] initWithObjectApiKey:@"Process" recordId:@"262815" objectId:@"1"layout:nil];
//    [self.backBottomView addSubview:contrView5.view];
//    [contrView5.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contrView4.view.mas_bottom).with.offset(10);
//        make.left.right.equalTo(self.backBottomView);
//        make.height.mas_equalTo(50);
//    }];
//    [contrView5 componentWillShow];
//
//    XSYWorkFlowViewController *  contrView51 =[[XSYWorkFlowViewController alloc] initWithObjectApiKey:@"Process" recordId:@"262815" objectId:@"2"layout:nil];
//    [self.backBottomView addSubview:contrView51.view];
//    [contrView51.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contrView5.view.mas_bottom).with.offset(10);
//        make.left.right.equalTo(self.backBottomView);
//        make.height.mas_equalTo(50);
//    }];
//    [contrView51 componentWillShow];
//
//    XSYWorkFlowViewController *  contrView52 =[[XSYWorkFlowViewController alloc] initWithObjectApiKey:@"Process" recordId:@"262815" objectId:@"3"layout:nil];
//    [self.backBottomView addSubview:contrView52.view];
//    [contrView52.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contrView51.view.mas_bottom).with.offset(10);
//        make.left.right.equalTo(self.backBottomView);
//        make.height.mas_equalTo(50);
//    }];
//    [contrView52 componentWillShow];
//
//    XSYWorkFlowViewController *  contrView53 =[[XSYWorkFlowViewController alloc] initWithObjectApiKey:@"Process" recordId:@"262815" objectId:@"4"layout:nil];
//    [self.backBottomView addSubview:contrView53.view];
//    [contrView53.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contrView52.view.mas_bottom).with.offset(10);
//        make.left.right.equalTo(self.backBottomView);
//        make.bottom.equalTo(self.backBottomView);
//        make.height.mas_equalTo(50);
//    }];
//    [contrView53 componentWillShow];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIScrollView*)backScrollView{
    if (!_backScrollView) {
        _backScrollView = [UIScrollView new];
    }
    return _backScrollView;
}
- (UIView*)backBottomView{
    if (!_backBottomView) {
        _backBottomView = [UIView new];
    }
    return _backBottomView;
}
@end
