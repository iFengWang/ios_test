//
//  XSYEntityDetailInterface.h
//  ingage
//
//  Created by 郭源 on 2018/2/7周三.
//  Copyright © 2018年 com. All rights reserved.
//

#ifndef XSYEntityDetailInterface_h
#define XSYEntityDetailInterface_h

#import "XSYResult.h"

@protocol XSYRequestable <NSObject>

- (void)request:(void (^)(XSYResult *))completeBlock;

@end

@class XSYListenable<T>;

@protocol XSYEntityDetailComponent <NSObject>

@property (readonly, nonatomic, copy) NSString *viewID;

@property (readonly, nonatomic, strong) XSYListenable<NSNumber *> *viewHeight;

- (void)setModel:(id)model;

@end

@class XSYEntityDetailConfigLayout, XSYDetailObjectApiModel;

@protocol XSYEntityDetailControllerInterface <NSObject>

+ (instancetype)controllerWithObjectApiKey:(NSString *)objectApiKey
                                  recordId:(NSString *)recordId
                                  objectId:(NSString *)objectId
                                    layout:(XSYEntityDetailConfigLayout *)layout
                                  metaData:(XSYDetailObjectApiModel *)metaData;

@property (readonly, nonatomic, strong) UIView<XSYEntityDetailComponent> *view;

@property (readonly, nonatomic, copy) NSString *recordId;

@property (readonly, nonatomic, copy) NSString *objectId;

@property (readonly, nonatomic, copy) NSString *objectApiKey;

@property (readonly, nonatomic, strong) XSYEntityDetailConfigLayout *layout;

@property (readonly, nonatomic, strong) XSYDetailObjectApiModel *metaData;

@optional
- (void)componentWillShow;
- (void)componentWillHide;
- (void)componentRelod;
@end

#endif /* XSYEntityDetailInterface_h */
