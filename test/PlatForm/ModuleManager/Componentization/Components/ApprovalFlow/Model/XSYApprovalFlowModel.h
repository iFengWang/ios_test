//
//  XSYApprovalFlowModel.h
//  ingage
//
//  Created by 郭源 on 2018/2/7周三.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYEntityDetailInterface.h"
#import "XSYNetwork.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XSYApprovalFlowView;

@interface XSYApprovalFlowTarget : NSObject <XSYTargetInterface, XSYRequestable>

+ (instancetype)targetWithObjectApiKey:(NSString *)apiKey recordId:(NSString *)recordId;

@end

/**
 审批状态

 - XSYApprovalStatusUnsubmit: 未提交
 - XSYApprovalStatusPending: 待审批
 - XSYApprovalStatusReject: 驳回
 - XSYApprovalStatusPass: 审批通过
 - XSYApprovalStatusRevoke: 撤销
 */
typedef NS_ENUM(NSUInteger, XSYApprovalStatus) {
    XSYApprovalStatusUnsubmit = 0,
    XSYApprovalStatusPending = 1,
    XSYApprovalStatusReject = 2,
    XSYApprovalStatusPass = 3,
    XSYApprovalStatusRevoke = 4,
};

/**
 会签状态

 - XSYCountersignStatusUnapproval: 未审批
 - XSYCountersignStatusPending: 待审批
 - XSYCountersignStatusReject: 拒绝
 - XSYCountersignStatusPass: 同意
 - XSYCountersignStatusSubmit: 提交
 - XSYCountersignStatusRevoke: 撤回
 - XSYCountersignStatusBack: 退回上级节点
 */
typedef NS_ENUM(NSUInteger, XSYCountersignStatus) {
    XSYCountersignStatusUnapproval = -2,
    XSYCountersignStatusPending = -1,
    XSYCountersignStatusReject = 0,
    XSYCountersignStatusPass = 1,
    XSYCountersignStatusSubmit = 3,
    XSYCountersignStatusRevoke = 5,
    XSYCountersignStatusBack = 7,
};

@class XSYApprover, XSYApproval;

@interface XSYApprovalFlowModel : NSObject

@property (nonatomic, assign) BOOL allowSelectApprover;                                 ///< 是否允许选择审批人
@property (nonatomic, assign) XSYApprovalStatus approvalStatus;                         ///< 审批状态
@property (nonatomic, assign) NSUInteger approvalTime;                                  ///< 审批时间
@property (nonatomic, nullable, strong) NSArray<XSYApprover *> *approverList;           ///< 审批人列表
@property (nonatomic, assign) NSInteger approversLength;                                ///< 审批人数量
@property (nonatomic, nullable, strong) NSArray<XSYApprover *> *selectableApproverList; ///< 可选审批人列表
@property (nonatomic, assign) BOOL cancelApprovalable;                                  ///< 是否可撤回审批
@property (nonatomic, copy) NSString *countersignApprover;                              ///< 会签审批人名字
@property (nonatomic, assign) NSInteger countersignStatus;                              ///< 会签状态
@property (nonatomic, assign) BOOL addSignable;                                         ///< 是否可以加签
@property (nonatomic, assign) BOOL submitApprovalable;                                  ///< 是否可以提交审批
@property (nonatomic, assign) NSUInteger currentApproverId;                             ///< 当前审批人ID
@property (nonatomic, strong) NSArray<XSYApproval *> *currentApprovalList;              ///< 当前审批列表
@property (nonatomic, nullable, strong) XSYApprover *defaultApprover;                   ///< 默认审批人
@property (nonatomic, copy) NSString *flowInstanceName;                                 ///< 流程实例名称
@property (nonatomic, copy) NSString *flowInstanceNameKey;                     ///< 流程实例名称多语言资源key
@property (nonatomic, assign) BOOL hasApprovers;                               ///< 是否有审批人
@property (nonatomic, assign) BOOL nextCounterSign;                            ///< 下一节点是否是会签
@property (nonatomic, assign) BOOL currentCounterSign;                         ///< 当前节点是否是会签
@property (nonatomic, copy) NSString *approvalComment;                         ///< 审批意见
@property (nonatomic, assign) BOOL approvalStatusShowable;                     ///< 是否显示审批状态
@property (nonatomic, copy) NSString *submitBtnName;                           ///< 提交按钮名称
@property (nonatomic, copy) NSString *submitBtnNameKey;                        ///< 提交按钮名称资源key
@property (nonatomic, copy) NSString *taskId;                                  ///< 任务ID
@property (nonatomic, nullable, strong) NSArray<NSString *> *historyInstances; ///< 历史实例id列表
@property (nonatomic, assign) BOOL endFlg;                                     ///< 流程是否结束
@property (nonatomic, nullable, copy) NSString *nextApprovalStage;             ///< 下一审批节点名称
@property (nonatomic, nullable, copy) NSString *nextApprovalStageKey; ///< 下一审批节点名称多语言资源key
@property (nonatomic, nullable, copy) NSString *nextApproverLabel;    ///< 下一审批标签
@property (nonatomic, nullable, copy) NSString *nextApproverLabelKey; ///< 下一审批标签多语言资源key
@property (nonatomic, nullable, strong) NSArray<XSYApproval *> *allApprovals; ///< 审批历史

