//
//  XSYApprovalFlowView.m
//  ingage
//
//  Created by AJ-1993 on 2018/2/5.
//  Copyright © 2018年 com. All rights reserved.
//

#import "XSYApprovalFlowView.h"
#import "Masonry.h"
#import "UIImage+SVG.h"
#import "XSYApprovalFlowModel.h"
#import "XSYUserDefaults.h"
#define KApprovalImageWidth 16.
#define KArrowImageWidth 12.
#define KApprovalImageLeftToSuperViewConstraint 15.
#define KApprovalImageRightToTitleLabLeftConstraint 5.
#define KTitleLabRightToArrowImageLeftConstraint 5.
#define KArrowImageRightToStateBtnLeftConstraint 15.
#define KStateButtonRightToSuperViewConstraint 15.
#define KStateButtonAddWidth 20.
#define KStateButtonHeightPending 24.
#define KTitleLabTopToSuperViewConstraint 15.
#define KOneHalfWidth (kScreenWidth - 15*3)/2
#define KOneThirdWidth (kScreenWidth - 15*4)/3

@interface XSYApprovalFlowView ()

@property (nonatomic, strong) UIView *normalView;//backGroundView
@property (nonatomic, strong) UIView *agreeRefuseView;

@property (nonatomic, strong) UIImageView *approvalImage;//审批流标识图片
@property (nonatomic, strong) UIImageView *arrowImage;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *stateButton;

@property (nonatomic, strong) UIButton *agreeBtn;//同意
@property (nonatomic, strong) UIButton *refuseBtn;//拒绝
@property (nonatomic, strong) UIButton *withdrawBtn;//撤回
@property (nonatomic, strong) UIButton *addSignBtn;//找人同审
@property (nonatomic, strong) NSLayoutConstraint *normalViewHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *stateButtonWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *stateButtonHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *titleLabWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *agreeRefuseViewHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *agreeBtnWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *refuseBtnWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *withdrawBtnLeftToSuperViewConstraint;
@property (nonatomic, strong) NSLayoutConstraint *withdrawBtnTopToSuperViewConstraint;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) BOOL showAgreeRefuseView;
@end

@implementation XSYApprovalFlowView {
    XSYApprovalFlowModel *_model;
}

