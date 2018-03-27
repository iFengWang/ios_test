//
//  XSYPageViewController.m
//  ingage
//
//  Created by 郭源 on 2018/3/14周三.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYPageViewController.h"
#import "NSArray+Functional.h"
#import "XSYEntityDetailLayout.h"
#import "XSYNetwork.h"
#import "XSYPageContentViewController.h"
#import "XSYUserDefaults.h"
#import <Masonry/Masonry.h>

#define PAGECONTROLTAG 101

@interface XSYPageSelectView ()

@property (readonly, nonatomic, copy) void (^selectedHandler)(NSUInteger);

@property (readonly, nonatomic, assign) XSYPageSelectType type;

@property (nonatomic, strong) NSArray *buttonList;

@end

@implementation XSYPageSelectView {
    NSInteger _storedIndex;
}

#pragma mark -
#pragma mark -Initialize
- (instancetype)initWithSelectType:(XSYPageSelectType)type titles:(NSArray<NSString *> *)titles {
    return [self initWithSelectType:type titles:titles selectedHandler:nil];
}

- (instancetype)initWithSelectType:(XSYPageSelectType)type
                            titles:(NSArray<NSString *> *)titles
                   selectedHandler:(void (^)(NSUInteger))block {
    if (self = [super init]) {
        _type = type;
        _storedIndex = 0;
        _selectedHandler = block;

        [self initSubviewsWithTitles:titles];
    }
    return self;
}

#pragma mark -
#pragma mark - Public
- (void)changeSelectedIndex:(NSUInteger)selectedIndex {
    switch (self.type) {
        case XSYPageSelectTypeSpot:
            ((UIPageControl *)[self viewWithTag:PAGECONTROLTAG]).currentPage = selectedIndex;
            _storedIndex = selectedIndex;
            break;
        case XSYPageSelectTypeWord: {
            id button = [self viewWithTag:selectedIndex];
            if ([button isKindOfClass:[UIButton class]]) {
                [((UIButton *)[self
                    viewWithTag:selectedIndex]) sendActionsForControlEvents:UIControlEventTouchUpInside];
            } else {
                ((UIPageControl *)[self viewWithTag:PAGECONTROLTAG]).currentPage = selectedIndex;
                _storedIndex = selectedIndex;
                [self settitleButtonColor:0];
            }
            break;
        }
    }
}

#pragma mark -
#pragma mark - Target Action
- (void)titleSelected:(UIButton *)title {
    if (title.tag != _storedIndex) {
        _storedIndex = title.tag;
        [self settitleButtonColor:_storedIndex];
        XSY_SAFE_BLOCK(self.selectedHandler, title.tag);
    }
}
- (void)settitleButtonColor:(NSInteger)index {
    [self.buttonList forEach:^(UIButton *button, NSUInteger idx) {
        if (index == idx) {
            [button setTitleColor:[UIColor.whiteColor colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor.whiteColor colorWithAlphaComponent:0.5] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor.whiteColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        } else {
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
        }
    }];
}
#pragma mark -
#pragma mark - Private
- (void)initSubviewsWithTitles:(NSArray<NSString *> *)titles {
    switch (self.type) {
        case XSYPageSelectTypeSpot: {
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.numberOfPages = titles.count;
            pageControl.currentPage = _storedIndex;
            pageControl.pageIndicatorTintColor = [UIColor.whiteColor colorWithAlphaComponent:0.5];
            pageControl.currentPageIndicatorTintColor = UIColor.whiteColor;
            [self addSubview:pageControl];
            [self configSpotLayout:pageControl];
            pageControl.tag = PAGECONTROLTAG;
            break;
        }
        case XSYPageSelectTypeWord:
            [self configWordLayout:[titles map:^UIButton *(NSString *obj, NSUInteger idx) {
                      UIButton *button = [UIButton new];
                      button.titleLabel.font = [UIFont systemFontOfSize:18];
                      [button setTitle:obj forState:UIControlStateNormal];
                      [button setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
                      [button setTitleColor:[UIColor.whiteColor colorWithAlphaComponent:0.5]
                                   forState:UIControlStateSelected];
                      [button setTitleColor:[UIColor.whiteColor colorWithAlphaComponent:0.5]
                                   forState:UIControlStateHighlighted];
                      [button addTarget:self
                                    action:@selector(titleSelected:)
                          forControlEvents:UIControlEventTouchUpInside];
                      button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                      button.tag = idx;
                      if (idx == _storedIndex) {
                          button.selected = YES;
                      }
                      return button;
                  }]];
            break;
    }
}

- (void)configSpotLayout:(UIPageControl *)pageControl {
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}

- (void)configWordLayout:(NSArray<UIButton *> *)titles {
    self.buttonList = titles;
    [titles forEach:^(UIButton *obj, NSUInteger idx) {
        [self addSubview:obj];
        CGFloat btWidth = (kScreenWidth - 130) / titles.count;
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            if (idx) {
                make.width.equalTo(titles[idx - 1]);
                make.left.equalTo(titles[idx - 1].mas_right).offset(10);
            } else {
                make.left.equalTo(self);
                make.width.mas_offset(btWidth);
            }
        }];
    }];
    [titles.lastObject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
    }];
}

