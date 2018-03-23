//
//  XSYNetworkActivityPlugin.m
//  ingage
//
//  Created by 郭源 on 2018/2/28周三.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYNetworkActivityPlugin.h"

@interface XSYNetworkActivityPlugin ()

@property (readonly, nonatomic, copy) XSYNetworkActivityBlock networkActivityBlock;

@end

@implementation XSYNetworkActivityPlugin

- (instancetype)initWithNetworkActivityBlock:(XSYNetworkActivityBlock)block {
    if (self = [super init]) {
        _networkActivityBlock = block;
    }
    return self;
}

- (void)willSend:(id<XSYRequestTypeInterface>)requestType target:(id<XSYTargetInterface>)target {
    self.networkActivityBlock(XSYNetworkActivityChangeTypeBegan, target);
}

- (void)didReceive:(XSYResult<XSYResponse *> *)result target:(id<XSYTargetInterface>)target {
    self.networkActivityBlock(XSYNetworkActivityChangeTypeEnded, target);
}

@end
