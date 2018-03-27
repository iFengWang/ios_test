//
//  XSYDetailPhotoShowViewController.m
//  ingage
//
//  Created by 朱洪伟 on 2018/3/9.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYDetailPhotoShowViewController.h"
#import "XSYDetailPhotoShowModel.h"
#import "XSYDetailPhotoShowView.h"

@interface XSYDetailPhotoShowViewController ()
@property (nonatomic, strong) XSYDetailPhotoShowView *photoShowView;
@end

@implementation XSYDetailPhotoShowViewController

- (void)componentWillShow {
    [self.view setModel:nil];
    //    XSYDetailPhotoShowTarget *target = [XSYDetailPhotoShowTarget targetWithObjectApiKey:self.objectApiKey
    //    recordId:self.recordId];
    //
    //    [target request:^(XSYResult<XSYDetailPhotoShowModel *> *_Nonnull result) {
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
        _photoShowView = [XSYDetailPhotoShowView new];
    }
    return _photoShowView;
}

@end
