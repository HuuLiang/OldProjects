//
//  JYRegisterNickNameViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYRegisterNickNameViewController.h"
#import "JYNextButton.h"
#import "JYRegisterDetailViewController.h"

@interface JYRegisterNickNameViewController ()
{
    UITextField  *_nickNameTextField;
    UILabel      *_descLabel;
    JYNextButton *_nextButton;
}
@end

@implementation JYRegisterNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self setMainTitleLabelAndDescTitleLabel];
    [self setNickNameTextField];
    [self setNextButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_nickNameTextField becomeFirstResponder];
}

//主副标题
- (void)setMainTitleLabelAndDescTitleLabel {
    UILabel *mainLabel = [[UILabel alloc] init];
    mainLabel.text = @"填写昵称";
    mainLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    mainLabel.font = [UIFont boldSystemFontOfSize:kWidth(34)];
    mainLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:mainLabel];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.text = @"好的昵称能让别人更快的接受你";
    _descLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _descLabel.font = [UIFont systemFontOfSize:kWidth(28)];
    _descLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_descLabel];
    
    {
        [mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(64+kWidth(20));
            make.height.mas_equalTo(kWidth(34));
        }];
        
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(mainLabel.mas_bottom).offset(kWidth(20));
            make.height.mas_equalTo(kWidth(28));
        }];
    }
}

- (void)setNickNameTextField {
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"请输入昵称"
                                                                              attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],
                                                                                           NSFontAttributeName:[UIFont systemFontOfSize:kWidth(30)]}];
    
    _nickNameTextField = [[UITextField alloc] init];
    _nickNameTextField.attributedPlaceholder = attri;
    _nickNameTextField.font = [UIFont systemFontOfSize:kWidth(30)];
    _nickNameTextField.tintColor = [UIColor colorWithHexString:@"#E147A5"];
    [self.view addSubview:_nickNameTextField];

    UIImageView *lineImgV = [[UIImageView alloc] init];
    lineImgV.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    [self.view addSubview:lineImgV];
    
    {
        [_nickNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_descLabel.mas_bottom).offset(kWidth(120));
            make.size.mas_equalTo(CGSizeMake(kScreenWidth * 0.8, kWidth(88)));
        }];
        
        [lineImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_nickNameTextField.mas_bottom).offset(kWidth(1));
            make.size.mas_equalTo(CGSizeMake(kScreenWidth*0.8, 1));
        }];
    }
}

- (void)setNextButton {
    @weakify(self);
    _nextButton = [[JYNextButton alloc] initWithTitle:@"下一步" action:^{
        @strongify(self);
        //下一步跳转到注册个人信息页面
        if (_nickNameTextField.text.length < 2) {
            [[JYHudManager manager] showHudWithText:@"昵称太短啦!"];
            return ;
        }
        [JYUser currentUser].nickName = _nickNameTextField.text;
        JYRegisterDetailViewController *registerVC = [[JYRegisterDetailViewController alloc] initWithTitle:@"注册"];
        [self.navigationController pushViewController:registerVC animated:YES];
    }];
    [_nextButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.view addSubview:_nextButton];
    {
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_nickNameTextField.mas_bottom).offset(kWidth(60));
            make.size.mas_equalTo(CGSizeMake(kWidth(650), kWidth(88)));
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [_nickNameTextField resignFirstResponder];
}

@end
