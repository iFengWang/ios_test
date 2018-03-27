//
//  XSYEnterpriseRecommendedView.m
//  ingage
//
//  Created by 朱洪伟 on 2018/3/5.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYEnterpriseRecommendedView.h"
#import "Masonry.h"
#import "XSYEnterpriseRecommendedCell.h"
#import "XSYUserDefaults.h"

static NSString *kEnterpriseRecommendedCellID = @"EnterpriseRecommendedCellID";

@interface XSYEnterpriseRecommendedView () <UICollectionViewDelegate, UICollectionViewDataSource,
                                            XSYEnterpriseRecommendedCellDelegate>
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *textLable;
@property (nonatomic, strong) UIView *textView;
@end

@implementation XSYEnterpriseRecommendedView
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

        _viewHeight = [XSYListenable listenableWithValue:@(200) setterAction:nil];
        [self installView];
    }
    return self;
}
- (void)installView {
    //    self.titleLable.frame = CGRectMake(10, 5, 100, 25);
    [self addSubview:self.titleLable];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(10, 5, 100, 25));
        make.top.equalTo(self.mas_top).with.offset(10);
        ;
        make.left.equalTo(self.mas_left).with.offset(10);
        make.width.mas_equalTo(100);
        make.height.equalTo(@(30));
    }];

    //    self.textView.frame = CGRectMake(self.width-100, 5, 100, 30);
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_top);
        make.right.equalTo(self.mas_right).with.offset(10);
        make.width.mas_equalTo(100);
        make.height.equalTo(@(30));
    }];
    //    self.textLable.frame = CGRectMake(0, 0, 80, 30);
    [self.textView addSubview:self.textLable];
    [self.textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.right.bottom.equalTo(self.textView);
    }];

    //    CGFloat w = 170;
    //    self.collectionView = ({
    //        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    //        layout.itemSize = CGSizeMake(w, w);
    //        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //        layout.minimumLineSpacing = 1;
    //
    //        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero
    //        collectionViewLayout:layout]; collectionView.backgroundColor = [UIColor clearColor];
    //        collectionView.delegate = self;
    //        collectionView.dataSource = self;
    //        collectionView.scrollsToTop = NO;
    //        collectionView.showsVerticalScrollIndicator = NO;
    //        collectionView.showsHorizontalScrollIndicator = NO;
    //        [collectionView registerClass:[XSYEnterpriseRecommendedCell class]
    //        forCellWithReuseIdentifier:kEnterpriseRecommendedCellID]; [self addSubview:collectionView];
    //        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.right.right.equalTo(self);
    //            make.bottom.equalTo(self).with.offset(-10);
    //            make.width.mas_equalTo(kScreenWidth);
    //            make.height.equalTo(@(w));
    //        }];
    //        collectionView;
    //    });
    CGFloat w = 165;
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(w, w);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 1;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[XSYEnterpriseRecommendedCell class]
            forCellWithReuseIdentifier:kEnterpriseRecommendedCellID];
    [self addSubview:self.collectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.right.equalTo(self);
        make.bottom.equalTo(self).with.offset(5);
        make.width.mas_equalTo(kScreenWidth);
        make.height.equalTo(@(w));
    }];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:kEnterpriseRecommendedCellID forIndexPath:indexPath];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}
#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    XSYEnterpriseRecommendedCell *aCell = (XSYEnterpriseRecommendedCell *)cell;
    aCell.delegate = self;
    [aCell setModel:nil];
}

#pragma mark - XSYEnterpriseRecommendedCellDelegate

- (void)enterpriseDeleteAlction { //删除按钮
}
- (void)gotoEnterpriseDetailAlction { //点击企业详情
}
#pragma mark -
- (void)setModel:(id)model {
}
- (NSString *)viewID {
    return @"";
}

#pragma mark -install

- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [ViewCreatorHelper createLabelWithTitle:@"企业推荐"
                                                         font:[UIFont boldSystemFontOfSize:18.0f]
                                                        frame:CGRectZero
                                                    textColor:RGBCOLOR(51, 51, 51)
                                                textAlignment:NSTextAlignmentLeft];
    }
    return _titleLable;
}
- (UILabel *)textLable {
    if (!_textLable) {
        _textLable = [ViewCreatorHelper createLabelWithTitle:@"查看全部"
                                                        font:[UIFont boldSystemFontOfSize:15.0f]
                                                       frame:CGRectZero
                                                   textColor:RGBCOLOR(63, 153, 230)
                                               textAlignment:NSTextAlignmentRight];
    }
    return _textLable;
}
- (UIView *)textView {
    if (!_textView) {
        _textView = [UIView new];
        UITapGestureRecognizer *tapGesturRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAllAction:)];
        [_textView addGestureRecognizer:tapGesturRecognizer];
    }
    return _textView;
}
- (void)selectAllAction:(id)obj {
    if (self.actionAllNext) {
        self.actionAllNext();
    }
}
- (void)actionAllBlock:(void (^)())completion {
    self.actionAllNext = completion;
}
@end
