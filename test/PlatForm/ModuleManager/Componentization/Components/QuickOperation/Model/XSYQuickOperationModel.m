//
//  XSYQuickOperationModel.m
//  ingage
//
//  Created by AJ-1993 on 2018/2/27.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYQuickOperationModel.h"

@implementation XSYQuickOperationTarget {
    NSString *_apiKey;
    NSString *_recordId;
}
+ (instancetype)targetWithObjectApiKey:(NSString *)apiKey recordId:(NSString *)recordId {
    return [[XSYQuickOperationTarget alloc] initWithObjectApiKey:apiKey recordId:recordId];
}

- (instancetype)initWithObjectApiKey:(NSString *)apiKey recordId:(NSString *)recordId {
    if (self = [super init]) {
        _apiKey = apiKey;
        _recordId = recordId;
    }
    return self;
}

- (NSURL *)baseURL {
    return [NSURL URLWithString:@"https://api-devhttps.xiaoshouyi.com"];
}

- (NSString *)path {
    return [NSString
            stringWithFormat:@"/rest/metadata/v2.0/xobjects/customEntity23__c/layouts/1567099"];
}

- (XSYHTTPMethodType)method {
    return XSYHTTPMethodGET;
}

- (XSYParameters *)parameters {
    return nil;
}

- (XSYHttpHeaderFields *)headers {
    return @{
             @"Accept-Language": @"zh",
             @"Accept-Encoding": @"gzip",
             @"xsy-user-id": @(65748).stringValue,
             @"xsy-tenant-id": @(56330).stringValue,
             @"xsy-device": @(12).stringValue,
             @"Content-Type": @"application/json"
             };
}

- (XSYRequestTask *)task {
    return [XSYRequestTask taskWithRequestSerializerType:XSYRequestSerializerJSON];
}

- (void)request:(void (^)(XSYResult *_Nonnull))completeBlock {
    [XSYProvider.defaultProvider requestWithTarget:self
                                       transformer:^id(NSDictionary<NSString *, id> *json) {
                                           return [XSYQuickOperationModel mj_objectWithKeyValues:json];
                                       }
                                        completion:^(XSYResult<XSYQuickOperationModel *> *result) {
                                            completeBlock(result);
                                        }];
}

@end

@implementation XSYQuickOperationModel

+ (NSDictionary *)mj_objectClassInArray {
//    return @{
//             @"approverList": NSStringFromClass(XSYApprover.class),
//             @"selectableApproverList": NSStringFromClass(XSYApprover.class),
//             @"currentApprovalList": NSStringFromClass(XSYApproval.class),
//             @"allApprovals": NSStringFromClass(XSYApproval.class),
//             };
    return @{};
}

@end
