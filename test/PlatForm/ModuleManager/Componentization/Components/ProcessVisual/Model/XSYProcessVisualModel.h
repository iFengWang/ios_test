//
//  XSYProcessVisualModel.h
//  ingage
//
//  Created by 朱洪伟 on 2018/3/9.
//  Copyright © 2018年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSYNetwork.h"
#import "XSYEntityDetailInterface.h"

@interface XSYProcessVisualTarget : NSObject <XSYTargetInterface, XSYRequestable>

+ (instancetype)targetWithObjectApiKey:(NSString *)apiKey recordId:(NSString *)recordId;

@end


@interface XSYProcessVisualModel : NSObject

@end
