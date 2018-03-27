//
//  XSYDetailPermissionsModel.h
//  ingage
//
//  Created by 朱洪伟 on 2018/3/14.
//  Copyright © 2018年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSYDetailPermissionsModel : NSObject
@property (nonatomic, copy) NSString * apiKey;
@property (nonatomic, copy) NSString * useDescription;
@property (nonatomic, copy) NSString * label;
@property (nonatomic, copy) NSString * label_resourceKey;
@property (nonatomic, copy) NSString * layoutTypeSub;
@property (nonatomic, assign) BOOL  customFlg;
@property (nonatomic, strong) NSNumber *  layoutId;
@property (nonatomic, strong) NSNumber *  layoutType;
@property (nonatomic, strong) NSNumber *  order;

@end
