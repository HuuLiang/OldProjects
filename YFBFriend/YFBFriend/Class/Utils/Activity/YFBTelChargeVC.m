//
//  YFBTelChargeVC.m
//  YFBFriend
//
//  Created by Liang on 2017/5/23.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBTelChargeVC.h"
#import "YFBTextField.h"
#import "JYRegexUtil.h"
#import "YFBActivityVC.h"

@interface YFBTelChargeVC () <UITextFieldDelegate>
@property (nonatomic) YFBTextField *teleNumField;
@property (nonatomic) UIButton *getChargeButton;

@property (nonatomic) UIView *noticeView;
@end

@implementation YFBTelChargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"领取话费";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kYFBShowChargeNotification object:nil];
        }];
    }];
    
    [self configGetChargeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [_teleNumField resignFirstResponder];
}

- (void)configGetChargeView {
    self.teleNumField = [[YFBTextField alloc] init];
    _teleNumField.delegate = self;
    _teleNumField.placeholder = @"请输入手机号码";
    _teleNumField.backgroundColor = kColor(@"#efefef");
    _teleNumField.keyboardType = UIKeyboardTypePhonePad;
    _teleNumField.layer.cornerRadius = kWidth(32);
    _teleNumField.layer.masksToBounds = YES;
    [self.view addSubview:_teleNumField];
    
    self.getChargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getChargeButton setTitle:@"领取话费" forState:UIControlStateNormal];
    [_getChargeButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
    _getChargeButton.titleLabel.font = kFont(14);
    _getChargeButton.layer.cornerRadius = 5;
    _getChargeButton.backgroundColor = kColor(@"#8458D0");
    [self.view addSubview:_getChargeButton];
    
    @weakify(self);
    [_getChargeButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        if ([YFBUtil isVip] || [YFBUser currentUser].diamondCount > 0) {
            [self popActivityView];
        } else {
            [self popVipNotice];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    {
        [_teleNumField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(kWidth(100));
            make.size.mas_equalTo(CGSizeMake(kWidth(390), kWidth(64)));
        }];
        
        [_getChargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_teleNumField.mas_bottom).offset(kWidth(104));
            make.size.mas_equalTo(CGSizeMake(kWidth(464), kWidth(70)));
        }];
    }
}

- (void)popActivityView {
    BOOL correctPhoneNum = [JYRegexUtil isPhoneNumberWithString:_teleNumField.text];
    if (correctPhoneNum) {
        [self.view beginLoading];
        [self configActivityNoticeView];
    } else {
        [[YFBHudManager manager] showHudWithText:@"号码输入错误，请重新输入"];
        _teleNumField.text = @"";
        [_teleNumField becomeFirstResponder];
    }
}

- (void)popVipNotice {
    [UIAlertView bk_showAlertViewWithTitle:@"您尚未购买任何反话费服务，无法参与领话费活动，开通vip，即可参与！"
                                   message:@""
                         cancelButtonTitle:@"再等等" otherButtonTitles:@[@"去开通"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                             if (buttonIndex == 1) {
                                 [self pushIntoPayVC];
                             }
                         }];
}



- (void)configActivityNoticeView {
    self.noticeView = [[UIView alloc] init];
    _noticeView.layer.cornerRadius = 5;
    _noticeView.backgroundColor = kColor(@"#ffffff");
    [self.view addSubview:_noticeView];
    
    UIImageView * cartoonImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_cartoon"]];
    [_noticeView addSubview:cartoonImgV];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"温馨提示";
    titleLabel.textColor = kColor(@"#333333");
    titleLabel.font =kFont(16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_noticeView addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = @"充值1天后可参加送话费抽奖活动，每个月有1次机会";
    subTitleLabel.textColor = kColor(@"#666666");
    subTitleLabel.font =kFont(13);
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.numberOfLines = 2;
    [_noticeView addSubview:subTitleLabel];
    
    
    UIButton *activityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [activityButton setTitle:@"活动相关" forState:UIControlStateNormal];
    [activityButton setTitleColor:kColor(@"#8458D0") forState:UIControlStateNormal];
    activityButton.titleLabel.font = kFont(15);
    [_noticeView addSubview:activityButton];
    @weakify(self);
    [activityButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        YFBActivityVC *activityVC = [[YFBActivityVC alloc] init];
        [self.navigationController pushViewController:activityVC animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"activity_close"] forState:UIControlStateNormal];
    [_noticeView addSubview:closeButton];
    [closeButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self.noticeView removeFromSuperview];
        self.noticeView = nil;
        [self.view endLoading];
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *lineV = [[UIImageView alloc] init];
    lineV.backgroundColor = kColor(@"#efefef");
    [_noticeView addSubview:lineV];
    
    {
        [_noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kWidth(590), kWidth(272)));
        }];
        
        [cartoonImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noticeView);
            make.bottom.equalTo(_noticeView.mas_top).offset(kWidth(16));
            make.size.mas_equalTo(CGSizeMake(kWidth(162), kWidth(142)));
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noticeView);
            make.top.equalTo(cartoonImgV.mas_bottom).offset(kWidth(20));
            make.height.mas_equalTo(titleLabel.font.lineHeight);
        }];
        
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noticeView);
            make.top.equalTo(titleLabel.mas_bottom).offset(kWidth(8));
            make.width.mas_equalTo(kWidth(542));
            make.height.mas_equalTo(subTitleLabel.font.lineHeight * 2 + 2 );
        }];
        
        [activityButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(_noticeView);
            make.size.mas_equalTo(CGSizeMake(kWidth(580), kWidth(80)));
        }];
        
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_noticeView.mas_right).offset(-kWidth(14));
            make.top.equalTo(_noticeView.mas_top).offset(kWidth(14));
            make.size.mas_equalTo(CGSizeMake(kWidth(32), kWidth(32)));
        }];
        
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(activityButton.mas_top).offset(-1);
            make.centerX.equalTo(_noticeView);
            make.size.mas_equalTo(CGSizeMake(kWidth(590), 1));
        }];

    }
    
}
@end
