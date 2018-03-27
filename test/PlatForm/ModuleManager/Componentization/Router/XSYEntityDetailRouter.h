//
//  XSYEntityDetailRouter.h
//  ingage
//
//  Created by 郭源 on 2018/3/9周五.
//  Copyright © 2018年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSYUserDefaults.h"
#import "XSYDetailObjectApiDataModel.h"

typedef NS_ENUM(NSUInteger, XSYRouteType) {
    XSYRouteTypePush    = 0,
    XSYRouteTypePresent = 1,
};

typedef NS_ENUM(NSUInteger, XSYRouterCompletedType) {
    XSYRouterCompletedTypeNone      = 0,
    XSYRouterCompletedTypeDetail    = 1,
};

@protocol XSYEntityDetailRouterListener <NSObject>

- (void)listening:(XSYRouterCompletedType)type;

@end

@interface XSYEntityDetailRouter : NSObject

- (instancetype)initWithNavigationController:(UINavigationController *)controller;

/**
 Change completed type after pop to entity detail view controller.
 */
@property (readonly, nonatomic, strong) XSYListenable<NSNumber *> *routerCompletedType;

@property (readonly, nonatomic, nullable, strong) UIViewController *topViewController;

- (void)perform:(Class)targetClass configuration:(XSYRouteType (^)(id))configurationBlock;

@end

@interface XSYEntityDetailRouter (DetailPerform)

- (void)performWithDataModel:(XSYDetailObjectApiDataModel *)dataModel;

@end
