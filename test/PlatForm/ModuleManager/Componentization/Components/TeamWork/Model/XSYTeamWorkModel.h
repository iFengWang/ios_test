//
//  XSYTeamWorkModel.h
//  ingage
//
//  Created by AJ-1993 on 2018/3/5.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYEntityDetailInterface.h"
#import "XSYNetwork.h"
#import <Foundation/Foundation.h>

@class XSYTeamWorkView;

@interface XSYTeamWorkMemberModel : NSObject

@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL memberAttr;
@property (nonatomic, assign) BOOL ownerFlag;
@end

@interface XSYTeamWorkModel : NSObject
@property (nonatomic, strong) NSMutableArray *originalMember; //原始数据

@property (nonatomic, strong) NSMutableArray *ownerMember;
@property (nonatomic, strong) NSMutableArray *otherMembers;
@end
