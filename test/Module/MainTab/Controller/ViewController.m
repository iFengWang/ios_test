//
//  ViewController.m
//  test
//
//  Created by 王广峰 on 2018/2/5.
//  Copyright © 2018年 frank. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NetRequestProtocol>
@property (nonatomic, strong) UIButton * loginBtn;
@property (nonatomic, strong) UIButton * logoutBtn;
@property (nonatomic, strong) UITextField * txtField;
@property (nonatomic, strong) UILabel * txtLabel;
@property (nonatomic, strong) UIButton * sumBtn;

@property (nonatomic, strong) id<AdaptorProtocol> oneAdaptor;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:DEFAUT_MAIN_COLOR];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.logoutBtn];
    [self.view addSubview:self.txtField];
    [self.view addSubview:self.txtLabel];
    [self.view addSubview:self.sumBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - call net request
- (void)callNetRouter {
    NetRequest * aRequest = [[NetRequest alloc] init];
    aRequest.router = @"http://www.baidu.com";
    [aRequest callApiWithParam:@{}];
}

- (void)onSuccessWithNetRequest:(NetRequest *)netRequest {
    NSDictionary * dict = [netRequest fetchDataWithAdaptor:self.oneAdaptor];
    NSLog(@"dict....%@",dict);
}

- (void)onFailWithNetRequest:(NetRequest *)netRequest {
    
}

#pragma mark - events
- (IBAction)onBtnClick:(id)sender {
    if ([sender tag] == 1) {
        [self.undoManager undo];
    } else if ([sender tag] == 2) {
        [self.undoManager redo];
    } else if ([sender tag] == 3) {
        [self pushNnmber:[self.txtField.text intValue]];
    }
}

- (void)pushNnmber:(int)param {
    [[self.undoManager prepareWithInvocationTarget:self] popNumber:param];
//        NSString *title = [NSString stringWithFormat:@"showMessage%d", arc4random()];
//        [self.undoManager setActionName:title];
    [self.txtLabel setText:[NSString stringWithFormat:@"%d",param]];
}

- (void)popNumber:(int)param {
    [[self.undoManager prepareWithInvocationTarget:self] pushNnmber:param];
    [self.txtLabel setText:[NSString stringWithFormat:@"%d",param]];
}



#pragma mark - getter & setter
- (UIButton *)loginBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"撤消" forState:UIControlStateNormal];
    [btn setTitleColor:DEFAUT_BUTTON_COLOR forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(20, 30, [UIScreen mainScreen].bounds.size.width - 20*2, 40)];
    [btn setTag:1];
    [btn.layer setBorderColor:DEFAUT_BUTTON_COLOR.CGColor];
    [btn.layer setBorderWidth:0.5f];
    [btn.layer setMasksToBounds:NO];
    [btn.layer setCornerRadius:20];
    [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIButton *)logoutBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"重做" forState:UIControlStateNormal];
    [btn setTitleColor:DEFAUT_BUTTON_COLOR forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(20, 80, [UIScreen mainScreen].bounds.size.width - 20*2, 40)];
    [btn setTag:2];
    [btn.layer setBorderColor:DEFAUT_BUTTON_COLOR.CGColor];
    [btn.layer setBorderWidth:0.5f];
    [btn.layer setMasksToBounds:NO];
    [btn.layer setCornerRadius:20];
    [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UITextField *)txtField {
    if (!_txtField) {
        _txtField = [[UITextField alloc] initWithFrame:CGRectMake(20, 130, [UIScreen mainScreen].bounds.size.width/2 - 20, 40)];
        [_txtField setBorderStyle:UITextBorderStyleLine];
    }
    return _txtField;
}

- (UILabel *)txtLabel {
    if (!_txtLabel) {
        _txtLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 20, 130, [UIScreen mainScreen].bounds.size.width/2 - 20*2, 40)];
        [_txtLabel.layer setBorderColor:[UIColor redColor].CGColor];
        [_txtLabel.layer setBorderWidth:1];
        [_txtLabel setTextColor:[UIColor redColor]];
    }
    return _txtLabel;
}

- (UIButton *)sumBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"显示" forState:UIControlStateNormal];
    [btn setTitleColor:DEFAUT_BUTTON_COLOR forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(20, 180, [UIScreen mainScreen].bounds.size.width - 20*2, 40)];
    [btn setTag:3];
    [btn.layer setBorderColor:DEFAUT_BUTTON_COLOR.CGColor];
    [btn.layer setBorderWidth:0.5f];
    [btn.layer setMasksToBounds:NO];
    [btn.layer setCornerRadius:20];
    [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end
