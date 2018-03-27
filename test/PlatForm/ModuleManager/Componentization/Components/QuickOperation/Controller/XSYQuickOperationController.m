//
//  XSYQuickOperationController.m
//  ingage
//
//  Created by AJ-1993 on 2018/2/27.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYQuickOperationController.h"
#import "XSYQuickOperationModel.h"
#import "XSYQuickOperationView.h"

@implementation XSYQuickOperationController {
    XSYQuickOperationView *_quickOperationView;
}
- (void)componentWillShow {
    XSYQuickOperationTarget *target =
    [XSYQuickOperationTarget targetWithObjectApiKey:self.objectApiKey recordId:self.recordId];
    
    [target request:^(XSYResult<XSYQuickOperationModel *> *_Nonnull result) {
        if (result.value) {
            [self.view setModel:result.value];
            NSLog(@"%@", result.value);
        } else {
            NSLog(@"%@", result.error);
        }
    }];
}

- (UIView<XSYEntityDetailComponent> *)view {
    if (!_quickOperationView) {
        _quickOperationView = [XSYQuickOperationView new];
    }
    return _quickOperationView;
}

@end
