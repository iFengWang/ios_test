//
//  XSYEnterpriseRecommendedController.m
//  ingage
//
//  Created by 朱洪伟 on 2018/3/9.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYEnterpriseRecommendedController.h"
#import "XSYEnterpriseRecommendedModel.h"
#import "XSYEnterpriseRecommendedView.h"

@interface XSYEnterpriseRecommendedController ()
@property (nonatomic, strong) XSYEnterpriseRecommendedView *photoShowView;

@end

@implementation XSYEnterpriseRecommendedController

- (void)componentWillShow {
    [self.view setModel:nil];
    //    XSYEnterpriseRecommendedTarget *target = [XSYEnterpriseRecommendedTarget
    //    targetWithObjectApiKey:self.objectApiKey recordId:self.recordId];
    //
    //    [target request:^(XSYResult<XSYEnterpriseRecommendedModel *> *_Nonnull result) {
    //        if (result.value) {
    //            [self.view setModel:result.value];
    //            NSLog(@"%@", result.value);
    //        } else {
    //            NSLog(@"%@", result.error);
    //        }
    //    }];
}

- (UIView<XSYEntityDetailComponent> *)view {
    if (!_photoShowView) {
        _photoShowView = [XSYEnterpriseRecommendedView new];
    }
    return _photoShowView;
}

@end