@end

static NSString *const AttributesTitleKey = @"title";
static NSString *const AttributesTitleResourceKey = @"title_resourceKey";
static NSString *const AttributesShowStyleKey = @"showStyle";

@interface XSYPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (readonly, nonatomic, copy) NSString *apiKey;
@property (readonly, nonatomic, copy) NSString *objectId;
@property (readonly, nonatomic, copy) NSString *recordId;
@property (readonly, nonatomic, strong) XSYEntityDetailConfigLayout *layout;

@property (nonatomic, strong) NSArray<XSYPageContentViewController *> *pageContents;

@end

@implementation XSYPageViewController {
    NSUInteger _storedIndex;
}

#pragma mark -
#pragma mark - Initialize
- (instancetype)initWithObjectApiKey:(NSString *)apiKey
                            objectId:(NSString *)objectId
                            recordId:(NSString *)recordId
                              layout:(XSYEntityDetailConfigLayout *)layout {
    if (self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                        navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                      options:nil]) {
        _apiKey = apiKey;
        _objectId = objectId;
        _recordId = recordId;
        _layout = layout;

        __weak typeof(self) weakSelf = self;
        _storedIndex = 0;
        _currentIndex = [XSYListenable listenableWithValue:@(_storedIndex)
                                              setterAction:^(NSNumber *_Nonnull currentIndex) {
                                                  __strong typeof(weakSelf) strongSelf = weakSelf;
                                                  if (strongSelf) {
                                                      [strongSelf scrollToIndex:currentIndex];
                                                  }
                                              }];

        XSYPageSelectType selectType = XSYPageSelectTypeWord;
        if ([layout.attributes[AttributesShowStyleKey] isEqualToString:@"spot"]) {
            selectType = XSYPageSelectTypeSpot;
        }

        _selectView = [[XSYPageSelectView alloc]
            initWithSelectType:selectType
                        titles:[layout.children map:^NSString *(XSYEntityDetailConfigLayout *obj, NSUInteger idx) {
                            NSDictionary *attributes = obj.attributes;
                            NSString *title =
                                XSYLocalized(attributes[AttributesTitleResourceKey], attributes[AttributesTitleKey]);
                            return title;
                        }]
               selectedHandler:^(NSUInteger idx) {
                   __strong typeof(weakSelf) strongSelf = weakSelf;
                   if (strongSelf) {
                       strongSelf.currentIndex.value = @(idx);
                   }
               }];
    }
    return self;
}

#pragma mark -
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = self;
    self.delegate = self;

    self.pageContents =
        [self.layout.children map:^XSYPageContentViewController *(XSYEntityDetailConfigLayout *obj, NSUInteger idx) {
            return [[XSYPageContentViewController alloc] initWithObjectApiKey:self.apiKey
                                                                     objectId:self.objectId
                                                                     recordId:self.recordId
                                                                       layout:obj];
        }];

    [self setViewControllers:@[self.pageContents.firstObject]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
}

#pragma mark -
#pragma mark - Private
- (void)scrollToIndex:(NSNumber *)index {
    NSUInteger newIndex = index.unsignedIntegerValue;
    if (newIndex >= self.pageContents.count) {
        self.currentIndex.value = @(_storedIndex);
        return;
    }

    XSYPageContentViewController *newVC = self.pageContents[newIndex];
    if (newIndex > _storedIndex) {
        [self transationViewController:newVC direction:UIPageViewControllerNavigationDirectionForward];
    } else if (newIndex < _storedIndex) {
        [self transationViewController:newVC direction:UIPageViewControllerNavigationDirectionReverse];
    }
    [self.selectView changeSelectedIndex:newIndex];
    _storedIndex = newIndex;
}

- (void)transationViewController:(XSYPageContentViewController *)viewController
                       direction:(UIPageViewControllerNavigationDirection)direction {
    [self setViewControllers:@[viewController] direction:direction animated:NO completion:nil];
}

#pragma mark -
#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(XSYPageContentViewController *)viewController {
    NSInteger index = [self.pageContents indexOfObject:viewController] + 1;
    return index >= self.pageContents.count ? nil : self.pageContents[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(XSYPageContentViewController *)viewController {
    NSInteger index = [self.pageContents indexOfObject:viewController] - 1;
    return index < 0 ? nil : self.pageContents[index];
}

#pragma mark -
#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController
    willTransitionToViewControllers:(NSArray<XSYPageContentViewController *> *)pendingViewControllers {
    XSYPageContentViewController *toVC = pendingViewControllers.firstObject;

    self.currentIndex.value = @([self.pageContents indexOfObject:toVC]);
}

- (void)pageViewController:(UIPageViewController *)pageViewController
         didFinishAnimating:(BOOL)finished
    previousViewControllers:(NSArray<XSYPageContentViewController *> *)previousViewControllers
        transitionCompleted:(BOOL)completed {
    if (!completed) {
        XSYPageContentViewController *fromVC = previousViewControllers.firstObject;
        self.currentIndex.value = @([self.pageContents indexOfObject:fromVC]);
    }
}

@end
