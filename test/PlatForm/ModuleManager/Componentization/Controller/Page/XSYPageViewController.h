//
//  XSYPageViewController.h
//  ingage
//
//  Created by 郭源 on 2018/3/14周三.
//  Copyright © 2018年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XSYPageSelectType) {
    XSYPageSelectTypeWord = 0,
    XSYPageSelectTypeSpot = 1,
};

@interface XSYPageSelectView : UIView

- (instancetype)initWithSelectType:(XSYPageSelectType)type
                            titles:(NSArray<NSString *> *)titles
                   selectedHandler:(nullable void (^)(NSUInteger idx))block NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithSelectType:(XSYPageSelectType)type titles:(NSArray<NSString *> *)titles;

- (void)changeSelectedIndex:(NSUInteger)selectedIndex;

@end

@class XSYListenable<T>, XSYEntityDetailConfigLayout;

@interface XSYPageViewController : UIPageViewController

- (instancetype)initWithObjectApiKey:(NSString *)apiKey
                            objectId:(NSString *)objectId
                            recordId:(NSString *)recordId
                              layout:(XSYEntityDetailConfigLayout *)layout NS_DESIGNATED_INITIALIZER;

@property (readonly, nonatomic, strong) XSYListenable<NSNumber *> *currentIndex;

@property (readonly, nonatomic, strong) XSYPageSelectView *selectView;

@end

NS_ASSUME_NONNULL_END
