//
//  XSYEntityDetailController.h
//  ingage
//
//  Created by 郭源 on 2018/2/6周二.
//  Copyright © 2018年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSYEntityDetailController : UIViewController

- (instancetype)initWithObjectApiKey:(NSString *)apiKey
                            objectId:(NSString *)objectId
                            recordId:(NSString *)recordId NS_DESIGNATED_INITIALIZER;

@end
