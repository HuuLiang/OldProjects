//
//  YFBPasswordVC.m
//  YFBFriend
//
//  Created by Liang on 2017/3/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBPasswordVC.h"
#import "YFBPasswordView.h"
#import "YFBAccountManager.h"

static NSString *const kYFBUserInfoUpPasswordKeyName            = @"UP_PASSWORD";


@interface YFBPasswordVC () <YFBPasswordTextFieldDelegate>
@property (nonatomic,strong) UILabel *noticeLabel;
@property (nonatomic,strong) YFBPasswordView *originalView;
@property (nonatomic,strong) YFBPasswordView *createView;
@property (nonatomic,strong) YFBPasswordView *affirmView;
@property (nonatomic,strong) UIButton *completeButton;
@end

@implementation YFBPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#efefef");
    
    [self configNoticeLabel];
    [self configOriginalPassword];
    [self configCompleteButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkPassword {
    if (![_originalView.content isEqualToString:[YFBUser currentUser].password]) {
        [[YFBHudManager manager] showHudWithText:@"原始密码不正确"];
        return;
    }
    
    if (![_createView.content isEqualToString:_affirmView.content]) {
        [[YFBHudManager manager] showHudWithText:@"两次输入不一致"];
        return;
    }
    
    NSDictionary *params = @{@"originalPassword":_originalView.content,
                             @"password":_createView.content,
                             @"confirmPassword":_affirmView.content};
    @weakify(self);
    [[YFBAccountManager manager] updateUserInfoWithType:kYFBUserInfoUpPasswordKeyName content:params handler:^(BOOL success) {
        @strongify(self);
        if (success) {
            if (!self) {
                return ;
            }
            //更新密码
            [YFBUser currentUser].password = _createView.content;
            [[YFBUser currentUser] saveOrUpdateUserInfo];
            [[YFBHudManager manager] showHudWithText:@"密码修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

- (void)configNoticeLabel {
    self.noticeLabel = [[UILabel alloc] init];
    _noticeLabel.textColor = kColor(@"#999999");
    _noticeLabel.font = kFont(15);
    _noticeLabel.numberOfLines = 2;
    _noticeLabel.text = [NSString stringWithFormat:@"  您的ID是 %@\n  设置密码后，可以使用密码登录",[YFBUser currentUser].userId];
    [self.view addSubview:_noticeLabel];
    
    {
        [_noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.mas_equalTo(kWidth(146));
        }];
    }
}

- (void)configOriginalPassword {
    self.originalView = [[YFBPasswordView alloc] initWithTitle:@"原密码" placeholder:@"请输入您的密码"];
    [self.view addSubview:_originalView];
    
    self.createView = [[YFBPasswordView alloc] initWithTitle:@"新密码" placeholder:@"支持英文和数字，6至20位"];
    [self.view addSubview:_createView];

    self.affirmView = [[YFBPasswordView alloc] initWithTitle:@"确认密码" placeholder:@"再次输入密码"];
    _affirmView.delegate = self;
    [self.view addSubview:_affirmView];
    
    {
        [_originalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_noticeLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(kWidth(690), kWidth(88)));
        }];
        
        [_createView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_originalView.mas_bottom).offset(kWidth(20));
            make.size.mas_equalTo(CGSizeMake(kWidth(690), kWidth(88)));
        }];

        [_affirmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_createView.mas_bottom).offset(kWidth(20));
            make.size.mas_equalTo(CGSizeMake(kWidth(690), kWidth(88)));
        }];
    }
}

- (void)configCompleteButton {
    self.completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [_completeButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
    [_completeButton setBackgroundColor:kColor(@"#D8D8D8")];
    _completeButton.layer.cornerRadius = kWidth(6);
    _completeButton.layer.masksToBounds = YES;
    _completeButton.userInteractionEnabled = NO;
    [self.view addSubview:_completeButton];
    
    @weakify(self);
    [_completeButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self checkPassword];
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [_completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_affirmView.mas_bottom).offset(kWidth(40));
            make.size.mas_equalTo(CGSizeMake(kWidth(650), kWidth(88)));
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [_originalView resignFirstResponse];
    [_createView resignFirstResponse];
    [_affirmView resignFirstResponse];
}

#pragma mark - YFBPasswordDelegate

- (void)textFieldEditingContent:(NSString *)content {
    if (content.length >=6 && content.length <= 20 && self->_originalView.content.length >= 6 && self->_originalView.content.length <= 20 && self->_createView.content.length >= 6 && self->_createView.content.length <= 20) {
        _completeButton.userInteractionEnabled = YES;
        [_completeButton setBackgroundColor:kColor(@"#8458D0")];
    } else {
        _completeButton.userInteractionEnabled = NO;
        [_completeButton setBackgroundColor:kColor(@"#D8D8D8")];
    }
}

@end
