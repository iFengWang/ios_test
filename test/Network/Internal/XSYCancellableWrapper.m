//
//  XSYCancellableWrapper.m
//  ingage
//
//  Created by 郭源 on 2018/2/28周三.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYCancellableWrapper.h"

@implementation XSYCancellableWrapper

- (BOOL)isCancelled {
    return self.innerCancellable.isCancelled;
}

- (void)cancel {
    [self.innerCancellable cancel];
}

@end

@interface XSYSimpleCancellable ()

@property (nonatomic, assign) BOOL _privateIsCancelled;

@end

@implementation XSYSimpleCancellable

- (BOOL)isCancelled {
    return self._privateIsCancelled;
}

- (void)cancel {
    self._privateIsCancelled = true;
}

@end
