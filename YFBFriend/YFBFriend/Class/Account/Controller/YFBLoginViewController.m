//
//  YFBLoginViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBLoginViewController.h"
#import "YFBAccountManager.h"
#import "YFBUserLoginVC.h"
#import "YFBRegisterFirstVC.h"
#import "YFBWebViewController.h"

@interface YFBLoginViewController ()
//@property (nonatomic,strong) UIButton     *QQButton;
@property (nonatomic,strong) UIView       *WXButton;
@property (nonatomic,strong) UIButton     *accountButton;
@property (nonatomic,strong) UIButton     *registerButton;
@end

@implementation YFBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    [self configTXLogin];
    [self configAccountLogin];
    [self configDescription];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)alwaysHideNavigationBar {
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)configTXLogin {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"请选择您的登录方式：";
    label.textColor = kColor(@"#666666");
    label.font = [UIFont systemFontOfSize:kWidth(30)];
    [self.view addSubview:label];
    
    
//    self.WXButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_WXButton setImage:[UIImage imageNamed:@"login_wx"] forState:UIControlStateNormal];
//    [_WXButton setTitle:@"微信登录" forState:UIControlStateNormal];
//    [_WXButton setTitleColor:kColor(@"#999999") forState:UIControlStateNormal];
//    _WXButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
//    [self.view addSubview:_WXButton];

    self.WXButton = [[UIView alloc] init];
    [self.view addSubview:_WXButton];
    
    UIImageView *wxImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_wx"]];
    wxImgV.userInteractionEnabled = YES;
    [_WXButton addSubview:wxImgV];
    
    UILabel *wxLabel = [[UILabel alloc] init];
    wxLabel.text = @"微信登录";
    wxLabel.textColor = kColor(@"#999999");
    wxLabel.font = kFont(14);
    wxLabel.textAlignment = NSTextAlignmentCenter;
    [_WXButton addSubview:wxLabel];
    
    [_WXButton bk_whenTapped:^{
        @weakify(self);
        [[YFBAccountManager manager] loginWithWXhandler:^(BOOL success) {
            @strongify(self);
            if (success) {
                [YFBUser currentUser].loginType = YFBLoginTypeWX;
                YFBRegisterFirstVC *registerVC = [[YFBRegisterFirstVC alloc] initWithTitle:@"填写用户信息"];
                [self.navigationController pushViewController:registerVC animated:YES];
            }
        }];;
    }];
    
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(kWidth(76));
            make.top.equalTo(self.view).offset(kWidth(204));
            make.height.mas_equalTo(kWidth(30));
        }];
        
        [_WXButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view).offset(0);
            make.top.equalTo(label.mas_bottom).offset(kWidth(98));
            make.size.mas_equalTo(CGSizeMake(kWidth(130), kWidth(200)));
        }];
        
        [wxImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_WXButton);
            make.height.mas_equalTo(kWidth(130));
        }];
        
        [wxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_WXButton);
            make.centerX.equalTo(_WXButton);
            make.height.mas_equalTo(kWidth(24));
        }];
    }
}

- (void)configAccountLogin {
    UIImageView *downImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_down"]];
    [self.view addSubview:downImageView];
    
    UIImageView *lineImageView = [[UIImageView alloc] init];
    lineImageView.backgroundColor = kColor(@"#CACACA");
    [self.view insertSubview:lineImageView belowSubview:downImageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"你还可以选择";
    label.textColor = kColor(@"#999999");
    label.font = [UIFont systemFontOfSize:kWidth(26)];
    [self.view addSubview:label];
    
    self.accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_accountButton setTitle:@"账号登录" forState:UIControlStateNormal];
    [_accountButton setTitleColor:kColor(@"#999999") forState:UIControlStateNormal];
    _accountButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(26)];
    _accountButton.layer.borderWidth = kWidth(2);
    _accountButton.layer.borderColor = kColor(@"#E6E6E6").CGColor;
    [self.view addSubview:_accountButton];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [_registerButton setTitleColor:kColor(@"#EB5B1C") forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(26)];
    _registerButton.layer.borderWidth = kWidth(2);
    _registerButton.layer.borderColor = kColor(@"#E6E6E6").CGColor;
    [self.view addSubview:_registerButton];

    @weakify(self);
    [_accountButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        YFBUserLoginVC *userLoginVC = [[YFBUserLoginVC alloc] initWithTitle:@"用户登录"];
        [self.navigationController pushViewController:userLoginVC animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_registerButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [YFBUser currentUser].loginType = YFBLoginTypeDefine;
        YFBRegisterFirstVC *registerVC = [[YFBRegisterFirstVC alloc] initWithTitle:@"填写用户信息"];
        [self.navigationController pushViewController:registerVC animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [downImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_WXButton.mas_bottom).offset(kWidth(64));
            make.size.mas_equalTo(CGSizeMake(kWidth(52), kWidth(52)));
        }];
        
        [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(downImageView);
            make.size.mas_equalTo(CGSizeMake(kWidth(600), kWidth(2)));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(downImageView.mas_bottom).offset(kWidth(32));
            make.height.mas_equalTo(kWidth(26));
        }];
        
        [_accountButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(kWidth(36));
            make.right.equalTo(self.view.mas_centerX).offset(-kWidth(51));
            make.size.mas_equalTo(CGSizeMake(kWidth(132), kWidth(48)));
        }];
        
        [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(kWidth(36));
            make.left.equalTo(self.view.mas_centerX).offset(kWidth(51));
            make.size.mas_equalTo(CGSizeMake(kWidth(132), kWidth(48)));
        }];
    }
}

- (void)configDescription {
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"登录即代表你同意本APP隐私协议" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kWidth(22)],
                                                                                                                                NSForegroundColorAttributeName:kColor(@"#999999")}];
    NSRange range = [attriString.string rangeOfString:@"APP隐私协议"];
    [attriString addAttribute:NSForegroundColorAttributeName value:kColor(@"#EB6987") range:range];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setAttributedTitle:attriString forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    @weakify(self);
    [button bk_addEventHandler:^(id sender) {
        @strongify(self);
        //APP隐私协议
        YFBWebViewController *webVC = [[YFBWebViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YFB_BASE_URL,YFB_APPLICENSE_URL]] standbyURL:nil];
        [self.navigationController pushViewController:webVC animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-kWidth(38));
            make.size.mas_equalTo(CGSizeMake(kWidth(360), kWidth(22)));
        }];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
//    CGRect wxButtonFrame = _WXButton.frame;
//    _WXButton.imageEdgeInsets = UIEdgeInsetsMake(-(wxButtonFrame.size.height-_WXButton.imageView.size.height)/2, (wxButtonFrame.size.width-_WXButton.imageView.size.width)/2, (wxButtonFrame.size.height-_WXButton.imageView.size.height)/2, -(wxButtonFrame.size.width-_WXButton.imageView.size.width)/2);
//    _WXButton.titleEdgeInsets = UIEdgeInsetsMake(wxButtonFrame.size.height-kWidth(35), -_WXButton.imageView.frame.size.width, 0, 0);
}


@end
