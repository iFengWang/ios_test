//
//  XSYPageContentViewController.m
//  ingage
//
//  Created by 郭源 on 2018/3/14周三.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYPageContentViewController.h"
#import "XSYEntityDetailLayout.h"
#import "NSArray+Functional.h"
#import <Masonry/Masonry.h>
#import "XSYDetailObjectApiKey.h"
#import "RequestModelApi.h"
#import "XSYDetailObjectApiDataModel.h"
#import "XSYUserDefaults.h"

@interface XSYPageContentViewController ()

@property (readonly, nonatomic, copy) NSString *apiKey;
@property (readonly, nonatomic, copy) NSString *objectId;
@property (readonly, nonatomic, copy) NSString *recordId;
@property (readonly, nonatomic, strong) XSYEntityDetailConfigLayout *layout;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) XSYDetailObjectApiModel *objectUIData;       // 页面需要的元数据
@property (nonatomic, strong) XSYDetailObjectApiKey *objectData;           //页面元数据


@end

@implementation XSYPageContentViewController

#pragma mark -
#pragma mark - Initialize
- (instancetype)initWithObjectApiKey:(NSString *)apiKey
                            objectId:(NSString *)objectId
                            recordId:(NSString *)recordId
                              layout:(XSYEntityDetailConfigLayout *)layout {
    if (self = [super init]) {
        _apiKey = apiKey;
        _objectId = objectId;
        _recordId = recordId;
        _layout = layout;
    }
    return self;
}

#pragma mark -
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [self.scrollView addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.scrollView);
    }];
    
    [self requestModeObjectApiDataModel];
}

- (void)requestModeObjectApiDataModel {
    /*
     获取详情页元数据接口
     */
    NSString *url1 = [NSString stringWithFormat:@"%@%@%@", @"/metadata/v2.0/xobjects/", self.apiKey, @"/items"];
    [RequestModelApi get:url1
                   param:nil
                    type:FromNetWork
                 success:^(id<Element> e) {
                     NSDictionary *json = [e toDict];
                     NSArray *records = [[json objectForKey:@"data"] objectForKey:@"records"];
                     self.objectUIData = [XSYDetailObjectApiModel new];
                     [records forEach:^(NSDictionary *obj, NSUInteger idx) {
                         XSYDetailObjectApiKey *objectData = [XSYDetailObjectApiKey mj_objectWithKeyValues:obj];
                         [self.objectUIData.metaData addObject:objectData];
                     }];
                     
                     [self createLayout];
                 }
                    fail:^(NSError *operation) {
                        NSLog(@"%@", operation);
                    }];
}

- (void)createLayout{
    NSArray<id<XSYEntityDetailControllerInterface>> *components =
    [self.layout.children map:^id(XSYEntityDetailConfigLayout *layout, NSUInteger idx) {
        return [layout.widgetClass controllerWithObjectApiKey:self.apiKey
                                                  recordId:self.recordId
                                                  objectId:self.objectId
                                                    layout:layout
                                                  metaData:self.objectUIData];
    }];
    
    __block id<XSYEntityDetailControllerInterface> storedComponent = nil;
    [components forEach:^(id<XSYEntityDetailControllerInterface> component, NSUInteger idx) {
        [self.backgroundView addSubview:component.view];
        [component componentWillShow];
        [component.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(storedComponent.view ?: @(kScreenWidth));
            make.left.right.equalTo(storedComponent.view ?: self.backgroundView);
            make.top.equalTo(storedComponent.view ? storedComponent.view.mas_bottom : self.backgroundView);
            make.height.equalTo(component.view.viewHeight.value);
        }];
        [component.view.viewHeight bindListenerWithName:component.view.viewID
                                                 action:^(NSNumber *_Nonnull newHeight) {
                                                     [component.view mas_updateConstraints:^(MASConstraintMaker *make) {
                                                         make.height.equalTo(newHeight);
                                                     }];
                                                 }];
        storedComponent = component;
    }];
    [components.lastObject.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backgroundView);
    }];
}

#pragma mark -
#pragma mark - Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = UIColor.whiteColor;
    }
    return _backgroundView;
}

@end
