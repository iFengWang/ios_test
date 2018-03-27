//
//  XSYEntityDetailLayout.h
//  ingage
//
//  Created by 郭源 on 2018/3/13周二.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYEntityDetailInterface.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XSYEntityDetailConfigLayout;

@interface XSYEntityDetailLayout : NSObject

@property (nonatomic, copy) NSString *layoutID;

@property (nonatomic, strong) XSYEntityDetailConfigLayout *layoutConfig;

@property (nonatomic, assign) BOOL customFlg;

@property (nonatomic, copy) NSString *apiKey;

@property (nonatomic, assign) NSInteger layoutType;

@end

@protocol XSYEntityDetailControllerInterface;

@interface XSYEntityDetailConfigLayout : NSObject

+ (instancetype)layoutWithJSON:(NSDictionary<NSString *, id> *)json;

@property (readonly, nonatomic, strong) Class<XSYEntityDetailControllerInterface> widgetClass;

@property (readonly, nonatomic, copy) NSString *widgetType;

@property (nullable, readonly, nonatomic, copy) NSString *title;

@property (readonly, nonatomic, strong) NSDictionary<NSString *, id> * attributes;

@property (nullable, readonly, nonatomic, strong) NSArray<XSYEntityDetailConfigLayout *> *children;

@end

NS_ASSUME_NONNULL_END
