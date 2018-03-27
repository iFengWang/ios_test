//
//  XSYWorkFlowViewController.m
//  ingage
//
//  Created by 朱洪伟 on 2018/3/8.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYWorkFlowViewController.h"
#import "XSYWorkFlowViewModel.h"
#import "XSYWorkFlowView.h"
@interface XSYWorkFlowViewController ()
@property (nonatomic,strong)XSYWorkFlowView * workFlowView;
@end

@implementation XSYWorkFlowViewController

- (void)componentWillShow {
    XSYWorkFlowViewTarget *target =
    [XSYWorkFlowViewTarget targetWithObjectApiKey:self.objectApiKey recordId:self.recordId];
    
    [target request:^(XSYResult<XSYWorkFlowViewModel *> *_Nonnull result) {
        if (result.value) {
//            [self.view setModel:result.value];
            NSLog(@"%@", result.value);
        } else {
            NSLog(@"%@", result.error);
        }
        XSYWorkFlowViewModel * model = [[XSYWorkFlowViewModel alloc] init];
        if (self.objectId.integerValue==1) {
            model.flowType = 0;
        }else if (self.objectId.integerValue==2){
            model.flowType = 1;
        }else if (self.objectId.integerValue==3){
            model.flowType = 2;
        }else if (self.objectId.integerValue==4){
            model.flowType = 3;
        }
        [self.view setModel:model];
    }];
}

- (UIView<XSYEntityDetailComponent> *)view {
    if (!_workFlowView) {
        _workFlowView = [XSYWorkFlowView new];
    }
    return _workFlowView;
}
@end
