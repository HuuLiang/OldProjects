//
//  YFBRegisterFirstVC.m
//  YFBFriend
//
//  Created by Liang on 2017/3/9.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBRegisterFirstVC.h"
#import "YFBTextField.h"
//#import "YFBRegisterSecondVC.h"
#import "YFBAccountManager.h"
#import "AppDelegate.h"

@interface YFBRegisterFirstVC () <UITextFieldDelegate>
@property (nonatomic,strong) YFBTextField   *accountField;
@property (nonatomic,strong) YFBTextField   *passwordField;
@property (nonatomic,strong) UIButton       *nextButton;
@end

@implementation YFBRegisterFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#efefef");
    
    [self configAccountAndPassWordField];
    [self configNextButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([YFBUser currentUser].nickName.length > 0) {
        _accountField.text = [YFBUser currentUser].nickName;
    }
    
    if ([YFBUser currentUser].age > 0) {
        _passwordField.text = [NSString stringWithFormat:@"%ld",(long)[YFBUser currentUser].age];
    }
}

- (void)configAccountAndPassWordField {
    self.accountField = [[YFBTextField alloc] init];
    _accountField.backgroundColor = kColor(@"#efefef");
    _accountField.delegate = self;
    _accountField.placeholder = @"请输入您的昵称";
    _accountField.showUnderLine = YES;
    [self.view addSubview:_accountField];
    
    self.passwordField = [[YFBTextField alloc] init];
    _passwordField.backgroundColor = kColor(@"#efefef");
    _passwordField.delegate = self;
    _passwordField.placeholder = @"年龄";
    _passwordField.keyboardType = UIKeyboardTypeNumberPad;
    _passwordField.showUnderLine = YES;
    [self.view addSubview:_passwordField];
    
    {
        [_accountField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.top.equalTo(self.view).offset(kWidth(180));
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, kWidth(98)));
        }];
        
        [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(_accountField.mas_bottom).offset(kWidth(2));
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, kWidth(98)));
        }];
    }
}

- (void)configNextButton {
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setTitle:@"完成" forState:UIControlStateNormal];
    [_nextButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
    _nextButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
    _nextButton.backgroundColor = kColor(@"#8558D0");
    [self.view addSubview:_nextButton];
    
    @weakify(self);
    [_nextButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        if ([self checkUserInfo]) {
//            YFBRegisterSecondVC *regiterVC = [[YFBRegisterSecondVC alloc] initWithTitle:@"完善个人资料"];
//            [self.navigationController pushViewController:regiterVC animated:YES];
            [[YFBAccountManager manager] registerUserWithUserInfo:[YFBUser currentUser] handler:^(BOOL success) {
                @strongify(self);
                if (success) {
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    if (self.presentedViewController == nil) {
                        [self presentViewController:appDelegate.contentViewController animated:YES completion:^ {
                            [UIApplication sharedApplication].keyWindow.rootViewController = appDelegate.contentViewController;
                            [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
                        }];
                    }
                } else {
                    [[YFBHudManager manager] showHudWithText:@"注册失败"];
                }
            }];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_passwordField.mas_bottom).offset(kWidth(106));
            make.size.mas_equalTo(CGSizeMake(kWidth(630), kWidth(80)));
        }];
    }
}

- (BOOL)checkUserInfo {
    if (_accountField.text.length < 2) {
        [[YFBHudManager manager] showHudWithText:@"昵称太短啦"];
        return NO;
    }
    
    if ([_passwordField.text integerValue] < 18 ||  [_passwordField.text integerValue] > 60){
        [[YFBHudManager manager] showHudWithText:@"总感觉哪里不对"];
        return NO;
    }
    
    [YFBUser currentUser].nickName = _accountField.text;
    [YFBUser currentUser].age = [_passwordField.text integerValue];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [_accountField resignFirstResponder];
    [_passwordField resignFirstResponder];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
