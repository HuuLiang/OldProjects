//
//  SARegisterInfoView.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SARegisterInfoView.h"
#import "SATextField.h"


@interface SARegisterInfoView ()
@property (nonatomic) SATextField *accountField;
@property (nonatomic) UIButton *sendCodeButton;
@property (nonatomic) SATextField *codeField;
@property (nonatomic) SATextField *passwordField;
@property (nonatomic) SATextField *nickField;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimeInterval timeInterval;
@end

@implementation SARegisterInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _timeInterval = 60;
        
        self.backgroundColor = [kColor(@"#ffffff") colorWithAlphaComponent:0.85];
        
        self.accountField = [[SATextField alloc] initWithTitle:@"账号" placeholder:@"请输入你的手机号码"];
        [self addSubview:_accountField];
        
        self.sendCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_sendCodeButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        _sendCodeButton.titleLabel.font = kFont(12);
        _sendCodeButton.backgroundColor = kColor(@"#ff3366");
        [self addSubview:_sendCodeButton];
        
        self.codeField = [[SATextField alloc] initWithTitle:@"验证码" placeholder:@"请输入你的验证码"];
        [self addSubview:_codeField];

        self.passwordField = [[SATextField alloc] initWithTitle:@"密码" placeholder:@"******"];
        [self addSubview:_passwordField];

        self.nickField = [[SATextField alloc] initWithTitle:@"昵称" placeholder:@"请输入你的昵称"];
        [self addSubview:_nickField];
        
        @weakify(self);
        [_sendCodeButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (_accountField.text.length != 11) {
                [[SAHudManager manager] showHudWithText:@"输入错误"];
                return ;
            }
            [self setButtonSendingStatus:YES];
            if (self.codeAction) {
                self.codeAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        _timer = [NSTimer bk_scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
            @strongify(self);
            [self.sendCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)self.timeInterval--] forState:UIControlStateNormal];
            if (self.timeInterval < 0) {
                self.timer.fireDate = [NSDate distantFuture];
                self.timeInterval = 60;
                [self setButtonSendingStatus:NO];
            }
        } repeats:YES];
        _timer.fireDate = [NSDate distantFuture];
        
        {
            [_accountField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(kWidth(55));
                make.size.mas_equalTo(CGSizeMake(kWidth(690), kWidth(97)));
            }];
            
            [_sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_accountField);
                make.right.equalTo(_accountField.mas_right).offset(-kWidth(45));
                make.size.mas_equalTo(CGSizeMake(kWidth(157), kWidth(58)));
            }];
            
            [_codeField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_accountField.mas_bottom).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(690), kWidth(97)));
            }];
            
            [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_codeField.mas_bottom).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(690), kWidth(97)));
            }];

            [_nickField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_passwordField.mas_bottom).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(690), kWidth(97)));
            }];
        }
    }
    return self;
}

- (void)setButtonSendingStatus:(BOOL)isSend {
    //已发送
    if (isSend) {
        _sendCodeButton.userInteractionEnabled = NO;
        _sendCodeButton.backgroundColor = kColor(@"#efefef");
        _timer.fireDate = [NSDate distantPast];
    } else {
        _sendCodeButton.userInteractionEnabled = YES;
        [_sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendCodeButton.backgroundColor = kColor(@"#ff3366");
        _timer.fireDate = [NSDate distantFuture];
    }
}

- (NSString *)phoneNumber {
    return _accountField.text;
}

- (NSString *)verifyCode {
    return _codeField.text;
}

- (NSString *)password {
    return _passwordField.text;
}

- (NSString *)nickName {
    return _nickField.text;
}

@end
