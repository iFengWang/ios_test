//
//  XSYMeteDataObjects.m
//  ingage
//
//  Created by 朱洪伟 on 2018/3/15.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYMeteDataObjects.h"
#import "NSArray+Functional.h"
#import <YYModel/YYModel.h>

@implementation XSYMeteDataObjects

@end

@implementation XSYMeteDataObjectsFile

+ (void)saveMeteDataObjects:(NSDictionary *)json {
    if (!json) {
        return;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [ingageTool getFilePath:@"metaData"];
    [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *filename = [path stringByAppendingPathComponent:@"metaData.json"];
    BOOL isfm = [fm createFileAtPath:filename contents:nil attributes:nil];
    NSArray *array = [json objectForKey:@"records"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    BOOL isSave = [data writeToFile:filename atomically:YES];
    NSLog(@"%@", isSave ? @"metaData存储成功" : @"metaData存储失败");
}
+ (NSArray *)getAllMeteDataObjects {
    NSString *path = [ingageTool getFilePath:@"metaData"];
    NSString *filename = [path stringByAppendingPathComponent:@"metaData.json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filename];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return array;
}
+ (XSYMeteDataObjects *)getMeteDataObjects:(NSString *)objectId {
    NSArray *allData = [XSYMeteDataObjectsFile getAllMeteDataObjects];
    NSArray *arr = [allData map:^id(NSDictionary *obj, NSUInteger idx) {
        NSString *objID = [obj objectForKey:@"objectId"];
        if ([objID isEqualToString:objectId]) {
            return obj;
        }
        return nil;
    }];
    NSDictionary *metaData = [arr firstObject];
    XSYMeteDataObjects *data = [XSYMeteDataObjects yy_modelWithJSON:metaData];
    return data;
}

@end
