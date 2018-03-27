
//
//  XSYDetailObjectApiDataModel.m
//  ingage
//
//  Created by 朱洪伟 on 2018/3/13.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYDetailObjectApiDataModel.h"

@implementation XSYDetailObjectApiDataModel


@end



@implementation XSYDetailObjectApiModel

-(NSMutableArray*)metaData
{
    if (!_metaData) {
        _metaData = [NSMutableArray new];
    }
    return _metaData;
}
@end
