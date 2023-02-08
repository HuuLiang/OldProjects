//
//  SALoginInfoView.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SALoginInfoView.h"
#import "SATextField.h"

@interface SALoginInfoView ()
@property (nonatomic) SATextField *accountField;
@property (nonatomic) SATextField *passwordField;
@end


@implementation SALoginInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [kColor(@"#ffffff") colorWithAlphaComponent:0.85];
        
        self.accountField = [[SATextField alloc] initWithTitle:@"账号" placeholder:@"请输入你的手机号码"];
//        _accountField.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_accountField];
        
        self.passwordField = [[SATextField alloc] initWithTitle:@"密码" placeholder:@"******"];
        [self addSubview:_passwordField];
        
        {
            [_accountField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(kWidth(55));
                make.size.mas_equalTo(CGSizeMake(kWidth(690), kWidth(97)));
            }];
            
            [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_accountField.mas_bottom).offset(kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(690), kWidth(97)));
            }];
        }
        
    }
    return self;
}


- (NSString *)phoneNumber {
    return _accountField.text;
}

- (NSString *)password {
    return _passwordField.text;
}


@end
