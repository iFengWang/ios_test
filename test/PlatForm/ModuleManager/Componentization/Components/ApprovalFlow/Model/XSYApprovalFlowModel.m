//
//  XSYApprovalFlowModel.m
//  ingage
//
//  Created by 郭源 on 2018/2/7周三.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYApprovalFlowModel.h"
#import <MJExtension/MJProperty.h>

@implementation XSYApprovalFlowTarget {
    NSString *_apiKey;
    NSString *_recordId;
}

+ (instancetype)targetWithObjectApiKey:(NSString *)apiKey recordId:(NSString *)recordId {
    return [[XSYApprovalFlowTarget alloc] initWithObjectApiKey:apiKey recordId:recordId];
}

- (instancetype)initWithObjectApiKey:(NSString *)apiKey recordId:(NSString *)recordId {
    if (self = [super init]) {
        _apiKey = apiKey;
        _recordId = recordId;
    }
    return self;
}

- (NSURL *)baseURL {
    return [NSURL URLWithString:@"https://crm-devhttps.xiaoshouyi.com"];
}

- (NSString *)path {
    return [NSString
        stringWithFormat:@"/rest/data/v2.0/flows/xobjects/%@/%@/availableApprovalInstances", _apiKey, _recordId];
}

- (XSYHTTPMethodType)method {
    return XSYHTTPMethodGET;
}

- (XSYParameters *)parameters {
    return nil;
}

- (XSYHttpHeaderFields *)headers {
    return nil;
}

- (XSYRequestTask *)task {
    return [XSYRequestTask taskWithRequestSerializerType:XSYRequestSerializerJSON];
}

- (void)request:(void (^)(XSYResult *_Nonnull))completeBlock {
    [XSYProvider.defaultProvider requestWithTarget:self
        transformer:^id(NSDictionary<NSString *, id> *json) {
            return [XSYApprovalFlowModel mj_objectWithKeyValues:json];
        }
        completion:^(XSYResult<XSYApprovalFlowModel *> *result) {
            completeBlock(result);
        }];
}

@end

@implementation XSYApprovalFlowModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"approverList": NSStringFromClass(XSYApprover.class),
        @"selectableApproverList": NSStringFromClass(XSYApprover.class),
        @"currentApprovalList": NSStringFromClass(XSYApproval.class),
        @"allApprovals": NSStringFromClass(XSYApproval.class),
    };
}

@end

@implementation XSYApprovalFlowModel (View)

- (UIColor *)color {
    switch (self.approvalStatus) {
        case XSYApprovalStatusUnsubmit:
            return [UIColor hexChangeFloat:@"FF9900"]; // 未提交
        case XSYApprovalStatusPending:
            return [UIColor hexChangeFloat:@"0A7CD9"]; // 待审批
        case XSYApprovalStatusReject:
            return [UIColor hexChangeFloat:@"FF3333"]; // 拒绝
        case XSYApprovalStatusPass:
            return [UIColor hexChangeFloat:@"00B377"]; // 审批通过
        case XSYApprovalStatusRevoke:
            return [UIColor hexChangeFloat:@"0A7CD9"]; // 撤销
    }
}
- (NSString *)stateString {
    switch (self.approvalStatus) {
        case XSYApprovalStatusUnsubmit:
            return kValue(@"common_btn_submit"); // 未提交
        case XSYApprovalStatusPending:
            return kValue(@"default_approval"); // 待审批
        case XSYApprovalStatusReject:
            return kValue(@"approval_btn_resubmit"); // 拒绝
        case XSYApprovalStatusPass:
            return kValue(@"default_approval"); // 审批通过
        case XSYApprovalStatusRevoke:
            return kValue(@"approval_btn_cancel"); // 撤销
    }
}

- (BOOL)showStateBtn {
    switch (self.approvalStatus) {
        case XSYApprovalStatusUnsubmit:
            return self.submitApprovalable;// 待提交
        case XSYApprovalStatusPending:
            if ([[NSString stringWithFormat:@"%u",self.currentApproverId]  isEqualToString:kCurrentUid] || self.cancelApprovalable) {
                return YES;// 待审批
            }else {
                return NO;
            }
        case XSYApprovalStatusReject:
            return self.submitApprovalable; // 拒绝
        case XSYApprovalStatusPass:
           return NO; // 审批通过
        case XSYApprovalStatusRevoke:
            return self.submitApprovalable;// 撤回
    }
}

- (NSString *)titleLabStr {
    NSString *flowName = XSYLocalized(self.flowInstanceNameKey, self.flowInstanceName);
    switch (self.approvalStatus) {
        case XSYApprovalStatusUnsubmit:
            return [NSString stringWithFormat:@"【%@】%@",flowName,@"等待您的提交"];// 待提交
        case XSYApprovalStatusPending:
            return [NSString stringWithFormat:@"【%@】%@",flowName,@"等待审批"];// 待审批
        case XSYApprovalStatusReject:
            return [NSString stringWithFormat:@"【%@】%@",flowName,@"审批拒绝"]; // 拒绝
        case XSYApprovalStatusPass:
            return [NSString stringWithFormat:@"【%@】%@",flowName,@"审批通过"];; // 审批通过
        case XSYApprovalStatusRevoke:
            return  [NSString stringWithFormat:@"【%@】%@",flowName,@"审批撤回"];;// 撤回
    }
}

@end

@implementation XSYApprover

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uid": @"id"};
}

@end
@implementation XSYApproval
@end
