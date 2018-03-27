//
//  XSYEnterpriseRecommendedModel.m
//  ingage
//
//  Created by 朱洪伟 on 2018/3/9.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYEnterpriseRecommendedModel.h"

@implementation XSYEnterpriseRecommendedModel

@end

@implementation XSYEnterpriseRecommendedTarget {
    NSString *_apiKey;
    NSString *_recordId;
}

+ (instancetype)targetWithObjectApiKey:(NSString *)apiKey recordId:(NSString *)recordId {
    return [[XSYEnterpriseRecommendedTarget alloc] initWithObjectApiKey:apiKey recordId:recordId];
}

- (instancetype)initWithObjectApiKey:(NSString *)apiKey recordId:(NSString *)recordId {
    if (self = [super init]) {
        _apiKey = apiKey;
        _recordId = recordId;
    }
    return self;
}

- (NSURL *)baseURL {
    return [NSURL URLWithString:@"http://d.xiaoshouyi.com:19137/"];
}

- (NSString *)path {
    return [NSString
            stringWithFormat:@"/api/data/v2.0/flows/xobjects/%@/%@/availableApprovalInstances", _apiKey, _recordId];
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
                                           return [XSYEnterpriseRecommendedModel mj_objectWithKeyValues:json[@"data"]];
                                       }
                                        completion:^(XSYResult<XSYEnterpriseRecommendedModel *> *result) {
                                            completeBlock(result);
                                        }];
}

@end
