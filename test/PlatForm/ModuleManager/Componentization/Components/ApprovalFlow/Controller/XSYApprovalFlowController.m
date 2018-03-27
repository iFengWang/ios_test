//
//  XSYApprovalFlowController.m
//  ingage
//
//  Created by 郭源 on 2018/2/7周三.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYApprovalFlowController.h"
#import "RequestModelApi.h"
#import "XSYApprovalFlowModel.h"
#import "XSYApprovalFlowView.h"
#import "XSYMeteDataObjects.h"

@implementation XSYApprovalFlowController {
    XSYApprovalFlowView *_approvalView;
}

- (void)componentWillShow {
    //    titleModel.objectId = self.objectId;
    //    titleModel.recordId = self.recordId;
    //    titleModel.apiKey = self.objectApiKey;
    //    titleModel.titleApiKey = obj.apiKey;
    //    titleModel.layout = self.layout;

    XSYDetailObjectApiModel *model = self.metaData;

    NSString *url = [NSString
        stringWithFormat:@"/data/v2.0/flows/xobjects/%@/%@/approvalInstances", self.objectApiKey, self.recordId];
    [RequestModelApi get:url
        param:nil
        type:FromNetWork
        success:^(id<Element> e) {
            NSDictionary *dic = [[e toDict] objectForKey:@"data"];
            XSYApprovalFlowModel *model = [XSYApprovalFlowModel mj_objectWithKeyValues:dic];
            //                     model.data = dic;
            //                     titleModel.objectData = model;
            //                     XSYDetailTitleLayout *layout = [[XSYDetailTitleLayout alloc]
            //                     initWithTitleModel:titleModel];
            [self.view setModel:model];
        }
        fail:^(NSError *operation) {
            NSLog(@"XSYDetailTitleViewController 组件数据请求出错");
        }];
    //    XSYApprovalFlowTarget *target =
    //        [XSYApprovalFlowTarget targetWithObjectApiKey:self.objectApiKey recordId:self.recordId];
    //
    //    [target request:^(XSYResult<XSYApprovalFlowModel *> *_Nonnull result) {
    //        if (result.value) {
    //            [self.view setModel:result.value];
    //            NSLog(@"%@", result.value);
    //        } else {
    //            [self.view setModel:result.value];
    //            NSLog(@"%@", result.error);
    //        }
    //    }];
}

- (UIView<XSYEntityDetailComponent> *)view {
    if (!_approvalView) {
        _approvalView = [XSYApprovalFlowView new];
    }
    return _approvalView;
}

@end
