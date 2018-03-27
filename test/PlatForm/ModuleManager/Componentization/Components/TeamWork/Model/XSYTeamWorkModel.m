//
//  XSYTeamWorkModel.m
//  ingage
//
//  Created by AJ-1993 on 2018/3/5.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYTeamWorkModel.h"
#import <MJExtension/MJProperty.h>

@class XSYApprovalFlowView;
@implementation XSYTeamWorkMemberModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"memberId": @"id"};
}
@end

@implementation XSYTeamWorkModel

- (NSMutableArray *)originalMember {
    if (!_originalMember) {
        _originalMember = [NSMutableArray array];
    }
    return _originalMember;
}
@end
