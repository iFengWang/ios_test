//
//  XSYProcessVisualController.m
//  ingage
//
//  Created by 朱洪伟 on 2018/3/5.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYProcessVisualController.h"
#import "XSYProcessVisualView.h"
#import "XSYProcessVisualModel.h"

@interface XSYProcessVisualController ()
@property (nonatomic,strong)XSYProcessVisualView * photoShowView;

@end

@implementation XSYProcessVisualController

- (void)componentWillShow {
     [self.view setModel:nil];
//    XSYProcessVisualTarget *target = [XSYProcessVisualTarget targetWithObjectApiKey:self.objectApiKey recordId:self.recordId];
//
//    [target request:^(XSYResult<XSYProcessVisualModel *> *_Nonnull result) {
//        if (result.value) {
//            [self.view setModel:result.value];
//            NSLog(@"%@", result.value);
//        } else {
//            NSLog(@"%@", result.error);
//        }
//    }];
}
- (void)createObject:(NSDictionary*)object{
    
}
- (UIView<XSYEntityDetailComponent> *)view {
    if (!_photoShowView) {
        _photoShowView = [XSYProcessVisualView new];
    }
    return _photoShowView;
}
@end
