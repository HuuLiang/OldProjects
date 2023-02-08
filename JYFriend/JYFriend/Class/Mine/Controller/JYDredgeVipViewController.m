//
//  JYDredgeVipViewController.m
//  JYFriend
//
//  Created by ylz on 2016/12/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYDredgeVipViewController.h"

@interface JYDredgeVipViewController ()
{
    UILabel *_expireLabel;
}
@end

@implementation JYDredgeVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    if ([JYUtil isVip]) {
        UIView *vipTimeView = [self addVipTimeView];
        [self.view addSubview:vipTimeView];
        {
        [vipTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view).mas_offset(kWidth(20));
            make.height.mas_equalTo(kWidth(120));
        }];
        }
    }else {
    [self creatTitleLabel];
    [self creatDredgeVipBtn];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_expireLabel) {
        _expireLabel.text = [NSString stringWithFormat:@"您的会员截止日期: %@",[JYUtil timeStringFromDate:[JYUtil expireDateTime] WithDateFormat:kDateFormatShort]];
    }
}

- (void)creatTitleLabel {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.font = [UIFont systemFontOfSize:kWidth(32)];
    NSString *text = @"您还不是会员，成为会员可以对心仪的用户无限制发送消息，查看相册、微信、QQ、手机号等私密资料。";
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:6.];
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributeStr.length)];
    titleLabel.attributedText = attributeStr;
    titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];
    {
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.view).mas_offset(kWidth(80.));
        make.right.mas_equalTo(self.view).mas_offset(kWidth(-80));
    }];
    }
}

- (void)creatDredgeVipBtn {
    UIButton *vipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    vipBtn.backgroundColor = [UIColor colorWithHexString:@"#E147A5"];
    vipBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(32)];
    [vipBtn setTitle:@"开通会员" forState:UIControlStateNormal];
    [vipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    vipBtn.layer.cornerRadius = 5.;
    vipBtn.clipsToBounds = YES;
    [self.view addSubview:vipBtn];
    {
    [vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kWidth(88.));
        make.left.mas_equalTo(self.view).mas_offset(kWidth(80));
        make.right.mas_equalTo(self.view).mas_offset(kWidth(-80));
        make.centerY.mas_equalTo(self.view).mas_offset(kWidth(-200));
    }];
    }
    @weakify(self);
    [vipBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self presentPayViewController];
    } forControlEvents:UIControlEventTouchUpInside];

}


- (UIView *)addVipTimeView {
    UIView *view  = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *ktVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ktVipBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
    [ktVipBtn setTitle:@"续费" forState:UIControlStateNormal];
    [ktVipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ktVipBtn.layer.cornerRadius = 5.;
    ktVipBtn.clipsToBounds = YES;
    [ktVipBtn setBackgroundColor:kColor(@"#E147a5")];
    [view addSubview:ktVipBtn];
    {
    [ktVipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view);
        make.right.mas_equalTo(view).mas_offset(kWidth(-30));
        make.size.mas_equalTo(CGSizeMake(kWidth(140), kWidth(70)));
    }];
    }
    @weakify(self);
    [ktVipBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self presentPayViewController];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    _expireLabel = [[UILabel alloc] init];
    _expireLabel.textColor = kColor(@"#666666");
    _expireLabel.font = [UIFont systemFontOfSize:kWidth(30)];
    _expireLabel.text = [NSString stringWithFormat:@"您的会员截止日期: %@",[JYUtil timeStringFromDate:[JYUtil expireDateTime] WithDateFormat:kDateFormatShort]];
    [view addSubview:_expireLabel];
    {
        [_expireLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view);
            make.left.mas_equalTo(view).mas_offset(kWidth(30));
            make.right.mas_equalTo(ktVipBtn.mas_left).mas_offset(kWidth(-30));
        }];
    }
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
