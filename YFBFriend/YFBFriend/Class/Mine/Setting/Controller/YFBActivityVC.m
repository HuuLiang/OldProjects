//
//  YFBActivityVC.m
//  YFBFriend
//
//  Created by Liang on 2017/3/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBActivityVC.h"

@interface YFBActivityVC ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *descLabel;
@end

@implementation YFBActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#efefef");
    
    [self configTitleLabel];
    [self configDescLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"活动详情介绍";
    _titleLabel.font = kFont(17);
    _titleLabel.textColor = kColor(@"#333333");
    [self.view addSubview:_titleLabel];
    
    {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(kWidth(20));
            make.top.equalTo(self.view).offset(kWidth(30));
            make.height.mas_equalTo(kWidth(48));
        }];
    }
}

- (void)configDescLabel {
    self.descLabel = [[UILabel alloc] init];
    _descLabel.backgroundColor = [UIColor clearColor];
    _descLabel.textColor = kColor(@"#666666");
    _descLabel.font = kFont(14);
    _descLabel.numberOfLines = 0;
    _descLabel.text = @"1.购买活动套餐，即可获得1次抽取100元话费的机会，充值30天后方可抽奖，数量有限，送完即止。\n2.抽奖入口：充值30天后，前往页面“送话费处”进行抽奖。\n3.未抽到话费的用户，可免费获得相关特权，由系统自动帮您开通。\n4.本次活动最终解释权归本软件所有。";
    [self.view addSubview:_descLabel];
    
    {
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(kWidth(20));
            make.right.equalTo(self.view).offset(-kWidth(20));
            make.top.equalTo(_titleLabel.mas_bottom).offset(kWidth(70));
        }];
    }
}

@end
