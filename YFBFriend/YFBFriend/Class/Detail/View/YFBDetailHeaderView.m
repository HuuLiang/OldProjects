//
//  YFBDetailHeaderView.m
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDetailHeaderView.h"

@interface YFBDetailHeaderView ()
@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) UIImageView *userImageView;
@property (nonatomic,strong) UILabel     *nickNameLabel;
@property (nonatomic,strong) UILabel     *userIdLabel;
@property (nonatomic,strong) UILabel     *liveLabel;
@property (nonatomic,strong) UIButton    *distanceButton;
@property (nonatomic,strong) UIButton    *albumButton;
@property (nonatomic,strong) UIButton    *followButton;
@property (nonatomic,strong) UIButton    *contactButton;
@end

@implementation YFBDetailHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kColor(@"#efefef");
        
        self.backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_bg.jpg"]];
        [self addSubview:_backImageView];
        
        self.userImageView = [[UIImageView alloc] init];
        _userImageView.layer.cornerRadius = kWidth(100);
        _userImageView.layer.masksToBounds = YES;
        [_backImageView addSubview:_userImageView];
        
        self.nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textColor = kColor(@"#ffffff");
        _nickNameLabel.font = kFont(16);
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
        [_backImageView addSubview:_nickNameLabel];
        
        self.userIdLabel = [[UILabel alloc] init];
        _userIdLabel.textColor = kColor(@"#ffffff");
        _userIdLabel.font = kFont(11);
        [_backImageView addSubview:_userIdLabel];
        
        self.liveLabel = [[UILabel alloc] init];
        _liveLabel.textColor = kColor(@"#ffffff");
        _liveLabel.font = kFont(11);
        _liveLabel.textAlignment = NSTextAlignmentCenter;
        [_backImageView addSubview:_liveLabel];
        
        self.distanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_distanceButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        _distanceButton.titleLabel.font = kFont(11);
        [_distanceButton setImage:[UIImage imageNamed:@"detail_location"] forState:UIControlStateNormal];
        [_backImageView addSubview:_distanceButton];
        
        self.albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumButton setBackgroundColor:kColor(@"#ffffff")];
        [_albumButton setTitleColor:kColor(@"#333333") forState:UIControlStateNormal];
        _albumButton.titleLabel.font = kFont(12);
        [_albumButton setImage:[UIImage imageNamed:@"detail_local_album"] forState:UIControlStateNormal];
        [self addSubview:_albumButton];
        
        @weakify(self);
        [_albumButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.albumCount == 0) {
                return ;
            }
            if (self.clickAction) {
                self.clickAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followButton setBackgroundColor:kColor(@"#ffffff")];
        [_followButton setTitleColor:kColor(@"#333333") forState:UIControlStateNormal];
        _followButton.titleLabel.font = kFont(12);
        [_followButton setImage:[UIImage imageNamed:@"detail_local_follow"] forState:UIControlStateNormal];
        [self addSubview:_followButton];
        
        self.contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contactButton setBackgroundColor:kColor(@"#ffffff")];
        [_contactButton setTitle:@"QQ微信" forState:UIControlStateNormal];
        [_contactButton setTitleColor:kColor(@"#333333") forState:UIControlStateNormal];
        _contactButton.titleLabel.font = kFont(12);
        [_contactButton setImage:[UIImage imageNamed:@"detail_local_qq"] forState:UIControlStateNormal];
        [self addSubview:_contactButton];
        
        {
            [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
                make.height.mas_equalTo(kWidth(174*2));
            }];
            
            [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_backImageView);
                make.top.equalTo(_backImageView).offset(kWidth(26));
                make.size.mas_equalTo(CGSizeMake(kWidth(200), kWidth(200)));
            }];
            
            [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_backImageView);
                make.top.equalTo(_userImageView.mas_bottom).offset(kWidth(20));
                make.height.mas_equalTo(kWidth(32));
            }];
            
            [_userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_backImageView).offset(kWidth(40));
                make.bottom.equalTo(_backImageView.mas_bottom).offset(-kWidth(18));
                make.height.mas_equalTo(kWidth(24));
            }];
            
            [_liveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_backImageView);
                make.centerY.equalTo(_userIdLabel);
                make.height.mas_equalTo(kWidth(24));
            }];
            
            [_distanceButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_backImageView.mas_right).offset(-kWidth(40));
                make.centerY.equalTo(_userIdLabel);
                make.size.mas_equalTo(CGSizeMake(kWidth(130), kWidth(24)));
            }];
            
            [_albumButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.bottom.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth/3, kWidth(70)));
            }];
            
            [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth/3 - 2 , kWidth(70)));
            }];
            
            [_contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth/3, kWidth(70)));
            }];
            
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self.subviews enumerateObjectsWithOptions:NSEnumerationConcurrent
                                    usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *thisButton  = (UIButton *)obj;
            UIEdgeInsets imageEdge = thisButton.imageEdgeInsets;
            UIEdgeInsets titleEdge = thisButton.titleEdgeInsets;
            thisButton.imageEdgeInsets = UIEdgeInsetsMake(imageEdge.top, imageEdge.left - 2.5, imageEdge.bottom, imageEdge.right + 2.5);
            thisButton.titleEdgeInsets = UIEdgeInsetsMake(titleEdge.top, titleEdge.left + 2.5, titleEdge.bottom, titleEdge.right - 2.5);
        }
    }];
}

- (void)setBackImageUrl:(NSString *)backImageUrl {
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:backImageUrl]];
}

- (void)setUserImageUrl:(NSString *)userImageUrl {
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:userImageUrl]];
}

- (void)setNickName:(NSString *)nickName {
    _nickNameLabel.text = nickName;
}

- (void)setUserId:(NSString *)userId {
    _userIdLabel.text = [NSString stringWithFormat:@"ID:%@",userId];
}

- (void)setUserLocation:(NSString *)userLocation {
    _liveLabel.text = userLocation;
}

- (void)setDistance:(NSString *)distance {
    [_distanceButton setTitle:distance forState:UIControlStateNormal];
}

- (void)setAlbumCount:(NSInteger)albumCount {
    if ([YFBUtil isVip]) {
        albumCount = 0;
    }
    _albumCount = albumCount;
    [_albumButton setTitle:[NSString stringWithFormat:@"相册：%ld",albumCount] forState:UIControlStateNormal];
}

- (void)setFollowCount:(NSInteger )followCount {
    [_followButton setTitle:[NSString stringWithFormat:@"%ld",followCount] forState:UIControlStateNormal];
}

@end
