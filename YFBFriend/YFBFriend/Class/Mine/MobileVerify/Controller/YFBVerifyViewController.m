//
//  YFBPhoneVerifyViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBVerifyViewController.h"
#import "YFBPhoneVerifyManager.h"
#import "JYRegexUtil.h"

@interface YFBVerifyViewController ()
{
    UIImageView *_headerImageView;
    UITextField *_phoneField;
    UITextField *_verifyField;
    NSTimer *_timer;
}
@end

@implementation YFBVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"#ffffff");
    self.title = @"手机验证";
    [self creatHeaderImageView];
    [self creatSenderPhoneVerifyNumer];
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"确认" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        if (self->_verifyField.text.length != 4) {
            [[YFBHudManager manager] showHudWithText:@"请确认验证码是否输入正确"];

        }
        
        [[YFBPhoneVerifyManager manager] mobileVerifyWithVerifyCode:self->_verifyField.text handler:^(BOOL success) {
            if (success) {
                [[YFBHudManager manager] showHudWithText:@"验证成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timer invalidate];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_verifyField resignFirstResponder];
    [_phoneField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}

- (void)creatHeaderImageView {
    _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithResourcePath:@"phone_verify" ofType:@"jpg"]];
    [self.view addSubview:_headerImageView];
    {
        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self.view);
            make.height.mas_equalTo(kWidth(260));
        }];
    }
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 2;
    
    titleLabel.textColor = kColor(@"#333333");
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"可以直接用手机号登陆\n保护账号不被丢失"];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:kWidth(32)];
    //    style.alignment = NSTextAlignmentCenter;
    //    style.headIndent = 0.;
    //    [string addAttribute:NSParagraphStyleAttributeName  value:style range:NSMakeRange(0, string.length)];
    [string setAttributes:@{NSParagraphStyleAttributeName : style } range:NSMakeRange(0, string.length)];
    
    titleLabel.attributedText = string;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_headerImageView addSubview:titleLabel];
    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_headerImageView);
            make.right.mas_equalTo(_headerImageView).mas_offset(kWidth(-20));
            make.height.mas_equalTo(kScreenWidth *0.23);
            make.width.mas_equalTo(kScreenWidth *0.43);
        }];
    }
    
}

- (void)creatSenderPhoneVerifyNumer {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kColor(@"#333333");
    titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
    titleLabel.text = @"请输入手机号, 获取验证码";
    [self.view addSubview:titleLabel];
    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).mas_offset(kWidth(26));
            make.top.mas_equalTo(_headerImageView.mas_bottom).mas_offset(kWidth(22));
            make.right.mas_equalTo(self.view);
            make.height.mas_equalTo(kWidth(28));
        }];
    }
    
    _phoneField = [[UITextField alloc] init];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"  请输入手机号码"];
    [attributeStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kWidth(28)]} range:NSMakeRange(0, attributeStr.length)];
    _phoneField.attributedPlaceholder = attributeStr.copy;
    _phoneField.backgroundColor = kColor(@"#efefef");
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneField];
    {
        [_phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).mas_offset(kWidth(20));
            make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(kWidth(24));
            make.size.mas_equalTo(CGSizeMake(kWidth(440), kWidth(68)));
        }];
    }
    
    UIButton *senderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [senderBtn setBackgroundColor:kColor(@"#8458d0")];
    senderBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
    [senderBtn setTitle:@"免费获取验证码" forState:UIControlStateNormal];
    [senderBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [self.view addSubview:senderBtn];
    {
        [senderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_phoneField.mas_right).mas_offset(kWidth(20));
            make.right.mas_equalTo(self.view).mas_offset(kWidth(-20));
            make.centerY.height.mas_equalTo(_phoneField);
        }];
    }
    @weakify(self);
    [senderBtn bk_addEventHandler:^(UIButton* sender) {
        senderBtn.selected = YES;
        senderBtn.userInteractionEnabled = NO;
        __block NSInteger seconds = 60;
        NSString *phoneNumber = self->_phoneField.text;
        if ([JYRegexUtil isPhoneNumberWithString:phoneNumber]) {
            @strongify(self);
            self->_timer  = [NSTimer bk_scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
                if (seconds >0) {
                    [senderBtn setTitle:[NSString stringWithFormat:@"%zd秒后重新获取",--seconds] forState:UIControlStateNormal];
                }else {
                    senderBtn.selected = NO;
                    senderBtn.userInteractionEnabled = YES;
                    [senderBtn setTitle:@"免费获取验证码" forState:UIControlStateNormal];
                    seconds = 60;
                    [timer invalidate];
                }
            } repeats:YES];
            
            [[YFBPhoneVerifyManager manager] sendVerifyNumberWithMobileNumber:phoneNumber handler:^(BOOL success) {
                @strongify(self);
                if (success) {
                    if (!self) {
                        return ;
                    }
                    [YFBUser currentUser].phoneNumber = phoneNumber;
                    [[YFBUser currentUser] saveOrUpdate];
                }
            }];
        } else {
            [[YFBHudManager manager] showHudWithText:@"手机号输入有误"];
            return ;
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    _verifyField = [[UITextField alloc] init];
    NSMutableAttributedString *verifyStr = [[NSMutableAttributedString alloc] initWithString:@"  请输入短信中的验证码"];
    [verifyStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kWidth(28)]} range:NSMakeRange(0, verifyStr.length)];
    _verifyField.attributedPlaceholder = verifyStr.copy;
    _verifyField.backgroundColor = kColor(@"#efefef");
    _verifyField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_verifyField];
    {
        [_verifyField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).mas_offset(kWidth(20));
            make.right.mas_equalTo(self.view).mas_offset(kWidth(-20));
            make.height.mas_equalTo(_phoneField);
            make.top.mas_equalTo(_phoneField.mas_bottom).mas_offset(kWidth(20));
        }];
    }
}


@end
