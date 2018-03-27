//
//  XSYQuickOperationView.m
//  ingage
//
//  Created by AJ-1993 on 2018/2/27.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYQuickOperationView.h"
#import "Masonry.h"
#import "UIImage+SVG.h"
#import "XSYQuickOperationModel.h"
#import "XSYQuickOperationCollectionCell.h"
#import "XSYquickOperationFlowLayout.h"

#define kbackGrandColor [UIColor hexChangeFloat:@"607080"]

@interface XSYQuickOperationView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIButton *moreButton;        //更多按钮
@property (nonatomic, strong) UIImageView *moreImageView;  //更多按钮图片
@property (nonatomic, strong) UIView *backgrandView;       //黑色遮罩
@property (nonatomic, strong) UICollectionView *moreView;  //更多滑动collectionView

@property (nonatomic, strong) NSMutableArray *dataArr;     //数据源
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, assign) BOOL isShowMoreView;         //是否点击更多按钮
@end

@implementation XSYQuickOperationView {
    XSYQuickOperationModel *_model;
}
@synthesize isShowMoreView;
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    for (int i = 0; i < self.dataArr.count; i++) {
        float itemWidth = _dataArr.count > 4 ? 5. : _dataArr.count;
        UIButton *quickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        XSYQuickOperationModel *model =_dataArr[i];
        quickButton.frame = CGRectMake(i * kScreenWidth / itemWidth, 0, kScreenWidth / itemWidth, 50);
        [quickButton setTitle:model.name forState:UIControlStateNormal];
        [quickButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        
        UIImageView *iconImage = [[UIImageView alloc] init];
        [iconImage setImage:[UIImage svgImageNamed:@"quick_operation_more.svg" tintColor:kGrayColor]];
        iconImage.frame = CGRectMake((kScreenWidth / itemWidth - 22) / 2., 5, 22, 22);
        [quickButton addSubview:iconImage];
        
        quickButton.titleLabel.font = [UIFont systemFontOfSize:11.];
        quickButton.titleLabel.numberOfLines = 2.;
        quickButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -20, 0);
        quickButton.tag = i;
        [quickButton addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:quickButton];
        
        if (i > 2) {
            break;
        }
    }
    if (self.dataArr.count > 4) {
        [self addSubview:self.moreButton];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self).offset(0);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth / 5., 50));
        }];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataArr.count / 8 + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XSYQuickOperationCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XSYQuickOperationCollectionCell" forIndexPath:indexPath];
    cell.model = _dataArr[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",indexPath);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    self.pageControl.currentPage = currentPage;
}

#pragma mark -
#pragma mark - Tap Action

- (void)hideAction {
    isShowMoreView = !isShowMoreView;
    self.moreView.hidden = !isShowMoreView;
    self.backgrandView.hidden = !isShowMoreView;
    [self.moreButton setTitle:kValue(@"common_title_more") forState:UIControlStateNormal];
    [self.moreImageView setImage:[UIImage svgImageNamed:@"quick_operation_more.svg" tintColor:kGrayColor]];
}

- (void)selectedItem:(UIButton *)btn {
    if (btn.tag == 0) {
        NSLog(@"hahaha");
    }
}

