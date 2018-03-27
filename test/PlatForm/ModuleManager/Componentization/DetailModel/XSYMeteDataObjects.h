//
//  XSYMeteDataObjects.h
//  ingage
//
//  Created by 朱洪伟 on 2018/3/15.
//  Copyright © 2018年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSYMeteDataObjects : NSObject
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) BOOL queryable;
@property (nonatomic, assign) BOOL custom;
@property (nonatomic, assign) BOOL detail;
@property (nonatomic, assign) BOOL updateable;
@property (nonatomic, assign) BOOL deletable;
@property (nonatomic, assign) BOOL createable;
@property (nonatomic, copy) NSString *labelKey;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, strong) NSNumber *objectId;
@property (nonatomic, strong) NSNumber *iconId;
@end

@interface XSYMeteDataObjectsFile : NSObject
+ (void)saveMeteDataObjects:(NSDictionary *)json;
+ (NSArray *)getAllMeteDataObjects;
+ (XSYMeteDataObjects *)getMeteDataObjects:(NSString *)objectId;
@end
