//
//  XSYQuickOperationModel.h
//  ingage
//
//  Created by AJ-1993 on 2018/2/27.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYEntityDetailBasicComponentController.h"
#import "XSYNetwork.h"
#import <Foundation/Foundation.h>

@class XSYApprovalFlowView;

@interface XSYQuickOperationTarget : NSObject <XSYTargetInterface, XSYRequestable>

+ (instancetype)targetWithObjectApiKey:(NSString *)apiKey recordId:(NSString *)recordId;

@end


@interface XSYQuickOperationModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;

@end
