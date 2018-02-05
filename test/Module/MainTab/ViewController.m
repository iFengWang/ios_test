//
//  ViewController.m
//  test
//
//  Created by 王广峰 on 2018/2/5.
//  Copyright © 2018年 frank. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIButton * loginBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:DEFAUT_MAIN_COLOR];
    [self.view addSubview:self.loginBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter & setter
- (UIButton *)loginBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(20, 30, [UIScreen mainScreen].bounds.size.width - 20*2, 40)];
    [btn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [btn.layer setBorderWidth:0.5f];
    [btn.layer setMasksToBounds:NO];
    [btn.layer setCornerRadius:20];
    return btn;
}

@end
