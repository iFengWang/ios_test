//
//  XSYTeamWorkController.m
//  ingage
//
//  Created by AJ-1993 on 2018/3/5.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYTeamWorkController.h"
#import "HeaderPageTeam.h"
#import "NSArray+Functional.h"
#import "RequestModelApi.h"
#import "TeamMemberCell.h"
#import "UserNewViewController.h"
#import "XSYTeamWorkModel.h"
#import "XSYTeamWorkView.h"
#import "member.h"
#import <YYModel/YYModel.h>

@interface XSYTeamWorkController ()

@end

@implementation XSYTeamWorkController {
    XSYTeamWorkView *_teamWorkView;
}

- (void)componentWillShow {

    NSMutableDictionary *pramDic = [NSMutableDictionary new];
    [pramDic setValue:self.recordId forKey:@"recordId"];
    [pramDic setValue:self.objectApiKey forKey:@"xObjectApiKey"];
    [pramDic setValue:@(1) forKey:@"page"];
    [pramDic setValue:@(20) forKey:@"size"];

    NSString *url = @"/data/v2.0/teamwork/teamMembers/list";
    [RequestModelApi get:url
        param:pramDic
        type:FromNetWork
        success:^(id<Element> e) {
            NSDictionary *dic = [e toDict];
            NSDictionary *data = dic[@"data"] ?: @{};
            NSArray *userList = data[@"records"];
            XSYTeamWorkModel *model = [XSYTeamWorkModel new];

            [userList forEach:^(NSDictionary *userDic, NSUInteger idx) {
                XSYTeamWorkMemberModel *data = [XSYTeamWorkMemberModel yy_modelWithJSON:userDic];
                [model.originalMember addObject:data];
            }];
            NSMutableArray *ownerMemberList = [NSMutableArray array];
            NSMutableArray *otherMemberList = [NSMutableArray array];

            [model.originalMember forEach:^(XSYTeamWorkMemberModel *userdata, NSUInteger idx) {
                BOOL memberAttr = userdata.memberAttr; // 0：组成员 1：组管理员 2：关注加入的组员
                BOOL ownerFlag = userdata.ownerFlag;   // true:负责组员,有权限修改 false：无权限
                NSString *userId = userdata.userId;
                Colleague *coll = [Colleague colleagueById:userId];
                member *userMember = [member new];
                userMember.uid = userId;
                userMember.name = coll.name;
                userMember.icon = coll.icon;
                userMember.memberId = userdata.memberId;
                userMember.hasModifyRight = ownerFlag;
                if (memberAttr) {
                    [ownerMemberList addObject:userMember];
                } else {
                    [otherMemberList addObject:userMember];
                }
            }];
            model.ownerMember = ownerMemberList;
            model.otherMembers = otherMemberList;
            [self.view setModel:model];
            NSLog(@"%@", dic);
        }
        fail:^(NSError *operation) {
            NSLog(@"XSYTeamWorkController 组件数据请求出错");
        }];
}

- (UIView<XSYEntityDetailComponent> *)view {
    if (!_teamWorkView) {
        _teamWorkView = [XSYTeamWorkView new];
    }
    return _teamWorkView;
}

@end
