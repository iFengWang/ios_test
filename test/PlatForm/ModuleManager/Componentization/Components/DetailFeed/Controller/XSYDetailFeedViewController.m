//
//  XSYDetailFeedViewController.m
//  ingage
//
//  Created by 王桐 on 2018/3/21.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYDetailFeedViewController.h"
#import "XSYDetailFeedView.h"

@interface XSYDetailFeedViewController ()
@property (nonatomic, strong) XSYDetailFeedView *detailFeedView;
@end

@implementation XSYDetailFeedViewController
- (void)componentWillShow {

    [self.view setModel:@{@"objectId": self.objectId, @"recordId": self.recordId}];
}
- (UIView<XSYEntityDetailComponent> *)view {
    if (!_detailFeedView) {
        _detailFeedView = [XSYDetailFeedView new];
    }
    return _detailFeedView;
}
@end
