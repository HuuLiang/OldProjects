//
//  YFBGiftPopViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBGiftPopViewController.h"
#import "YFBBlagGiftView.h"
#import "YFBGiftPopView.h"
#import "YFBGiftManager.h"
#import "YFBContactManager.h"
#import "YFBInteractionManager.h"

@interface YFBGiftPopViewController ()

@property (nonatomic,retain) YFBBlagGiftView *popView;
@property (nonatomic,retain) YFBGiftPopView *messagePopView;
@property (nonatomic) YFBGiftPopViewType giftPopViewType;
@end

@implementation YFBGiftPopViewController

- (void)configBlagGiftView {
    self.popView = [[YFBBlagGiftView alloc] init];
    _popView.sendTitle = self.contactInfo.nickName;;
    _popView.sendSubTitle = @"来个礼物呀";
    _popView.headerImageUrl = self.contactInfo.portraitUrl;
    @weakify(self);
    _popView.closeAction = ^(id obj) {
        @strongify(self);
        [self hide];
    };
    
    _popView.sendGiftAction = ^(YFBGiftInfo * obj) {
        @strongify(self);
        if (self.sendGiftAction) {
            self.sendGiftAction(obj);
        }
    };
    
    [self.view addSubview:_popView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"gift_close_btn_icon"] forState:UIControlStateNormal];
    [closeBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self hide];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];

    {
        [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view.mas_centerY).offset(kWidth(-20));
            make.size.mas_equalTo(CGSizeMake(kWidth(672), kWidth(810)));
        }];
        
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_popView.mas_right);
            make.centerY.equalTo(_popView.mas_bottom).offset(-kWidth(330*2));
            make.size.mas_equalTo(CGSizeMake(kWidth(48), kWidth(48)));
        }];
    }

}

- (void)configSendListView {
    self.messagePopView = [[YFBGiftPopView alloc] initWithGiftInfos:nil WithGiftViewType:YFBGiftPopViewTypeList];
    [self.view addSubview:_messagePopView];
    
    {
        [_messagePopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            make.height.mas_equalTo(kWidth(464));
        }];
    }
    @weakify(self);
    _messagePopView.sendGiftAction = ^(YFBGiftInfo * obj) {
        @strongify(self);
        if (self.sendGiftAction) {
            self.sendGiftAction(obj);
        }
    };
    _messagePopView.payAction = ^{
        @strongify(self);
        if (self.payAction) {
            self.payAction();
        }
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDiamondCount) name:kYFBUpdateGiftDiamondCountNotification object:nil];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    
    switch (self.giftPopViewType) {
        case YFBGiftPopViewTypeBlag:
            [self configBlagGiftView];
            break;
            
        case YFBGiftPopViewTypeList:
            [self configSendListView];
            break;

        default:
            break;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_messagePopView) {
        [_messagePopView startSelectedDefaultIndexPath];
    }
}

- (void)updateDiamondCount {
    if (_popView) {
        _popView.diamondCount = [YFBUser currentUser].diamondCount;
    }
    if (_messagePopView) {
        _messagePopView.diamondCount = [YFBUser currentUser].diamondCount;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.giftPopViewType == YFBGiftPopViewTypeList) {
        [self hide];
    }
}

+ (void)showGiftViewWithType:(YFBGiftPopViewType)type InCurrentViewController:(UIViewController *)currentViewController {
    YFBGiftPopViewController *giftVC = [[YFBGiftPopViewController alloc] init];
    [giftVC showGiftViewWithType:type InCurrentViewController:currentViewController];
}

- (void)showGiftViewWithType:(YFBGiftPopViewType)type InCurrentViewController:(UIViewController *)currentViewController {
    self.giftPopViewType = type;
    
    BOOL anySpreadBanner = [currentViewController.childViewControllers bk_any:^BOOL(id obj) {
        if ([obj isKindOfClass:[self class]]) {
            return YES;
        }
        return NO;
    }];
    
    if (anySpreadBanner) {
        return ;
    }
    
    if ([currentViewController.view.subviews containsObject:self.view]) {
        return ;
    }
    
    [currentViewController addChildViewController:self];
    self.view.frame = currentViewController.view.bounds;
    self.view.alpha = 0;
    [currentViewController.view addSubview:self.view];
    [currentViewController.view bringSubviewToFront:self.view];
    [self didMoveToParentViewController:currentViewController];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1;
    }];
}

- (void)hide {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (!self.view.superview) {
        return ;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
