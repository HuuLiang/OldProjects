//
//  SADetailFooterView.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/7.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SADetailFooterView.h"

@interface SADetailFooterView ()
@property (nonatomic) UILabel *shareRuleLabel;
@property (nonatomic) UIImageView *shareRuleImgV;
@property (nonatomic) UIButton *shareButton;
@end

@implementation SADetailFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = kColor(@"#FAFAFA");
        self.layer.borderColor = kColor(@"#efefef").CGColor;
        
        self.shareRuleLabel = [[UILabel alloc] init];
        _shareRuleLabel.text = @"赚钱转发规则";
        _shareRuleLabel.textColor = kColor(@"#666666");
        _shareRuleLabel.font = kFont(14);
        _shareRuleLabel.userInteractionEnabled = YES;
        [self addSubview:_shareRuleLabel];
        
        self.shareRuleImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_into"]];
        [self addSubview:_shareRuleImgV];
        
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setTitle:@"赚钱转发" forState:UIControlStateNormal];
        [_shareButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        _shareButton.titleLabel.font = kFont(14);
        _shareButton.backgroundColor = kColor(@"#FF3366");
        _shareButton.layer.cornerRadius = kWidth(32);
        [self addSubview:_shareButton];
        
        @weakify(self);
        [_shareRuleLabel bk_whenTapped:^{
            @strongify(self);
            if (self.ruleAction) {
                self.ruleAction();
            }
        }];
        
        [_shareButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.shareAction) {
                self.shareAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        {
            [_shareRuleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(kWidth(52));
                make.height.mas_equalTo(_shareRuleLabel.font.lineHeight);
            }];
            
            [_shareRuleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_shareRuleLabel.mas_right).offset(kWidth(6));
                make.size.mas_equalTo(CGSizeMake(kWidth(24), kWidth(24)));
            }];
            
            [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self.mas_right).offset(-kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(180), kWidth(64)));
            }];
        }
    }
    return self;
}
@end