@synthesize viewHeight = _viewHeight;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        _viewHeight = [XSYListenable listenableWithValue:@(50) setterAction:nil];
    }
    return self;
}
#pragma mark -
#pragma mark - XSYEntityDetailComponentIdentifier
- (NSString *)viewID {
    return @"";
}
- (void)setModel:(id)model {
    _model = model;
    [self.approvalImage setImage:[XSYApprovalFlowView svgImageWithColor:@"approval_flow_icon.svg" withColor:_model.color]];
    [self.arrowImage setImage:[XSYApprovalFlowView svgImageWithColor:@"approval_flow_arrow.svg" withColor:_model.color]];
    self.titleLab.textColor = _model.color;
     self.stateButton.hidden = !_model.showStateBtn;
    [self.stateButton setTitle: _model.stateString forState:UIControlStateNormal];
    self.titleLab.text = _model.titleLabStr ;
    
    //agreeRefuseView布局
    if ( [[NSString stringWithFormat:@"%u",_model.currentApproverId]  isEqualToString:kCurrentUid]) {
        //当前审批人是自己
        self.stateButton.backgroundColor = [UIColor hexChangeFloat:@"FF9900"];
        [self.stateButton setTitleColor:[UIColor hexChangeFloat:@"FFFFFF"] forState:UIControlStateNormal];
        self.stateButton.titleLabel.font = [UIFont systemFontOfSize:12.];
        self.stateButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.stateButtonHeightConstraint.constant = KStateButtonHeightPending;
        
        if (_model.cancelApprovalable && _model.addSignable) {
            self.agreeRefuseViewHeightConstraint.constant = 100;
            self.withdrawBtnLeftToSuperViewConstraint.constant = 15.;
            self.withdrawBtnTopToSuperViewConstraint.constant = 60.;
        }
        if (_model.cancelApprovalable && !_model.addSignable) {
            self.withdrawBtnLeftToSuperViewConstraint.constant = KOneThirdWidth*2 + 15*3;
            self.withdrawBtnTopToSuperViewConstraint.constant = 10;
        }
        if (!_model.cancelApprovalable && !_model.addSignable) {
            self.agreeBtnWidthConstraint.constant = KOneHalfWidth;
            self.refuseBtnWidthConstraint.constant = KOneHalfWidth;
        }
    }
    
    //normal布局
    [self.stateButton sizeToFit];
    CGFloat stateButtonWidth = self.stateButton.width +KStateButtonAddWidth;
    self.stateButtonWidthConstraint.constant = stateButtonWidth;
    //titleLab width kScreenWidth - 15 -16-5-"titleLabWidth" -5-12-15-stateWidth -15
    CGFloat titleLabMaxWidth = kScreenWidth - KApprovalImageLeftToSuperViewConstraint -KApprovalImageWidth-KApprovalImageRightToTitleLabLeftConstraint-KTitleLabRightToArrowImageLeftConstraint-KArrowImageWidth-KArrowImageRightToStateBtnLeftConstraint-stateButtonWidth-KStateButtonRightToSuperViewConstraint;
    [self.titleLab sizeToFit];
    CGFloat titleLabHeight =  [viewTool heightForString:self.titleLab.text fontSize:14. andWidth:titleLabMaxWidth];
    if (titleLabHeight > k_font_height_14) {
        self.titleLabWidthConstraint.constant = titleLabMaxWidth;
        titleLabHeight = k_font_height_14*2;
    }else {
        self.titleLabWidthConstraint.constant = self.titleLab.width;
        titleLabHeight = k_font_height_14;
    }
    self.normalViewHeightConstraint.constant = titleLabHeight+KTitleLabTopToSuperViewConstraint *2;
    
    _cellHeight =  self.normalViewHeightConstraint.constant;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(_cellHeight);
    }];
    _viewHeight.value = @(_cellHeight);
    [self layoutIfNeeded];
}

