//
//  XSYCancellableWrapper.h
//  ingage
//
//  Created by 郭源 on 2018/2/28周三.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYNetworkConst.h"
#import <Foundation/Foundation.h>

@interface XSYCancellableWrapper : NSObject <CancellableInterface>

@property (nonatomic, strong) id<CancellableInterface> innerCancellable;

@end

@interface XSYSimpleCancellable : NSObject <CancellableInterface>

@end
