//
//  XSYNetworkLoggerPlugin.m
//  ingage
//
//  Created by 郭源 on 2018/2/28周三.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYNetworkLoggerPlugin.h"
#import "XSYResponse.h"
#import "XSYResult.h"

static NSString *const loggerId = @"XSY_Logger";
static NSString *const dateFormatString = @"yyyy/dd/MM HH:mm:ss";

@interface XSYNetworkLoggerPlugin ()

@property (readonly, nonatomic, copy) NSString *date;

@property (readonly, nonatomic, strong) NSDateFormatter *dateFormatter;

@property (readonly, nonatomic, getter=isVerbose, assign) BOOL verbose;

@property (readonly, nonatomic, copy) void (^output)(NSArray<NSString *> *);

@end

@implementation XSYNetworkLoggerPlugin

- (instancetype)initWithVerbose:(BOOL)verbose
                         output:(void (^)(NSArray<NSString *> *_Nonnull))output
           requestDataFormatter:(XSYRequestDataFormatterBlock)requestDataFormatter
          responseDataFormatter:(XSYResponseDataFormatterBlock)responseDataFormatter {
    if (self = [super init]) {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateFormat = dateFormatString;
        _dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        _verbose = verbose;
        _output = output ?: ^(NSArray<NSString *> *items) {
            NSString *logString = [items componentsJoinedByString:@"\n"];
            NSLog(logString);
        };
        _requestDataFormatter = requestDataFormatter;
        _responseDataFormatter = responseDataFormatter;
    }
}

- (void)willSend:(id<XSYRequestTypeInterface>)requestType target:(id<XSYTargetInterface>)target {
    self.output([self logNetworkRequest:requestType.request]);
}

- (void)didReceive:(XSYResult<XSYResponse *> *)result target:(id<XSYTargetInterface>)target {
    if (result.value) {
        self.output([self logNetworkResponse:result.value.response data:result.value.responseObject target:target]);
    } else {
        self.output([self logNetworkResponse:nil data:nil target:target]);
    }
}

- (NSString *)date {
    return [self.dateFormatter stringFromDate:[NSDate date]];
}

- (NSString *)format:(NSString *)loggerId
                date:(NSString *)date
          identifier:(NSString *)identifier
             message:(NSString *)message {
    return [NSString stringWithFormat:@"%@: [%@] %@: %@", loggerId, date, identifier, message];
}

- (NSArray<NSString *> *)logNetworkRequest:(NSURLRequest *)request {
    NSMutableArray<NSString *> *output = [NSMutableArray array];

    [output addObject:[self format:loggerId
                                date:self.date
                          identifier:@"Request"
                             message:request.description ?: @"(invalid request)"]];

    if (request.allHTTPHeaderFields) {
        [output addObject:[self format:loggerId
                                    date:self.date
                              identifier:@"Request Headers"
                                 message:request.allHTTPHeaderFields.description]];
    }

    if (request.HTTPBodyStream) {
        [output addObject:[self format:loggerId
                                    date:self.date
                              identifier:@"Request Body Stream"
                                 message:request.HTTPBodyStream.description]];
    }

    if (request.HTTPMethod) {
        [output addObject:[self format:loggerId
                                    date:self.date
                              identifier:@"Request Http Method"
                                 message:request.HTTPMethod]];
    }

    if (request.HTTPBody && self.isVerbose) {
        NSString *body = self.requestDataFormatter
                             ? self.requestDataFormatter(request.HTTPBody)
                             : [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        if (body) {
            [output addObject:[self format:loggerId date:self.date identifier:@"Request Body" message:body]];
        }
    }

    return output;
}

- (NSArray<NSString *> *)logNetworkResponse:(nullable NSHTTPURLResponse *)response
                                       data:(nullable id)data
                                     target:(id<XSYTargetInterface>)target {
    if (!response) {
        return @[[self format:loggerId
                         date:self.date
                   identifier:@"Response"
                      message:[NSString stringWithFormat:@"Received empty network response for %@.", target]]];
    }

    NSMutableArray<NSString *> *output = [NSMutableArray array];

    [output addObject:[self format:loggerId date:self.date identifier:@"Response" message:response.description]];

    if (data && self.isVerbose) {
        NSString *stringData =
            self.responseDataFormatter ? self.responseDataFormatter(data) : [NSString stringWithFormat:@"%@", data];
        [output addObject:stringData];
    }

    return output;
}

@end
