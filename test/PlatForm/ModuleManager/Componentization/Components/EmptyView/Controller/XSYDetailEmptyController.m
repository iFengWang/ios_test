//
//  XSYDetailEmptyController.m
//  ingage
//
//  Created by 朱洪伟 on 2018/3/16.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYDetailEmptyController.h"
#import "XSYDetailEmptyView.h"

@interface XSYDetailEmptyController ()
@property (nonatomic, strong) XSYDetailEmptyView *detailEmptyView;
@property (nonatomic, strong) NSDictionary *objectData;
@end

@implementation XSYDetailEmptyController
- (void)componentWillShow {
    [self.view setModel:nil];
}

- (UIView<XSYEntityDetailComponent> *)view {
    if (!_detailEmptyView) {
        _detailEmptyView = [XSYDetailEmptyView new];
    }
    return _detailEmptyView;
}
@end
