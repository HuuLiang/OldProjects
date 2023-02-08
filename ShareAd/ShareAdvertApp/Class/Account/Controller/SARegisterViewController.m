//
//  SARegisterViewController.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SARegisterViewController.h"
#import "SARegisterInfoView.h"
#import "SAReqManager.h"
#import "SARegisterModel.h"
#import "SAVerifyCodeModel.h"

@interface SARegisterViewController ()
@property (nonatomic) SARegisterInfoView *registerInfoView;
@property (nonatomic) UIButton *confirmButton;
@property (nonatomic) UILabel *haveLabel;
@property (nonatomic) SAVerifyCodeModel *verifyCodeModel;
@end

@implementation SARegisterViewController
QBDefineLazyPropertyInitialization(SAVerifyCodeModel, verifyCodeModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#efefef");
    
    [self configRegisterInfoView];
    
    [self configConfirmView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configRegisterInfoView {
    self.registerInfoView = [[SARegisterInfoView alloc] init];
    [self.view addSubview:_registerInfoView];
    
    @weakify(self);
    _registerInfoView.codeAction = ^{
        @strongify(self);
        [self.verifyCodeModel fetchVerifyCodeWithPhoneNumber:self.registerInfoView.phoneNumber class:[SAVerifyCodeModel class] handler:^(BOOL success, id obj) {
            if (success) {
                [[SAHudManager manager] showHudWithText:@"验证码已发送"];
            }
        }];
    };
    
    {
        [_registerInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(kWidth(32)+64);
            make.size.mas_equalTo(CGSizeMake(kWidth(690), kWidth(534)));
        }];
    }
}

- (void)configConfirmView {
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setTitle:@"提交" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = kFont(14);
    _confirmButton.layer.cornerRadius = 3.0f;
    _confirmButton.backgroundColor = kColor(@"#ff3366");
    [self.view addSubview:_confirmButton];
    
    self.haveLabel = [[UILabel alloc] init];
    _haveLabel.text = @"已有账号";
    _haveLabel.font = kFont(14);
    _haveLabel.textColor = kColor(@"#ff3366");
    _haveLabel.textAlignment = NSTextAlignmentRight;
    _haveLabel.userInteractionEnabled = YES;
    [self.view addSubview:_haveLabel];
    
    @weakify(self);
    [_confirmButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        if (self.registerInfoView.phoneNumber.length != 11) {
            [[SAHudManager manager] showHudWithText:@"请输入正确的手机号码"];
            return ;
        }
        
        if (self.registerInfoView.password.length == 0) {
            [[SAHudManager manager] showHudWithText:@"请输入密码"];
            return;
        }

        if (self.registerInfoView.verifyCode.length != 4) {
            [[SAHudManager manager] showHudWithText:@"验证码错误"];
            return;
        }

        if (self.registerInfoView.nickName.length == 0) {
            [[SAHudManager manager] showHudWithText:@"请输入昵称"];
            return;
        }

        
        [SAUser user].phone = self.registerInfoView.phoneNumber;
        [SAUser user].password = self.registerInfoView.password;
        [SAUser user].verifyCode = self.registerInfoView.verifyCode;
        [SAUser user].nickName = self.registerInfoView.nickName;
        
        if (self.type == SARegisterTypeRegister) {
            [[SAReqManager manager] registerUserWithInfo:[SAUser user] class:[SARegisterModel class] handler:^(BOOL success, SARegisterModel * obj) {
                if (success) {
                    [SAUser user].userId = obj.userId;
                    if ([[SAUser user] update]) {
                        [self dismissViewControllerAnimated:YES completion:^{
                            [SAUtil fetchAccountInfo];
                            [[NSNotificationCenter defaultCenter] postNotificationName:kSAUserLoginSuccessNotification object:nil];
                        }];
                    }
                }
            }];
        } else if (self.type == SARegisterTypeForgot) {
            [[SAReqManager manager] changePasswordWithInfo:[SAUser user] class:[SARegisterModel class] handler:^(BOOL success, SARegisterModel * obj) {
                if (success) {
                    [[SAHudManager manager] showHudWithText:@"密码修改成功"];
                }
            }];
        }
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_haveLabel bk_whenTapped:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    {
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_registerInfoView.mas_bottom).offset(kWidth(30));
            make.size.mas_equalTo(CGSizeMake(kWidth(690), kWidth(90)));
        }];
        
        [_haveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_confirmButton.mas_right);
            make.top.equalTo(_confirmButton.mas_bottom).offset(kWidth(35));
            make.height.mas_equalTo(_haveLabel.font.lineHeight);
        }];
    }
}

@end
