//
//  XSYEntityDetailBasicComponentController.m
//  ingage
//
//  Created by 郭源 on 2018/2/7周三.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYEntityDetailBasicComponentController.h"
#import "XSYEntityDetailLayout.h"

@implementation XSYEntityDetailBasicComponentController
@synthesize recordId = _recordId;
@synthesize objectId = _objectId;
@synthesize objectApiKey = _objectApiKey;
@synthesize layout = _layout;
@synthesize metaData = _metaData;

+ (instancetype)controllerWithObjectApiKey:(NSString *)objectApiKey
                                  recordId:(NSString *)recordId
                                  objectId:(NSString *)objectId
                                    layout:(XSYEntityDetailConfigLayout *)layout
                                  metaData:(XSYDetailObjectApiModel *)metaData {
    return [[self alloc] initWithObjectApiKey:objectApiKey
                                     recordId:recordId
                                     objectId:objectId
                                       layout:layout
                                     metaData:metaData];
}

- (instancetype)initWithObjectApiKey:(NSString *)objectApiKey
                            recordId:(NSString *)recordId
                            objectId:(NSString *)objectId
                              layout:(XSYEntityDetailConfigLayout *)layout
                            metaData:(XSYDetailObjectApiModel *)metaData {
    if (self = [super init]) {
        _recordId = recordId;
        _objectId = objectId;
        _objectApiKey = objectApiKey;
        _layout = layout;
        _metaData = metaData;
    }
    return self;
}

- (UIView<XSYEntityDetailComponent> *)view {
    return nil;
}

@end
