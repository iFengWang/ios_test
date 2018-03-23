//
//  XSYEndpoint+Internal.m
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import "NSDictionary+Functional.h"
#import "XSYEndpoint+Internal.h"
#import "XSYMultipartProvider.h"
#import "XSYNetworkConst.h"

@implementation XSYEndpoint (Internal)

- (XSYHttpHeaderFields *)addHttpHeaderFields:(XSYHttpHeaderFields *)httpHeaderFields {
    if (!httpHeaderFields) {
        return self.httpHeaderFields;
    }

    NSMutableDictionary *httpFields = [NSMutableDictionary dictionaryWithDictionary:httpHeaderFields];
    if (self.httpHeaderFields) {
        [self.httpHeaderFields forEach:^(id<NSCopying> _Nonnull key, id _Nonnull value) {
            [httpFields setObject:value forKey:key];
        }];
    }
    return httpFields;
}

- (XSYParameters *)addParameters:(XSYParameters *)parameters {
    if (!parameters) {
        return self.parameters;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (self.parameters) {
        [self.parameters forEach:^(id<NSCopying> _Nonnull key, id _Nonnull value) {
            [params setObject:key forKey:value];
        }];
    }
    return params;
}

- (void)appendData:(XSYDataMultipart *)data to:(id<AFMultipartFormData>)form {
    if (data.mimeType && data.fileName) {
        [form appendPartWithFileData:data.data name:data.name fileName:data.fileName mimeType:data.mimeType];
    } else {
        [form appendPartWithFormData:data.data name:data.name];
    }
}

- (void)appendFile:(XSYFileMultipart *)file to:(id<AFMultipartFormData>)form {
    if (file.mimeType && file.fileName) {
        [form appendPartWithFileURL:file.url name:file.name fileName:file.fileName mimeType:file.mimeType error:nil];
    } else {
        [form appendPartWithFileURL:file.url name:file.name error:nil];
    }
}

@end
