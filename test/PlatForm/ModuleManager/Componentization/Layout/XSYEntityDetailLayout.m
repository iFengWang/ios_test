//
//  XSYEntityDetailLayout.m
//  ingage
//
//  Created by 郭源 on 2018/3/13周二.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYEntityDetailLayout.h"
#import "NSArray+Functional.h"
#import "XSYNetwork.h"
#import <YYModel/YYModel.h>

@implementation XSYEntityDetailLayout

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"layoutID": @"id"};
}

+ (NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"config"];
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSDictionary *config = dic[@"config"];
    _layoutConfig = [XSYEntityDetailConfigLayout layoutWithJSON:config[@"layoutConfig"]];
    return YES;
}

@end

static NSString *const ChildrenKey = @"children";
static NSString *const WidgetKey = @"widget";

static NSString *const WidgetTypeKey = @"widgetType";
static NSString *const TitleKey = @"title";
static NSString *const AttributesKey = @"attributes";

static NSDictionary *compontsMapDict = nil;

@implementation XSYEntityDetailConfigLayout

+ (void)load {
    compontsMapDict = [NSDictionary dictionaryWithContentsOfURL:[NSBundle.mainBundle URLForResource:@"Components" withExtension:@"plist"]];
}

+ (instancetype)layoutWithJSON:(NSDictionary<NSString *, id> *)json {
    if (json.count == 0) {
        return [[XSYEntityDetailConfigLayout alloc] init];
    }
    return [[XSYEntityDetailConfigLayout alloc] initWithLayoutDictionary:parseLayoutResponseData(json)];
}

- (instancetype)initWithLayoutDictionary:(NSDictionary<NSString *, id> *)layout {
    if (self = [super init]) {
        _widgetType = layout[WidgetKey][WidgetTypeKey] ?: @"Container";
#warning 测试专用
        _widgetClass = NSClassFromString(compontsMapDict[_widgetType] ?: @"XSYDetailEmptyController");
        _title = layout[@"label"];
        NSDictionary *widget = layout[@"widget"] ?: @{};
        ;
        _attributes = widget[AttributesKey] ?: @{};
        NSArray * children = layout[ChildrenKey];
        if ([children isKindOfClass:[NSArray class]]) {
            _children =
            [((NSArray *)children) map:^XSYEntityDetailConfigLayout *(NSDictionary *obj, NSUInteger idx) {
                return [[XSYEntityDetailConfigLayout alloc] initWithLayoutDictionary:obj];
            }];
        }else{
            _children = @[];
        }
    }
    return self;
}

#pragma mark -
#pragma mark - Parse
NSDictionary<NSString *, id> *parseLayoutResponseData(NSDictionary<NSString *, id> *json) {
    NSDictionary *widgets = json[@"widgets"];
    NSDictionary *layout = json[@"layout"];
    NSArray *list = parseArrayChildren(@[layout], widgets);
    return list.count > 0 ? list[0] : @{};
}

NSArray *parseArrayChildren(NSArray *children, NSDictionary *widgets) {
    if (!children || !children.count) {
        return nil;
    }

    return [children map:^NSDictionary *(NSDictionary *obj, NSUInteger idx) {
        NSString *uuid = obj[@"uuid"];
        NSDictionary *widget = widgets[uuid];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:widget forKey:WidgetKey];
        NSArray *parsedChild = nil;
        if ([obj[ChildrenKey] isKindOfClass:NSArray.class]) {
            parsedChild = parseArrayChildren(obj[ChildrenKey], widgets);
        } else {
            parsedChild = parseColumnChildren(obj[ChildrenKey], widgets);
        }
        if (parsedChild) {
            [dict setObject:parsedChild forKey:ChildrenKey];
        }
        return dict;
    }];
}

NSArray *parseColumnChildren(NSDictionary *children, NSDictionary *widgets) {
    if (!children || !children.count) {
        return nil;
    }

    NSArray *sortedKeys = [children.allKeys
        sortedArrayUsingComparator:^NSComparisonResult(NSString *_Nonnull obj1, NSString *_Nonnull obj2) {
            NSRange range = NSMakeRange(0, 3);
            return [obj1 compare:obj2 options:NSAnchoredSearch range:range];
        }];

    return [sortedKeys map:^NSDictionary *(NSString *obj, NSUInteger idx) {
        NSArray *child = children[obj];
        return @{ChildrenKey: parseArrayChildren(child, widgets) ?: [NSNull null]};
    }];
}

@end
