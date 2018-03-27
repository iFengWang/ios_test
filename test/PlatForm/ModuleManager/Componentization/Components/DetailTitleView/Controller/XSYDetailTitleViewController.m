//
//  XSYDetailTitleViewController.m
//  ingage
//
//  Created by 朱洪伟 on 2018/2/26.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYDetailTitleViewController.h"
#import "RequestModelApi.h"
#import "XSYDetailObjectApiDataModel.h"
#import "XSYDetailTitleLayout.h"
#import "XSYDetailTitleView.h"
#import "XSYMeteDataObjects.h"
@interface XSYDetailTitleViewController () <XSYDetailTitleViewDelegate>
@property (nonatomic, strong) XSYDetailTitleView *detailTitleView;
@property (nonatomic, strong) NSDictionary *objectData;
@end

@implementation XSYDetailTitleViewController

- (void)componentWillShow {

    XSYMeteDataObjects *obj = [XSYMeteDataObjectsFile getMeteDataObjects:self.objectId];
    if (!obj) {
        NSLog(@"object数据出错");
        return;
    }
    XSYDetailTitleModel *titleModel = [[XSYDetailTitleModel alloc] init];
    titleModel.objectId = self.objectId;
    titleModel.recordId = self.recordId;
    titleModel.apiKey = self.objectApiKey;
    titleModel.titleApiKey = obj.apiKey;
    titleModel.layout = self.layout;

    XSYDetailObjectApiModel *model = self.metaData;

    NSString *url = [NSString stringWithFormat:@"/data/v2.0/xobjects/%@/%@", obj.apiKey, self.recordId];
    [RequestModelApi get:url
        param:nil
        type:FromSandBox
        success:^(id<Element> e) {
            NSDictionary *dic = [e toDict];
            model.data = dic;
            titleModel.objectData = model;
            XSYDetailTitleLayout *layout = [[XSYDetailTitleLayout alloc] initWithTitleModel:titleModel];
            [self.view setModel:layout];
        }
        fail:^(NSError *operation) {
            NSLog(@"XSYDetailTitleViewController 组件数据请求出错");
        }];
    //    [request start];
}
- (UIView<XSYEntityDetailComponent> *)view {
    if (!_detailTitleView) {
        _detailTitleView = [XSYDetailTitleView new];
        _detailTitleView.userInteractionEnabled = YES;
        _detailTitleView.delegate = self;
    }
    return _detailTitleView;
}
- (void)XSYDetailTitleViewDidClickItem:(XSYDetailTitleLabelModel *)labelModel {
}

@end
