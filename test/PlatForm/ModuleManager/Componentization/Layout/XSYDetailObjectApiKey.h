//
//  XSYDetailObjectApiKey.h
//  ingage
//
//  Created by 朱洪伟 on 2018/3/13.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYEntityDetailInterface.h"
#import "XSYNetwork.h"
#import <Foundation/Foundation.h>

@interface XSYDetailObjectApiKey : NSObject
@property (nonatomic, assign) BOOL rebuildAutoNumber;
@property (nonatomic, assign) BOOL detail;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) BOOL sortable;
@property (nonatomic, assign) BOOL canBatchCreate;
@property (nonatomic, assign) BOOL currency;
@property (nonatomic, assign) BOOL createable;
@property (nonatomic, assign) BOOL nameField;
@property (nonatomic, assign) BOOL required;
@property (nonatomic, assign) BOOL custom;
@property (nonatomic, assign) BOOL updateable;
@property (nonatomic, assign) BOOL referGlobal;
@property (nonatomic, assign) BOOL multiCurrency;
@property (nonatomic, assign) BOOL filterable;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, copy) NSString *imageUploadMode;
@property (nonatomic, copy) NSString *labelKey;
@property (nonatomic, copy) NSString *referObjectId;
@property (nonatomic, copy) NSString *accessControl;
@property (nonatomic, copy) NSString *joinObject;
@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, copy) NSString *joinLink;
@property (nonatomic, copy) NSString *computeResultDataType;
@property (nonatomic, copy) NSString *maxLength;
@property (nonatomic, copy) NSString *minLength;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *joinItem;
@property (nonatomic, copy) NSString *dataFormat;
@property (nonatomic, copy) NSString *defaultValue;
@property (nonatomic, copy) NSString *helpTextKey;
@property (nonatomic, copy) NSString *referLinkId;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *helpText;
@property (nonatomic, copy) NSString *decimal;
@property (nonatomic, copy) NSString *dateMode;
@property (nonatomic, copy) NSString *currencyPart;
@property (nonatomic, copy) NSString *globalPickItem;
@property (nonatomic, copy) NSString *cascadeDelete;
@property (nonatomic, strong) NSNumber *itemType;
@property (nonatomic, strong) NSNumber *maskable;
@property (nonatomic, strong) NSNumber *itemId;
@property (nonatomic, strong) NSArray *pickOption;

@end
