//
//  XSYDetailPhotoShowView.m
//  ingage
//
//  Created by 朱洪伟 on 2018/3/5.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYDetailPhotoShowView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "Masonry.h"
#import "SDCycleScrollView.h"
#import "XSYUserDefaults.h"
@interface XSYDetailPhotoShowView () <SDCycleScrollViewDelegate>
@property (nonatomic, strong) NSArray *imagesURLStrings;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@end
@implementation XSYDetailPhotoShowView
@synthesize viewHeight = _viewHeight;

//-(id)init{
//    self = [super init];
//    if (self) {
//        self.backgroundColor = RGBCOLOR(240, 240, 240);
//        [self installView];
//    }
//    return self;
//}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBCOLOR(240, 240, 240);
        [self installView];
        _viewHeight = [XSYListenable listenableWithValue:@(200) setterAction:nil];
    }
    return self;
}
- (void)installView {
    self.imagesURLStrings = @[
        @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/"
        @"sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
        @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/"
        @"sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
        @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/"
        @"b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
    ];

    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 200)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@"placeholder"]];

    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.cycleScrollView.titlesGroup = nil;
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleTag;
    self.cycleScrollView.delegate = self;
    [self addSubview:self.cycleScrollView];

    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(200);
        make.width.mas_equalTo(kScreenWidth);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.cycleScrollView.imageURLStringsGroup = self.imagesURLStrings;
    });
}

- (void)setModel:(id)model {
}
- (NSString *)viewID {
    return @"";
}
- (void)selectCycleScrollView:(UIImageView *)imagView didSelectItemAtIndex:(NSInteger)index {
    int count = self.imagesURLStrings.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        // 替换为中等尺寸图片
        NSString *url = self.imagesURLStrings[i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = nil;              // 来源于哪个UIImageView
        [photos addObject:photo];
    }

    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
    browser.photos = photos;           // 设置所有的图片
    [browser show];
}
@end
