//
//  XSYCancellable.m
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYCancellable.h"

#define XSYLock() dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER)
#define XSYUnLock() dispatch_semaphore_signal(self->_lock)

@interface XSYCancellable ()

@property (nonatomic, assign) BOOL _privateIsCancelled;

@property (nullable, readonly, nonatomic, strong) NSURLSessionTask *_task;

@end

@implementation XSYCancellable {
    dispatch_semaphore_t _lock;
}

+ (instancetype)cancellableWithTask:(NSURLSessionTask *)task {
    return [[self alloc] initWithTask:task];
}

- (instancetype)initWithTask:(NSURLSessionTask *)task {
    if (self = [super init]) {
        __task = task;
    }
    return self;
}

- (BOOL)isCancelled {
    return self._privateIsCancelled;
}

- (void)cancel {
    XSYLock();
    [self._task cancel];
    self._privateIsCancelled = YES;
    XSYUnLock();
}

@end
