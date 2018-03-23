//
//  XSYEndpoint+Internal.h
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYEndpoint.h"

@class XSYMultipartProvider, XSYDataMultipart, XSYFileMultipart;

NS_ASSUME_NONNULL_BEGIN

@interface XSYEndpoint (Internal)

- (XSYHttpHeaderFields *)addHttpHeaderFields:(nullable XSYHttpHeaderFields *)httpHeaderFields;

- (XSYParameters *)addParameters:(nullable XSYParameters *)parameters;

- (void)appendData:(XSYDataMultipart *)data to:(id<AFMultipartFormData>)form;

- (void)appendFile:(XSYFileMultipart *)file to:(id<AFMultipartFormData>)form;

@end

NS_ASSUME_NONNULL_END
