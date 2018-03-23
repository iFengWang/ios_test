//
//  XSYRequestTask+Internal.m
//  ingage
//
//  Created by 郭源 on 2018/2/5周一.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYRequestTask+Internal.h"

@implementation XSYRequestTask (Internal)

- (AFHTTPRequestSerializer *)xsy_requestSerializer {
    switch (self.requestSerializer) {
        case XSYRequestSerializerRAW:
            return [AFHTTPRequestSerializer serializer];
        case XSYRequestSerializerJSON:
            return [AFJSONRequestSerializer serializer];
        case XSYRequestSerializerPlist:
            return [AFPropertyListRequestSerializer serializer];
    }
}

//- (AFHTTPResponseSerializer *)xsy_responseSerializer {
//    switch (self.responseSerializer) {
//        case XSYResponseSerializerRAW:
//            return [AFHTTPResponseSerializer serializer];
//            break;
//        case XSYResponseSerializerJSON:
//            return [AFJSONResponseSerializer serializer];
//        case XSYResponseSerializerXML:
//            return [AFXMLParserResponseSerializer serializer];
//        case XSYResponseSerializerPlist:
//            return [AFPropertyListResponseSerializer serializer];
//        default:
//            break;
//    }
//}

@end
