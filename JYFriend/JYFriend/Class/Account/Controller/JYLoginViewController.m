//
//  JYLoginViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYLoginViewController.h"
#import "JYTextField.h"
#import "JYNextButton.h"
#import "JYRegisterNickNameViewController.h"
#import "JYNavigationController.h"

@interface JYLoginViewController () <UITextFieldDelegate>
{
    UIImageView  *_bgImgV;
    JYTextField  *_accountField;
    JYTextField  *_passwordField;
    JYNextButton *_loginBtn;
    UILabel      *_findPasswordLabel;
    UILabel      *_registerLabel;
}
@end

@implementation JYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bgImgV = [[UIImageView alloc] init];
    _bgImgV.image = [UIImage imageNamed:@"login_background.jpg"];
    _bgImgV.contentMode = UIViewContentModeScaleToFill;
    _bgImgV.userInteractionEnabled = YES;
    [self.view addSubview:_bgImgV];
    {
        [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self setUserAccountTextField];
    [self setUserPasswordTextField];
    [self setLoginButton];
    
//    [self userFindPassWord];
    [self userRegister];
}

- (BOOL)alwaysHideNavigationBar {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//账号栏
- (void)setUserAccountTextField {
    _accountField = [[JYTextField alloc] init];
    _accountField.backgroundColor = [[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.44];
    _accountField.delegate = self;
    _accountField.placeholder = @"输入你的手机号";
    UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_account"]];
    _accountField.leftView = image;
    _accountField.leftViewMode = UITextFieldViewModeAlways;
    _accountField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_accountField];
    {
        [_accountField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(kWidth(450));
            make.size.mas_equalTo(CGSizeMake(kWidth(560), kWidth(88)));
        }];
    }
}

//密码栏
- (void)setUserPasswordTextField {
    _passwordField = [[JYTextField alloc] init];
    _passwordField.backgroundColor = [[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.44];
    _passwordField.delegate = self;
    _passwordField.placeholder = @"输入你的密码";
    UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password"]];
    _passwordField.leftView = image;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.keyboardType = UIKeyboardTypeTwitter;
    [self.view addSubview:_passwordField];
    {
        [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_accountField.mas_bottom).offset(kWidth(10));
            make.size.mas_equalTo(CGSizeMake(kWidth(560), kWidth(88)));
        }];
    }
}

//登录按钮
- (void)setLoginButton {
    @weakify(self);
    _loginBtn = [[JYNextButton alloc] initWithTitle:@"登录" action:^{
        @strongify(self);
        //处理登陆事情
        
    }];
    
    _loginBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:_loginBtn];
    {
        [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_passwordField.mas_bottom).offset(kWidth(40));
            make.size.mas_equalTo(CGSizeMake(kWidth(560), kWidth(88)));
        }];
    }
}

//忘记密码
//- (void)userFindPassWord {
//    _findPasswordLabel = [[UILabel alloc] init];
//    _findPasswordLabel.text = @"忘记密码";
//    _findPasswordLabel.font = [UIFont systemFontOfSize:kWidth(30)];
//    _findPasswordLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
//    _findPasswordLabel.userInteractionEnabled = YES;
//    [self.view addSubview:_findPasswordLabel];
//    {
//        [_findPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_loginBtn.mas_left);
//            make.top.equalTo(_loginBtn.mas_bottom).offset(kWidth(24));
//            make.height.mas_equalTo(kWidth(30));
//        }];
//    }
//    
//    @weakify(self);
//    [_findPasswordLabel bk_whenTapped:^{
//        @strongify(self);
//        //找回密码
//        
//    }];
//}

//注册
- (void)userRegister {
    _registerLabel = [[UILabel alloc] init];
    _registerLabel.text = @"立即注册";
    _registerLabel.font = [UIFont systemFontOfSize:kWidth(30)];
    _registerLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    _registerLabel.textAlignment = NSTextAlignmentRight;
    _registerLabel.userInteractionEnabled = YES;
    [self.view addSubview:_registerLabel];
    {
        [_registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_loginBtn.mas_right);
            make.top.equalTo(_loginBtn.mas_bottom).offset(kWidth(24));
//            make.height.mas_equalTo(kWidth(30));
            make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(40)));
        }];
    }
    
    @weakify(self);
    [_registerLabel bk_whenTapped:^{
        @strongify(self);
        //注册界面
        JYRegisterNickNameViewController *nickVC = [[JYRegisterNickNameViewController alloc] initWithTitle:@"注册"];
        [self.navigationController pushViewController:nickVC animated:YES];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [_accountField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

@end
