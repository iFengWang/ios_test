//
//  XSYDetailObjectApiDataModel.h
//  ingage
//
//  Created by 朱洪伟 on 2018/3/13.
//  Copyright © 2018年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSYDetailObjectApiKey.h"
#import "XSYDetailTitleModel.h"

@interface XSYDetailObjectApiDataModel : XSYDetailObjectApiKey
@property (nonatomic,strong)NSDictionary * data;
@end


@interface XSYDetailObjectApiModel :NSObject
@property (nonatomic,strong)NSDictionary * data;
@property (nonatomic,strong)NSMutableArray * metaData;
@end
