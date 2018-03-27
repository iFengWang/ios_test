//
//  XSYDetailTitleModel.h
//  ingage
//
//  Created by 朱洪伟 on 2018/2/26.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYDetailObjectApiDataModel.h"
#import "XSYEntityDetailBasicComponentController.h"

@interface XSYDetailTitleModel : NSObject

@property (nonatomic, strong) XSYEntityDetailConfigLayout *layout;
@property (nonatomic, strong) XSYDetailObjectApiModel * objectData;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *recordId;
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *titleApiKey;

@property (nonatomic, assign) CGFloat height;
@end
