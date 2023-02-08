//
//  YFBDiamondExplainController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDiamondExplainController.h"

@interface YFBDiamondExplainController ()

@end

@implementation YFBDiamondExplainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"钻石说明";
    [self creatDiamondUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatDiamondUI {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = kFont(17);
    titleLabel.textColor = kColor(@"#333333");
    titleLabel.text = @"钻石说明";
    [self.view addSubview:titleLabel];
    {
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(kWidth(50));
        make.top.mas_equalTo(self.view).mas_offset(kWidth(60));
        make.size.mas_equalTo(CGSizeMake(kWidth(kScreenWidth *0.5), kWidth(35)));
    }];
    }
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.textColor = kColor(@"#999999");
    subTitleLabel.font = kFont(14);
    subTitleLabel.numberOfLines = 0;
    [self.view addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(kWidth(40));
        make.left.mas_equalTo(titleLabel);
        make.right.mas_equalTo(self.view).mas_offset(kWidth(-30));
    }];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"1、钻石可用于赠送虚拟物品;\n2、等价钻石礼物直接纳入我的个人钱包;\n3、活动最终解释权归本APP所有;\n4.500钻石和1100钻石（冲100送100话费)\n5.充值钻石聊天80钻石/条信息，钻石可购买礼物"];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = kWidth(18);
    [attributeStr setAttributes:@{NSParagraphStyleAttributeName : style} range:NSMakeRange(0, attributeStr.length)];
    subTitleLabel.attributedText = attributeStr.copy;
}

@end