- (void)selectMore {
    isShowMoreView = !isShowMoreView;
    self.moreView.hidden = !isShowMoreView;
    self.backgrandView.hidden = !isShowMoreView;
    [UIApplication.sharedApplication.keyWindow addSubview:self.backgrandView];
    
    [self.backgrandView addSubview:self.moreView];
    [self.backgrandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-50);
        make.height.equalTo(@(kScreenHeight - 50 - 64));
    }];
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.backgrandView);
        make.height.equalTo(@(_dataArr.count > 8 ? 200 : 100));
    }];
    
    self.pageControl.currentPage = 0;
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.backgrandView);
        make.bottom.equalTo(self.backgrandView).offset(0);
        make.height.equalTo(@(5));
    }];
    self.pageControl.numberOfPages =  _dataArr.count < 8 ? 0 : (_dataArr.count / 8 + 1);

    if (!isShowMoreView) {
        [self.moreButton setTitle:kValue(@"common_title_more") forState:UIControlStateNormal];
        [self.moreImageView setImage:[UIImage svgImageNamed:@"quick_operation_more.svg" tintColor:kGrayColor]];
    } else {
        [self.moreButton setTitle:kValue(@"common_title_cancel") forState:UIControlStateNormal];
        [self.moreImageView setImage:[UIImage svgImageNamed:@"quick_operation_cancle.svg" tintColor:kGrayColor]];
    }
}
#pragma mark -
#pragma mark - XSYEntityDetailComponentIdentifier

- (NSString *)viewID {
    return @"";
}

- (void)setModel:(id)model {
    _model = model;
    _dataArr = model;
}

#pragma mark -
#pragma mark - Getter

- (NSMutableArray *)dataArr {
    _dataArr = [NSMutableArray array];
    for (int i = 0; i < 15; i++) {
        XSYQuickOperationModel *model = [[XSYQuickOperationModel alloc] init];
        model.name = [NSString stringWithFormat:@"地理位置 %d",i];
        [_dataArr addObject:model];
    }
    return _dataArr;
}
- (UICollectionView *)moreView {
    if (!_moreView) {
        XSYquickOperationFlowLayout *layout = [[XSYquickOperationFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemCountPerRow = 4;
        layout.rowCount = 2;
        layout.minimumLineSpacing = 0.1;
        layout.minimumInteritemSpacing = 0.1;
        layout.dataCount = _dataArr.count / 8 + 1;
        layout.itemSize = CGSizeMake(kScreenWidth / 4, 86);
        UICollectionView *moreView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        moreView.backgroundColor = [UIColor whiteColor];
        moreView.hidden = YES;
         moreView.delegate = self;
        moreView.dataSource = self;
        moreView.pagingEnabled = YES;
        moreView.clipsToBounds = NO;
        moreView.showsVerticalScrollIndicator = NO;
        moreView.showsHorizontalScrollIndicator = NO;
        [moreView registerClass:[XSYQuickOperationCollectionCell class] forCellWithReuseIdentifier:@"XSYQuickOperationCollectionCell"];
        [self addSubview:(_moreView = moreView)];
    }
    return _moreView;
}

- (UIView *)backgrandView {
    if (!_backgrandView) {
        UIView *backgrandView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 50)];
        backgrandView.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction)];
        [backgrandView addGestureRecognizer:tapGesture];
        [self addSubview:(_backgrandView = backgrandView)];
    }
    return _backgrandView;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        UIButton *moreButton = [[UIButton alloc] init];
        _moreImageView = [[UIImageView alloc] init];
        [_moreImageView setImage:[UIImage svgImageNamed:@"quick_operation_more.svg" tintColor:[UIColor hexChangeFloat:@"607080"]]];
        _moreImageView.frame = CGRectMake((kScreenWidth / 5. - 22) / 2., 5, 22, 22);
        [moreButton addSubview:_moreImageView];
        [moreButton setTitle:kValue(@"common_title_more") forState:UIControlStateNormal];
        [moreButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -25, 0);
        moreButton.titleLabel.font = [UIFont systemFontOfSize:11.];
        [moreButton addTarget:self action:@selector(selectMore) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:(_moreButton = moreButton)];
    }
    return _moreButton;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.currentPageIndicatorTintColor = [UIColor hexChangeFloat:@"8899A6"];
        pageControl.pageIndicatorTintColor = [UIColor hexChangeFloat:@"E1E8ED" alpha:0.3];
        pageControl.userInteractionEnabled = NO;
        [self.moreView addSubview:(_pageControl = pageControl)];
    }
    return _pageControl;
}
@end
