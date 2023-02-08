//
//  YFBUserLoginVC.m
//  YFBFriend
//
//  Created by Liang on 2017/3/9.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBUserLoginVC.h"
#import "YFBRegisterFirstVC.h"
#import "YFBAccountManager.h"
#import "YFBTextField.h"
#import "YFBTabBarController.h"

static NSString *const kYFBAccountCacheCellReusableIdentifier = @"kYFBAccountCacheCellReusableIdentifier";

@interface YFBUserLoginVC () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) YFBTextField   *accountField;
@property (nonatomic,strong) YFBTextField   *passwordField;
@property (nonatomic,strong) UIButton       *chooseButton;
@property (nonatomic,strong) UIButton       *loginButton;
@property (nonatomic,strong) UIButton       *registerButton;
@property (nonatomic,strong) UITableView    *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation YFBUserLoginVC
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColor(@"#efefef");
    
    [self configAccountAndPassWordField];
    [self configLoginButton];
    [self configRegisterButton];
    [self configAccountCacheTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configAccountAndPassWordField {
    self.accountField = [[YFBTextField alloc] init];
    _accountField.backgroundColor = kColor(@"#ffffff");
    _accountField.delegate = self;
    _accountField.placeholder = @"账号";
    [self.view addSubview:_accountField];
    
    self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _chooseButton.backgroundColor = [UIColor clearColor];
    [_chooseButton setImage:[UIImage imageNamed:@"login_choose"] forState:UIControlStateNormal];
    [_chooseButton setImage:[UIImage imageNamed:@"login_choose"] forState:UIControlStateSelected];
    [self.view addSubview:_chooseButton];
    
    @weakify(self);
    [_chooseButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self setAccountCacheTableViewHidden:self->_chooseButton.selected];
        self->_chooseButton.selected = !self->_chooseButton.selected;
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.passwordField = [[YFBTextField alloc] init];
    _passwordField.backgroundColor = kColor(@"#ffffff");
    _passwordField.delegate = self;
    _passwordField.placeholder = @"密码";
    [self.view addSubview:_passwordField];
    
    {
        [_accountField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.top.equalTo(self.view).offset(kWidth(180));
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, kWidth(98)));
        }];
        
        [_chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_accountField);
            make.right.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kWidth(60), kWidth(98)));
        }];
        
        [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(_accountField.mas_bottom).offset(kWidth(2));
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, kWidth(98)));
        }];
    }
}

- (void)configLoginButton {
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
    _loginButton.backgroundColor = kColor(@"#8558D0");
    _loginButton.layer.cornerRadius = kWidth(6);
    _loginButton.layer.masksToBounds = YES;
    [self.view addSubview:_loginButton];
    
    {
        [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_passwordField.mas_bottom).offset(kWidth(106));
            make.size.mas_equalTo(CGSizeMake(kWidth(630), kWidth(80)));
        }];
    }
    
    @weakify(self);
    [_loginButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [[YFBAccountManager manager] loginUserInfoWithUserId:_accountField.text password:_passwordField.text handler:^(BOOL success) {
            if (success) {
                YFBTabBarController *tabbarController = [[YFBTabBarController alloc] init];
                [self presentViewController:tabbarController animated:YES completion:nil];
            } else {
                [[YFBHudManager manager] showHudWithText:@"错误"];
            }
        }];
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)configRegisterButton {
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerButton setTitle:@"免费注册" forState:UIControlStateNormal];
    [_registerButton setTitleColor:kColor(@"#8558D0") forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
    [self.view addSubview:_registerButton];
    
    @weakify(self);
    [_registerButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [YFBUser currentUser].loginType = YFBLoginTypeDefine;
        YFBRegisterFirstVC *registerVC = [[YFBRegisterFirstVC alloc] initWithTitle:@"填写用户信息"];
        [self.navigationController pushViewController:registerVC animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-kWidth(130));
            make.size.mas_equalTo(CGSizeMake(kWidth(130), kWidth(62)));
        }];
    }
}

- (void)configAccountCacheTableView {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:[YFBUser findAll]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColor(@"#efefef");
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kYFBAccountCacheCellReusableIdentifier];
    _tableView.layer.borderWidth = 1;
    _tableView.layer.borderColor = kColor(@"#000000").CGColor;
    [self.view addSubview:_tableView];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:view];
    
    _tableView.alpha = 0;
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_accountField.mas_bottom).offset(kWidth(1));
            make.size.mas_equalTo(CGSizeMake(kScreenWidth*0.7, kWidth(400)));
        }];
    }
}

- (void)setAccountCacheTableViewHidden:(BOOL)hidden {
    if (hidden) {
        [self->_tableView hiddenWithPopAnimation];
    } else {
        [self->_tableView showWithPopAnimation];
        [self->_tableView reloadData];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setAccountCacheTableViewHidden:YES];
    [_accountField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBAccountCacheCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        YFBUser *user = self.dataSource[indexPath.row];
        cell.textLabel.text = user.userId;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(60);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataSource.count) {
        YFBUser *user = self.dataSource[indexPath.row];
        _accountField.text = user.userId;
        _passwordField.text = user.password;
        [self setAccountCacheTableViewHidden:YES];
    }
}

@end