- (void)agreeApproval {
    if (self.tapAction) {
        self.tapAction(APPROVAL_FLOW_Agree, nil);
    }
}
- (void)refuseApproval {
    if (self.tapAction) {
        self.tapAction(APPROVAL_FLOW_Refuse, nil);
    }
}
- (void)withdrawApproval {
    if (self.tapAction) {
        self.tapAction(APPROVAL_FLOW_NORMAL, nil);
    }
}
- (void)addSign {
    if (self.tapAction) {
        self.tapAction(APPROVAL_FLOW_ADDSIGN, nil);
    }
}
- (void)goApproval {
    if (self.tapAction) {
        self.tapAction(APPROVAL_FLOW_SUBMIT, nil);
    }
}
- (void)checkApproval {
    if(_model.approvalStatus == XSYApprovalStatusUnsubmit ||
       _model.approvalStatus == XSYApprovalStatusUnsubmit||
       _model.approvalStatus == XSYApprovalStatusUnsubmit){
         [self submitApproval];
        return;
    }
    CGFloat agreeRefuseViewHeight = 0;
    if(_model.approvalStatus == XSYApprovalStatusPending){
        //待审批
        if([[NSString stringWithFormat:@"%u",_model.currentApproverId]  isEqualToString:kCurrentUid]){
            agreeRefuseViewHeight = (_model.cancelApprovalable && _model.addSignable)?100:50;
        }else {
            //当前审批人不是自己可撤回
            [self cancleApproval];
            return;
        }
    }
    self.showAgreeRefuseView = !self.showAgreeRefuseView;
    if (self.showAgreeRefuseView) {
        _cellHeight+=agreeRefuseViewHeight;
        self.agreeRefuseView.hidden = NO;
        [self.stateButton setTitle:kValue(@"feed_title_close") forState:UIControlStateNormal];
        self.stateButton.backgroundColor = [UIColor hexChangeFloat:@"CCD6DD"];
        self.stateButton.layer.borderColor = [UIColor hexChangeFloat:@"CCD6DD"].CGColor;
    } else {
        _cellHeight-=agreeRefuseViewHeight;
        self.agreeRefuseView.hidden = YES;
        [self.stateButton setTitle:kValue(@"default_approval") forState:UIControlStateNormal];
        self.stateButton.backgroundColor = [UIColor hexChangeFloat:@"FF9900"];
        self.stateButton.layer.borderColor = [UIColor hexChangeFloat:@"FF9900"].CGColor;
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(_cellHeight);
    }];
     _viewHeight.value = @(_cellHeight);
}
- (void)submitApproval {
    
}
- (void)cancleApproval {
    
}
- (void)createUI {
    
    [self.normalView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.normalView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.normalView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    self.normalViewHeightConstraint = [self.normalView autoSetDimension:ALDimensionHeight toSize:50];
    
    [self.approvalImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:KApprovalImageLeftToSuperViewConstraint];
    [self.approvalImage autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.approvalImage autoSetDimension:ALDimensionHeight toSize:KApprovalImageWidth];
    [self.approvalImage autoSetDimension:ALDimensionWidth toSize:KApprovalImageWidth];
    
    [self.stateButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:KStateButtonRightToSuperViewConstraint];
    [self.stateButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    self.stateButtonWidthConstraint = [self.stateButton autoSetDimension:ALDimensionWidth toSize:0];
    self.stateButtonHeightConstraint = [self.stateButton autoSetDimension:ALDimensionHeight toSize:30];
    
    
    [self.titleLab autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.titleLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.approvalImage withOffset:KApprovalImageRightToTitleLabLeftConstraint];
    self.titleLabWidthConstraint =  [self.titleLab autoSetDimension:ALDimensionWidth toSize:0];
    
    [self.arrowImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.titleLab withOffset:KTitleLabRightToArrowImageLeftConstraint];
    [self.arrowImage autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.arrowImage autoSetDimension:ALDimensionHeight toSize:KArrowImageWidth];
    [self.arrowImage autoSetDimension:ALDimensionWidth toSize:KArrowImageWidth];
    
    [self.agreeRefuseView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.normalView];
    [self.agreeRefuseView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.agreeRefuseView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    self.agreeRefuseViewHeightConstraint = [self.agreeRefuseView autoSetDimension:ALDimensionHeight toSize:50];
    
    [self.agreeBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.];
    [self.agreeBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.];
    [self.agreeBtn autoSetDimension:ALDimensionHeight toSize:30];
    self.agreeBtnWidthConstraint =  [self.agreeBtn autoSetDimension:ALDimensionWidth toSize:KOneThirdWidth];
    
    [self.refuseBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.];
    [self.refuseBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.agreeBtn withOffset:15.];
    [self.refuseBtn autoSetDimension:ALDimensionHeight toSize:30];
    self.refuseBtnWidthConstraint =  [self.refuseBtn autoSetDimension:ALDimensionWidth toSize:KOneThirdWidth];
    
    [self.addSignBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.];
    [self.addSignBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.refuseBtn withOffset:15.];
    [self.addSignBtn autoSetDimension:ALDimensionHeight toSize:30];
    [self.addSignBtn autoSetDimension:ALDimensionWidth toSize:KOneThirdWidth];
    
    self.withdrawBtnTopToSuperViewConstraint = [self.withdrawBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    self.withdrawBtnLeftToSuperViewConstraint = [self.withdrawBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.withdrawBtn autoSetDimension:ALDimensionHeight toSize:30];
    [self.withdrawBtn autoSetDimension:ALDimensionWidth toSize:KOneThirdWidth];
}

#pragma mark -
#pragma mark - Getter

- (UIView *)normalView {
    if (!_normalView) {
        _normalView = [[UIView alloc] init];
        _normalView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_normalView];
    }
    return _normalView;
}

- (UIView *)agreeRefuseView {
    if (!_agreeRefuseView) {
        _agreeRefuseView = [[UIView alloc] init];
        _agreeRefuseView.layer.masksToBounds = YES;
        _agreeRefuseView.hidden = YES;
        _agreeRefuseView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_agreeRefuseView];
    }
    return _agreeRefuseView;
}

- (UIImageView *)approvalImage {
    if (!_approvalImage) {
        _approvalImage = [[UIImageView alloc] init];
        [self.normalView addSubview:_approvalImage];
    }
    return _approvalImage;
}

- (UIImageView *)arrowImage {
    if (!_arrowImage) {
        _arrowImage = [[UIImageView alloc] init];
        [self.normalView addSubview:_arrowImage];
    }
    return _arrowImage;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLab.numberOfLines = 2.;
        _titleLab.font = [UIFont systemFontOfSize:14.];
        //        [_titleButton addTarget:self action:@selector(goApproval) forControlEvents:UIControlEventTouchUpInside];
        [self.normalView addSubview:_titleLab];
    }
    return _titleLab;
}

- (UIButton *)stateButton {
    if (!_stateButton) {
        _stateButton = [XSYApprovalFlowView customBtnTitle:@"" withColor:@"0A7CD9"];
        [_stateButton addTarget:self action:@selector(checkApproval) forControlEvents:UIControlEventTouchUpInside];
        [self.normalView addSubview:_stateButton];
    }
    return _stateButton;
}

- (UIButton *)agreeBtn {
    if (!_agreeBtn) {
        _agreeBtn =[XSYApprovalFlowView customBtnTitle:kValue(@"approval_title_agree") withColor:@"00B377"];
        [_agreeBtn addTarget:self action:@selector(agreeApproval) forControlEvents:UIControlEventTouchUpInside];
        [self.agreeRefuseView addSubview :_agreeBtn];
    }
    return _agreeBtn;
}

- (UIButton *)refuseBtn {
    if (!_refuseBtn) {
        _refuseBtn =[XSYApprovalFlowView customBtnTitle:kValue(@"approval_title_refuse") withColor:@"FF3333"];
        [_refuseBtn addTarget:self action:@selector(refuseApproval) forControlEvents:UIControlEventTouchUpInside];
        [self.agreeRefuseView addSubview:_refuseBtn];
    }
    return _refuseBtn;
}

- (UIButton *)withdrawBtn {
    if (!_withdrawBtn) {
        _withdrawBtn = [XSYApprovalFlowView customBtnTitle:kValue(@"approval_btn_cancel") withColor:@"0A7CD9"];
        [_withdrawBtn addTarget:self action:@selector(withdrawApproval) forControlEvents:UIControlEventTouchUpInside];
        [self.agreeRefuseView addSubview:_withdrawBtn];
    }
    return _withdrawBtn;
}
- (UIButton *)addSignBtn {
    if (!_addSignBtn) {
        _addSignBtn = [XSYApprovalFlowView customBtnTitle:kValue(@"approval_title_invite") withColor:@"0A7CD9"];
        [_addSignBtn addTarget:self action:@selector(addSign) forControlEvents:UIControlEventTouchUpInside];
        [self.agreeRefuseView addSubview:_addSignBtn];
    }
    return _withdrawBtn;
}
+ (UIButton *)customBtnTitle:(NSString *)title withColor:(NSString *)color{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.cornerRadius = 4.0;
    button.layer.borderWidth = 1.0;
    button.titleLabel.font = [UIFont systemFontOfSize:14.];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitleColor:[UIColor hexChangeFloat:color] forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor hexChangeFloat:color].CGColor;
    return button;
}

+ (UIImage *)svgImageWithColor:(NSString *)svgImageName withColor:(UIColor *)color {
    UIImage *image = [UIImage svgImageNamed:svgImageName tintColor:color];
    return image;
}

@end
