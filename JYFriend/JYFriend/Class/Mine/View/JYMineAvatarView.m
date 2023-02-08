//
//  JYMineAvatarView.m
//  JYFriend
//
//  Created by Liang on 2016/12/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMineAvatarView.h"
#import "JYMineAvatarButton.h"

@interface JYMineAvatarView ()
{
    UIImageView        *_bgImgV;
    UIButton           *_followBtn;
    UIButton           *_fansBtn;
    UIButton           *_userBtn;
    UILabel            *_nickNameLabel;
    UILabel            *_signatureLabel;
}
@end

@implementation JYMineAvatarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        @weakify(self);
        
        _bgImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_background.jpg"]];
        _bgImgV.userInteractionEnabled = YES;
        [self addSubview:_bgImgV];
        
        _userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _userBtn.layer.cornerRadius = kWidth(84);
        _userBtn.layer.borderWidth = kWidth(5);
        _userBtn.layer.borderColor = [kColor(@"#ffffff") colorWithAlphaComponent:0.42].CGColor;
//        _userBtn.layer.masksToBounds = YES;
        _userBtn.forceRoundCorner = YES;        
        [_userBtn setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[JYUser currentUser].userImgKey] forState:UIControlStateNormal];
        [self addSubview:_userBtn];
        [_userBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.usersTypeAction) {
                self.usersTypeAction(@(JYMineUsersTypeHeader));
            }
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _followBtn.titleLabel.numberOfLines = 2;
        _followBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_followBtn setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        _followBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [self addSubview:_followBtn];
        
        [_followBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.usersTypeAction) {
                self.usersTypeAction(@(JYMineUsersTypeFollow));
            }
        } forControlEvents:UIControlEventTouchUpInside];


        _fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fansBtn.titleLabel.numberOfLines = 2;
        _fansBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_fansBtn setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        _fansBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [self addSubview:_fansBtn];
        
        [_fansBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.usersTypeAction) {
                self.usersTypeAction(@(JYMineUsersTypeFans));
            }
        } forControlEvents:UIControlEventTouchUpInside];

        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textColor = kColor(@"#ffffff");
        _nickNameLabel.font = [UIFont systemFontOfSize:kWidth(34)];
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nickNameLabel];
//
        _signatureLabel = [[UILabel alloc] init];
        _signatureLabel.textColor = kColor(@"#ffffff");
        _signatureLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _signatureLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_signatureLabel];
        
        {
            [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [_userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(kScreenWidth*53/375);
                make.size.mas_equalTo(CGSizeMake(kWidth(140), kWidth(140)));
            }];
            
            [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_userBtn);
                make.right.equalTo(_userBtn.mas_left).offset(-kWidth(44));
                make.size.mas_equalTo(CGSizeMake(kWidth(60), kWidth(70)));
            }];
//
            [_fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_userBtn);
                make.left.equalTo(_userBtn.mas_right).offset(kWidth(44));
                make.size.mas_equalTo(CGSizeMake(kWidth(60), kWidth(70)));
            }];
//
            [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(_userBtn.mas_bottom).offset(kWidth(40));
                make.height.mas_equalTo(kWidth(32));
            }];
//
            [_signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(_nickNameLabel.mas_bottom).offset(kWidth(18));
                make.height.mas_equalTo(kWidth(28));
            }];
        }
    }
    return self;
}

- (void)setUserImg:(UIImage *)userImg {
    _userImg = userImg;
    [_userBtn setImage:userImg forState:UIControlStateNormal];
}

- (void)setFollow:(NSString *)follow {
    [_followBtn setTitle:[NSString stringWithFormat:@"%@\n关注",follow] forState:UIControlStateNormal];
}

- (void)setFans:(NSString *)fans {
    [_fansBtn setTitle:[NSString stringWithFormat:@"%@\n粉丝",fans] forState:UIControlStateNormal];
}

- (void)setNickName:(NSString *)nickName {
    _nickNameLabel.text = nickName;
}

- (void)setSignature:(NSString *)signature {
    _signatureLabel.text = signature;
}

@end
