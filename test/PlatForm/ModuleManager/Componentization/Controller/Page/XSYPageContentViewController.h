//
//  XSYPageContentViewController.h
//  ingage
//
//  Created by 郭源 on 2018/3/14周三.
//  Copyright © 2018年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XSYEntityDetailConfigLayout;

@interface XSYPageContentViewController : UIViewController

- (instancetype)initWithObjectApiKey:(NSString *)apiKey
                            objectId:(NSString *)objectId
                            recordId:(NSString *)recordId
                              layout:(XSYEntityDetailConfigLayout *)layout NS_DESIGNATED_INITIALIZER;

@end
