//
//  JYRegisterPhoneNumberViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYRegisterPhoneNumberViewController.h"
#import "JYNextButton.h"
#import "JYRegisterUserModel.h"

@interface JYRegisterPhoneNumberViewController ()
{
    UILabel      *_descLabel;
    UITextField  *_phoneNumberField;
    UITextField  *_passwordField;
    JYNextButton *_endButton;
    UIButton     *_skipButton;
}
@property (nonatomic) JYRegisterUserModel *userModel;
@end

@implementation JYRegisterPhoneNumberViewController
QBDefineLazyPropertyInitialization(JYRegisterUserModel, userModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setMainTitleLabelAndDescTitleLabel];
    [self setPhoneNumberTextField];
    [self setPasswordField];
    [self setNextButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_phoneNumberField becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [_phoneNumberField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

//主副标题
- (void)setMainTitleLabelAndDescTitleLabel {
    UILabel *mainLabel = [[UILabel alloc] init];
    mainLabel.text = @"绑定你的手机号";
    mainLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    mainLabel.font = [UIFont boldSystemFontOfSize:kWidth(34)];
    mainLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:mainLabel];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.text = @"手机号仅用于登录和保护账号安全";
    _descLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _descLabel.font = [UIFont systemFontOfSize:kWidth(28)];
    _descLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_descLabel];
    
    {
        [mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(kWidth(20)+64);
            make.height.mas_equalTo(kWidth(34));
        }];
        
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(mainLabel.mas_bottom).offset(kWidth(20));
            make.height.mas_equalTo(kWidth(28));
        }];
    }
}

- (void)setPhoneNumberTextField {
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"请输入您的手机号"
                                                                              attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],
                                                                                           NSFontAttributeName:[UIFont systemFontOfSize:kWidth(30)]}];
    
    _phoneNumberField = [[UITextField alloc] init];
    _phoneNumberField.attributedPlaceholder = attri;
    _phoneNumberField.font = [UIFont systemFontOfSize:kWidth(30)];
    _phoneNumberField.tintColor = [UIColor colorWithHexString:@"#E147A5"];
    _phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneNumberField];
    
    UIImageView *lineImgV = [[UIImageView alloc] init];
    lineImgV.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    [self.view addSubview:lineImgV];
    
    {
        [_phoneNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_descLabel.mas_bottom).offset(kWidth(120));
            make.size.mas_equalTo(CGSizeMake(kScreenWidth * 0.8, kWidth(88)));
        }];
        
        [lineImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_phoneNumberField.mas_bottom).offset(kWidth(1));
            make.size.mas_equalTo(CGSizeMake(kScreenWidth*0.8, 1));
        }];
    }
}

- (void)setPasswordField {
    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:@"请输入密码"
                                                                              attributes:@{NSForegroundColorAttributeName:kColor(@"#999999"),
                                                                                           NSFontAttributeName:[UIFont systemFontOfSize:kWidth(30)]}];
    
    _passwordField = [[UITextField alloc] init];
    _passwordField.attributedPlaceholder = attri;
    _passwordField.font = [UIFont systemFontOfSize:kWidth(30)];
    _passwordField.tintColor = [UIColor colorWithHexString:@"#E147A5"];
    [self.view addSubview:_passwordField];
    
    UIImageView *lineImgV = [[UIImageView alloc] init];
    lineImgV.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    [self.view addSubview:lineImgV];
    
    {
        [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_phoneNumberField.mas_bottom).offset(kWidth(10));
            make.size.mas_equalTo(CGSizeMake(kScreenWidth * 0.8, kWidth(88)));
        }];
        
        [lineImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_passwordField.mas_bottom).offset(kWidth(1));
            make.size.mas_equalTo(CGSizeMake(kScreenWidth*0.8, 1));
        }];
    }
}

- (void)setNextButton {
    @weakify(self);
    _endButton = [[JYNextButton alloc] initWithTitle:@"完成" action:^{
        @strongify(self);
        //验证并跳转到主界面
        if ([self checkFieldContent]) {
            [JYUser currentUser].account = self->_phoneNumberField.text;
            [JYUser currentUser].password = self->_passwordField.text;
            
            [self registerUserInfo];
        }
    }];
    [_endButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.view addSubview:_endButton];
    
    _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:@"跳过此步骤，以后再考虑"
                                                                attributes:@{NSForegroundColorAttributeName:kColor(@"#E147A5"),
                                                                             NSFontAttributeName:[UIFont systemFontOfSize:kWidth(30)],
                                                                             NSUnderlineStyleAttributeName:@(1)}];
    [_skipButton setAttributedTitle:attri forState:UIControlStateNormal];
    [self.view addSubview:_skipButton];
    
    [_skipButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self registerUserInfo];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotificationName object:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [_endButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_passwordField.mas_bottom).offset(kWidth(60));
            make.size.mas_equalTo(CGSizeMake(kWidth(650), kWidth(88)));
        }];
        
        [_skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_endButton.mas_bottom).offset(kWidth(44));
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, kWidth(30)));
        }];
    }
}

- (void)registerUserInfo {
    [self.userModel registerUserWithUserInfo:[JYUser currentUser] completionHandler:^(BOOL success, id obj) {
        if (success) {
            NSString *objStr = obj;
            if (!obj ||  objStr.length == 0) {
                return ;
            }
            [JYUser currentUser].userId = obj;
            [JYUtil setRegisteredWithUserId:obj];
            [[JYUser currentUser] saveOrUpdate];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotificationName object:nil];
        }
    }];
}

//检查用户输入的内容
- (BOOL)checkFieldContent {
    BOOL isTrue = YES;;
    
    if (_phoneNumberField.text.length != 11) {
        [[JYHudManager manager] showHudWithText:@"号码格式错误！"];
        isTrue = NO;
    } else {
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:_phoneNumberField.text];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:_phoneNumberField.text];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:_phoneNumberField.text];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            if (_passwordField.text.length < 6) {
                [[JYHudManager manager] showHudWithText:@"密码太短了！"];
                isTrue = NO;
            }
        } else {
            [[JYHudManager manager] showHudWithText:@"号码格式错误！"];
            isTrue = NO;
        }
    }
    
    return isTrue;
}


@end