@end

@interface XSYApprovalFlowModel (View)

@property (readonly, nonatomic, strong) UIColor *color;
@property (readonly, nonatomic, copy) NSString *stateString;
@property (readonly, nonatomic, assign) BOOL showStateBtn;
@property (readonly, nonatomic, copy) NSString *titleLabStr;

@end

/**
 用户类型

 - XSYApproverTypeVirtual: 虚拟用户
 - XSYApproverTypeInternal: 内部
 - XSYApproverTypeExternal: 外部
 */
typedef NS_ENUM(NSUInteger, XSYApproverType) {
    XSYApproverTypeVirtual = -1,
    XSYApproverTypeInternal = 0,
    XSYApproverTypeExternal = 1,
};

@interface XSYApprover : NSObject

@property (nonatomic, nullable, copy) NSString *icon; ///< 用户图片 url
@property (nonatomic, assign) NSUInteger uid;         ///< 用户id
@property (nonatomic, copy) NSString *name;           ///< 用户名
@property (nonatomic, assign) XSYApproverType type;   ///< 用户类型

@end

/**
 审批结果

 - XSYApprovalResultPending: 待审批
 - XSYApprovalResultReject: 拒绝
 - XSYApprovalResultPass: 同意
 - XSYApprovalResultSubmit: 提交
 - XSYApprovalResultRevoke: 撤回
 - XSYApprovalResultBack: 退回上级节点
 */
typedef NS_ENUM(NSInteger, XSYApprovalResult) {
    XSYApprovalResultPending = -1,
    XSYApprovalResultReject = 0,
    XSYApprovalResultPass = 1,
    XSYApprovalResultSubmit = 3,
    XSYApprovalResultRevoke = 5,
    XSYApprovalResultBack = 7,
};

/**
 操作类型

 - XSYApprovalOperationSubmit: 提交
 - XSYApprovalOperationUpdate: 更新
 - XSYApprovalOperationResubmit: 重新提交
 - XSYApprovalOperationReject: 拒绝
 - XSYApprovalOperationRevoke: 撤回
 - XSYApprovalOperationPass: 同意
 - XSYApprovalOperationComplete: 完成
 - XSYApprovalOperationBack: 退回上级节点
 */
typedef NS_ENUM(NSUInteger, XSYApprovalOperation) {
    XSYApprovalOperationSubmit = 1,
    XSYApprovalOperationUpdate = 2,
    XSYApprovalOperationResubmit = 3,
    XSYApprovalOperationReject = 4,
    XSYApprovalOperationRevoke = 5,
    XSYApprovalOperationPass = 6,
    XSYApprovalOperationComplete = 7,
    XSYApprovalOperationBack = 8,
};

@interface XSYApproval : NSObject

@property (nonatomic, assign) NSUInteger approverId;            ///< 审批人id
@property (nonatomic, copy) NSString *approvalComment;          ///< 审批意见
@property (nonatomic, assign) XSYApprovalResult approvalResult; ///< 审批结果
@property (nonatomic, assign) NSUInteger approvalTime;          ///< 审批时间
@property (nonatomic, copy) NSString *taskid;                   ///< 任务id
@property (nonatomic, copy) NSString *activityName;             ///< 节点名称
@property (nonatomic, copy) NSString *activityNameKey;          ///< 节点名称多语言资源key
@property (nonatomic, assign) XSYApprovalOperation operateType; ///< 操作类型
@property (nonatomic, copy) NSString *flowInstanceId;           ///< 流程实例id

@end

NS_ASSUME_NONNULL_END
