//
//  ZTYRequestTask.h
//  test
//
//  Created by 王广峰 on 2018/3/23.
//  Copyright © 2018年 frank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTYRequestTask : NSObject
@property (readonly, nonatomic, assign) ZTYTaskType type;
@property (readonly, nonatomic, assign) ZTYRequestSerializerType requestSerializer;
+ (instancetype)taskWithRequestSerializerType:(ZTYRequestSerializerType)requestSerializer;
@end

@interface ZTYUploadTask : ZTYRequestTask
@end

@interface ZTYDownloadTask : ZTYRequestTask
@end
