//
//  SAMineAlertUIHelper.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAMineAlertUIHelper.h"
#import "SADrawSuccessView.h"
#import "SABingdingWxView.h"
#import "SAConfigModel.h"

@interface SAMineAlertUIHelper ()
@property (nonatomic) SAMineAlertType type;
@property (nonatomic) SADrawSuccessView *drawView;
@property (nonatomic) SABingdingWxView *bindingView;
@property (nonatomic) BOOL touchHide;
@end

@implementation SAMineAlertUIHelper

+ (void)showAlertUIWithType:(SAMineAlertType)type onCurrentVC:(UIViewController *)currentViewController{
    SAMineAlertUIHelper * alertVC = [[SAMineAlertUIHelper alloc] initWithAlertType:type];
    [alertVC showAlertUIOnCurrentVC:currentViewController];
}

- (instancetype)initWithAlertType:(SAMineAlertType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.touchHide = NO;
    
    switch (_type) {
        case SAMineAlertTypeNetworkError:
            [self showNetworkError];
            break;
            
        case SAMineAlertTypeRecruitOffline:
        case SAMineAlertTypeMineCenterOffline:
        case SAMineAlertTypeShareOffline:
            [self showOfflineError];
            break;
        
        case SAMineAlertTypeAnnouncement:
            [self showAnnouncement];
            break;
        
        case SAMineAlertTypeSignIn:
            [self showSignIn];
            break;
            
        case SAMineAlertTypeDrawSuccess:
            [self showDrawSuccess];
            break;
            
        case SAMineAlertTypeBingding:
            [self showBingding];
            break;
            
        case  SAMineAlertTypeQRCode:
            self.touchHide = YES;
            [self showQRCode];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showAlertUIOnCurrentVC:(UIViewController *)currentVC {
    
    BOOL anySpreadBanner = [currentVC.childViewControllers bk_any:^BOOL(id obj) {
        if ([obj isKindOfClass:[self class]]) {
            return YES;
        }
        return NO;
    }];
    
    if (anySpreadBanner) {
        return ;
    }
    
    if ([currentVC.view.subviews containsObject:self.view]) {
        return ;
    }
    
    [currentVC addChildViewController:self];
    self.view.frame = currentVC.view.bounds;
    self.view.alpha = 0;
    if (_type == SAMineAlertTypeShareOffline || _type == SAMineAlertTypeRecruitOffline || _type == SAMineAlertTypeMineCenterOffline) {
        
    } else {
        self.view.backgroundColor = [kColor(@"#000000") colorWithAlphaComponent:0.5];
    }
    [currentVC.view addSubview:self.view];
    [self didMoveToParentViewController:currentVC];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.touchHide) {
        [self hide];
    }
}

- (void)dealloc {
    
}

- (void)hide {
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

#pragma mark - type

- (void)showNetworkError {
    [UIAlertView bk_showAlertViewWithTitle:@"系统提示"
                                   message:@"网络连接发生错误!"
                         cancelButtonTitle:nil
                         otherButtonTitles:@[@"确定"]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex)
    {
        [self hide];
    }];
}

- (void)showOfflineError {
    NSString *notice = nil;
    switch (_type) {
        case SAMineAlertTypeRecruitOffline:
            notice = @"您还没登录，登录后才能招募徒弟";
            break;
        case SAMineAlertTypeMineCenterOffline:
            notice = @"您还没登录，登录后才能进入个人中心";
            break;
        case SAMineAlertTypeShareOffline:
            notice = @"您还没登录，登录后才能分享文章";
            break;
        default:
            break;
    }
    [UIAlertView bk_showAlertViewWithTitle:@"温馨提示"
                                   message:notice
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@[@"知道了"]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         [self hide];
         if (buttonIndex == 1) {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [[NSNotificationCenter defaultCenter] postNotificationName:kSAUserLoginNotification object:nil];
             });
         } else {
             if (self.type == SAMineAlertTypeRecruitOffline || self.type == SAMineAlertTypeMineCenterOffline) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:kSAReturnTabBarFirstNotification object:nil];
             }
         }
     }];
}

- (void)showAnnouncement {
    [UIAlertView bk_showAlertViewWithTitle:@"最新公告"
                                   message:[SAConfigModel defaultConfig].config.NOTICE
                         cancelButtonTitle:@"知道了"
                         otherButtonTitles:nil
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
        [self hide];
    }];
}

- (void)showSignIn {
    [UIAlertView bk_showAlertViewWithTitle:@"签到成功"
                                   message:nil
                         cancelButtonTitle:@"签到奖励已经发放"
                         otherButtonTitles:nil
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         [self hide];
     }];
}

- (void)showDrawSuccess {
    self.drawView = [[SADrawSuccessView alloc] init];
    [self.view addSubview:_drawView];
    
    {
        [_drawView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kWidth(510), kWidth(414)));
        }];
    }
    
    @weakify(self);
    _drawView.compleAction = ^{
        @strongify(self);
        [self.drawView removeFromSuperview];
        self.drawView = nil;
        [self hide];
    };
}

- (void)showBingding {
    self.bindingView = [[SABingdingWxView alloc] init];
    [self.view addSubview:_bindingView];
    
    {
        [_bindingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kWidth(510), kWidth(417)));
        }];
    }
    
    @weakify(self);
    _bindingView.confirmAction = ^{
        @strongify(self);
        [self.bindingView removeFromSuperview];
        self.bindingView = nil;
        [self hide];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kSABindingWxNotification object:nil];
        });
    };
}

- (void)showQRCode {
    NSString *recruitUrl = [NSString stringWithFormat:@"%@?userId=%@",[SAConfigModel defaultConfig].config.AP_URL,[SAUser user].userId];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[recruitUrl getQRCode]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    {
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

@end
