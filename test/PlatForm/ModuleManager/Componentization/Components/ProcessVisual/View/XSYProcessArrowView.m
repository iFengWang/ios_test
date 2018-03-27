
//
//  XSYProcessArrowView.m
//  ingage
//
//  Created by 朱洪伟 on 2018/3/2.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYProcessArrowView.h"

@interface XSYProcessArrowView ()
@property (nonatomic,assign)NSInteger type;
@end
@implementation XSYProcessArrowView

- (instancetype)init{
    
    self = [super init];
    if (self) {
       [self installView];
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self installView];
    }
    return self;
    
}
- (void)setCurreType:(NSInteger)type{
    self.type = type;
}
- (void)installView{
    self.backgroundColor = [UIColor clearColor];
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
     [super drawRect:rect];
    
    //获取当前图形,视图推入堆栈的图形,相当于你所要绘制图形的图纸
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //
    [[UIColor clearColor] set];
    //创建一个新的空图形路径
    CGContextBeginPath(ctx);
    
    CGFloat sartY = rect.size.height/2;
    CGFloat sartX = rect.origin.x+10;
    
    CGFloat endX = rect.size.width-10;
    
    //起始位置坐标
    CGFloat origin_x = sartX;
    CGFloat origin_y = sartY;
    //第一条线的位置坐标
    CGFloat line_1_x = rect.origin.x;
    CGFloat line_1_y = 0;
    //第二条线的位置坐标
    CGFloat line_2_x = endX;
    CGFloat line_2_y = 0;
    //第三条线的位置坐标
    CGFloat line_3_x = rect.size.width;
    CGFloat line_3_y = sartY;
    //第四条线的位置坐标
    CGFloat line_4_x = endX;
    CGFloat line_4_y = rect.size.height;
    //第五条线的位置坐标
    CGFloat line_5_x = 0;
    CGFloat line_5_y = rect.size.height;
    //第六条线的位置坐标
    CGFloat line_6_x = sartX;
    CGFloat line_6_y = sartY;
    
    CGContextMoveToPoint(ctx, origin_x, origin_y);
    
    CGContextAddLineToPoint(ctx, line_1_x, line_1_y);
    CGContextAddLineToPoint(ctx, line_2_x, line_2_y);
    CGContextAddLineToPoint(ctx, line_3_x, line_3_y);
    CGContextAddLineToPoint(ctx, line_4_x, line_4_y);
    CGContextAddLineToPoint(ctx, line_5_x, line_5_y);
    CGContextAddLineToPoint(ctx, line_6_x, line_6_y);
    
    CGContextClosePath(ctx);
    
    //设置填充颜色
    UIColor *customColor ;
    if (self.type==1) {
        customColor = RGBCOLOR(0, 152, 117);
    }else{
        customColor = RGBCOLOR(39, 215, 173);
    }
    CGContextSetFillColorWithColor(ctx, customColor.CGColor);
    CGContextFillPath(ctx);
}
@end
