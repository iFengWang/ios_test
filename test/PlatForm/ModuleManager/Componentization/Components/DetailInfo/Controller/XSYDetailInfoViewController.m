//
//  XSYDetailInfoViewController.m
//  ingage
//
//  Created by 王桐 on 2018/3/20.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYDetailInfoViewController.h"
#import "XSYDetailInfoView.h"

@interface XSYDetailInfoViewController ()
@property (nonatomic, strong) XSYDetailInfoView *detailInfoView;
@end

@implementation XSYDetailInfoViewController
- (void)componentWillShow {

    [self.view setModel:@{@"objectId": self.objectId, @"recordId": self.recordId}];
}
- (UIView<XSYEntityDetailComponent> *)view {
    if (!_detailInfoView) {
        _detailInfoView = [XSYDetailInfoView new];
    }
    return _detailInfoView;
}
@end
