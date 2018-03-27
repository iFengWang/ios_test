//
//  XSYApprovalFlowView.h
//  ingage
//
//  Created by AJ-1993 on 2018/2/5.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYEntityDetailInterface.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, Type) {
    APPROVAL_FLOW_Agree = 0,   //同意
    APPROVAL_FLOW_Refuse = 1,  //拒绝
    APPROVAL_FLOW_NORMAL = 2,  //撤回（多人会签）
    APPROVAL_FLOW_SUBMIT = 3,  //点击标题
    APPROVAL_FLOW_ADDSIGN = 4, //找人同审
};
typedef void (^TapAction)(Type type, NSDictionary *dict);

@class XSYApprovalFlowModel;

@interface XSYApprovalFlowView : UIView <XSYEntityDetailComponent>

@property (nonatomic, copy) TapAction tapAction;

@end
