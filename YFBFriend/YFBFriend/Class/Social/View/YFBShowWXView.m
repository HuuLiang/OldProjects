//
//  YFBShowWXView.m
//  YFBFriend
//
//  Created by ZF on 2017/6/7.
//  Copyright © 2017年 ZF. All rights reserved.
//

#import "YFBShowWXView.h"

@interface YFBShowWXView ()
@property (nonatomic) UIImageView *userImgV;
@property (nonatomic) UILabel *nickLabel;
@property (nonatomic) UILabel *wxLabel;
@property (nonatomic) UILabel *descLabel;
@property (nonatomic) UIButton *confirmButton;
@end

@implementation YFBShowWXView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc] init];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = kColor(@"#ffffff");
        [self addSubview:backView];
        
        self.userImgV = [[UIImageView alloc] init];
        _userImgV.layer.cornerRadius = kWidth(55);
        _userImgV.layer.borderColor = kColor(@"#ffffff").CGColor;
        _userImgV.layer.borderWidth = 2;
        _userImgV.layer.masksToBounds = YES;
        [self addSubview:_userImgV];
        
        self.nickLabel = [[UILabel alloc] init];
        _nickLabel.textAlignment = NSTextAlignmentCenter;
        _nickLabel.font = kFont(14);
        _nickLabel.textColor = kColor(@"#333333");
        [backView addSubview:_nickLabel];
        
        self.wxLabel = [[UILabel alloc] init];
        _wxLabel.textAlignment = NSTextAlignmentCenter;
        _wxLabel.font = kFont(14);
        _wxLabel.textColor = kColor(@"#333333");
        [backView addSubview:_wxLabel];

        self.descLabel = [[UILabel alloc] init];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.font = kFont(12);
        _descLabel.textColor = kColor(@"#999999");
        _descLabel.text = @"加微信请备注你的昵称或者ID";
        [backView addSubview:_descLabel];

        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = kFont(14);
        _confirmButton.backgroundColor = kColor(@"#8458D0");
        [backView addSubview:_confirmButton];
        
        @weakify(self);
        [_confirmButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.hideAction) {
                self.hideAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        {
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.centerY.equalTo(self.mas_top);
                make.size.mas_equalTo(CGSizeMake(kWidth(116), kWidth(116)));
            }];
            
            [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(backView);
                make.top.equalTo(_userImgV.mas_bottom).offset(kWidth(8));
                make.height.mas_equalTo(_nickLabel.font.lineHeight);
            }];
            
            [_wxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(backView);
                make.top.equalTo(_nickLabel.mas_bottom).offset(kWidth(8));
                make.height.mas_equalTo(_wxLabel.font.lineHeight);
            }];
            
            [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(backView);
                make.height.mas_equalTo(kWidth(76));
            }];
            
            [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(backView);
                make.bottom.equalTo(_confirmButton.mas_top).offset(-kWidth(12));
                make.height.mas_equalTo(_descLabel.font.lineHeight);
            }];
        }
    }
    return self;
}


- (void)setUserImgUrl:(NSString *)userImgUrl {
    [_userImgV sd_setImageWithURL:[NSURL URLWithString:userImgUrl] placeholderImage:[UIImage imageNamed:@"login_userImage"]];
}

- (void)setNickName:(NSString *)nickName {
    _nickLabel.text = nickName;
}

- (void)setWeixin:(NSString *)weixin {
    _wxLabel.text = [NSString stringWithFormat:@"微信号：%@",weixin];
}

@end
