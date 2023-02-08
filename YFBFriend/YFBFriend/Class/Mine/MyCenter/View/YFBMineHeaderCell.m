//
//  YFBMineHeaderCell.m
//  YFBFriend
//
//  Created by Liang on 2017/3/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMineHeaderCell.h"

@interface YFBMineHeaderCell ()
{
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    UILabel *_idLabel;
    UILabel *_inviteLabel;
}

@end

@implementation YFBMineHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_default_avatar_icon"]];
        _headerImageView.forceRoundCorner = YES;
        [self addSubview:_headerImageView];
        {
            [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).mas_offset(kWidth(20));
                make.top.mas_equalTo(self).mas_offset(kWidth(25));
                make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(150)));
            }];
        }
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = kColor(@"#333333");
        _nameLabel.font = [UIFont systemFontOfSize:kWidth(34)];
        [self addSubview:_nameLabel];
        {
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_headerImageView.mas_right).mas_offset(kWidth(20));
                make.top.mas_equalTo(self).mas_offset(kWidth(62));
                make.height.mas_equalTo(kWidth(34));
            }];
        }
        
        _idLabel = [[UILabel alloc] init];
        _idLabel.textColor = kColor(@"#999999");
        _idLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [self addSubview:_idLabel];
        {
            [_idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_nameLabel);
                make.left.mas_equalTo(_nameLabel.mas_right).mas_offset(kWidth(16));
                make.height.mas_equalTo(kWidth(30));
            }];
        }
        
        _inviteLabel = [[UILabel alloc] init];
        _inviteLabel.backgroundColor = kColor(@"#fafafa");
        _inviteLabel.textColor = kColor(@"#85b6fb");
        _inviteLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _inviteLabel.layer.cornerRadius = kWidth(30);
        _inviteLabel.clipsToBounds = YES;
        [self addSubview:_inviteLabel];
        {
            [_inviteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(_headerImageView);
                make.left.mas_equalTo(_nameLabel);
                make.size.mas_equalTo(CGSizeMake(kWidth(410), kWidth(60)));
            }];
        }
        //复制btn
        UIButton *inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [inviteBtn setBackgroundImage:[UIImage imageNamed:@"mine_copy_icon"] forState:UIControlStateNormal];
        [inviteBtn setTitle:@"复制" forState:UIControlStateNormal];
        [inviteBtn setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        inviteBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [self addSubview:inviteBtn];
        {
            [inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.centerY.mas_equalTo(_inviteLabel);
                make.size.mas_equalTo(CGSizeMake(kWidth(100), kWidth(60)));
            }];
        }
        @weakify(self);
        [inviteBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            UIPasteboard *pad = [UIPasteboard generalPasteboard];
            [pad setString:self.invite];
            if (pad) {
                [[YFBHudManager manager] showHudWithText:@"复制成功"];
            }else {
                [[YFBHudManager manager] showHudWithText:@"复制失败"];
            }
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        UIView *bacView = [UIView new];
        bacView.backgroundColor = kColor(@"#eeeeee");
        [self addSubview:bacView];
        {
            [bacView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(self);
                make.height.mas_equalTo(kWidth(86));
            }];
        }
        
        UIButton *ktVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ktVipBtn.imageEdgeInsets = UIEdgeInsetsMake(-2, -9, 0, 0);
        ktVipBtn.backgroundColor = [UIColor whiteColor];
        [ktVipBtn setTitleColor:kColor(@"#666666") forState:UIControlStateNormal];
        [ktVipBtn setTitle:@"开通vip" forState:UIControlStateNormal];
        ktVipBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        [ktVipBtn setImage:[UIImage imageNamed:@"mine_kt_vip_icon"] forState:UIControlStateNormal];
        [bacView addSubview:ktVipBtn];
        {
            [ktVipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.mas_equalTo(bacView);
                make.top.mas_equalTo(bacView).mas_offset(kWidth(3));
                make.width.mas_equalTo(kScreenWidth/2. - kWidth(1.5));
            }];
        }
        [ktVipBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            QBSafelyCallBlock(self.ktVipAction,self);
        } forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *attestationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        attestationBtn.imageEdgeInsets = UIEdgeInsetsMake(-2, -9, 0, 0);
        attestationBtn.backgroundColor = [UIColor whiteColor];
        [attestationBtn setTitleColor:kColor(@"#666666") forState:UIControlStateNormal];
        [attestationBtn setTitle:@"手机认证" forState:UIControlStateNormal];
        attestationBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        [attestationBtn setImage:[UIImage imageNamed:@"mine_phone_attestation_icon"] forState:UIControlStateNormal];
        [bacView addSubview:attestationBtn];
        {
            [attestationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.mas_equalTo(bacView);
                make.top.mas_equalTo(bacView).mas_offset(kWidth(3));
                make.width.mas_equalTo(kScreenWidth/2. - kWidth(1.5));
            }];
        }
        [attestationBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            QBSafelyCallBlock(self.attestationAction,self);
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setName:(NSString *)name {
    _name = name;
    _nameLabel.text = name;
}

- (void)setHeaderImage:(NSString *)headerImage {
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImage] placeholderImage:[UIImage imageNamed:@"login_userImage"]];
}

- (void)setIdNumber:(NSString *)idNumber {
    _idNumber = idNumber;
    _idLabel.text = [NSString stringWithFormat:@"ID: %@",idNumber];
}

- (void)setInvite:(NSString *)invite {
    _invite = invite;
    _inviteLabel.text = [NSString stringWithFormat:@"   我的邀请码:  %@",invite];
}

@end
