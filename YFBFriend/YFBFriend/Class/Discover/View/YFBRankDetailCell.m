//
//  YFBRankDetailCell.m
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBRankDetailCell.h"

@interface YFBRankDetailCell ()
@property (nonatomic,strong) UIButton       *rankButton;
@property (nonatomic,strong) UIImageView    *userImageView;
@property (nonatomic,strong) UILabel        *nickNameLabel;
@property (nonatomic,strong) UIButton       *sexButton;
@property (nonatomic,strong) UILabel        *distanceLabel;
@property (nonatomic,strong) UILabel        *rankTypeLabel;
@property (nonatomic,strong) UILabel        *giftLabel;
@end

@implementation YFBRankDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kColor(@"#efefef");
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.rankButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rankButton setTitleColor:kColor(@"#333333") forState:UIControlStateNormal];
        _rankButton.titleLabel.font = kFont(16);
        [self.contentView addSubview:_rankButton];
        
        self.userImageView = [[UIImageView alloc] init];
        [_userImageView YPB_addAnimationForImageAppearing];
        _userImageView.layer.cornerRadius = kWidth(42);
        _userImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_userImageView];
        
        self.nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textColor = kColor(@"#333333");
        _nickNameLabel.font = kFont(13);
        [self.contentView addSubview:_nickNameLabel];
        
        self.sexButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sexButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        _sexButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(24)];
        _sexButton.layer.cornerRadius = 3;
        _sexButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_sexButton];
        
        self.distanceLabel = [[UILabel alloc] init];
        _distanceLabel.textColor = kColor(@"#ffffff");
        _distanceLabel.font = kFont(11);
        _distanceLabel.backgroundColor = kColor(@"#E5C2AE");
        _distanceLabel.textAlignment = NSTextAlignmentCenter;
        _distanceLabel.layer.cornerRadius = 3;
        _distanceLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_distanceLabel];
        
        self.rankTypeLabel = [[UILabel alloc] init];
        _rankTypeLabel.textAlignment = NSTextAlignmentRight;
        _rankTypeLabel.textColor = kColor(@"#666666");
        _rankTypeLabel.font = kFont(12);
        [self.contentView addSubview:_rankTypeLabel];
        
        self.giftLabel = [[UILabel alloc] init];
        _giftLabel.textColor = kColor(@"#97BCF0");
        _giftLabel.font = kFont(12);
        [self.contentView addSubview:_giftLabel];
        
        {
            [_rankButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(26));
                make.size.mas_equalTo(CGSizeMake(kWidth(42), kWidth(66)));
            }];
            
            [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(90));
                make.size.mas_equalTo(CGSizeMake(kWidth(84), kWidth(84)));
            }];
            
            [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userImageView.mas_right).offset(kWidth(20));
                make.top.equalTo(self.contentView).offset(kWidth(28));
                make.height.mas_equalTo(kWidth(26));
            }];
            
            [_sexButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userImageView.mas_right).offset(kWidth(20));
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(84), kWidth(30)));
            }];
            
            [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_sexButton);
                make.left.equalTo(_sexButton.mas_right).offset(kWidth(10));
                make.height.mas_equalTo(kWidth(30));
            }];
            
            [_rankTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(140));
                make.centerY.equalTo(self.contentView);
                make.height.mas_equalTo(kWidth(26));
            }];
            
            [_giftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_rankTypeLabel.mas_right);
                make.centerY.equalTo(self.contentView);
                make.height.mas_equalTo(kWidth(26));
            }];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
}

- (void)setIndex:(NSInteger)index {
//    QBLog(@"index :%ld",index);
    if (index == 0 || index == 1 || index == 2) {
        [_rankButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"discover_rank_%ld",index+1]] forState:UIControlStateNormal];
        [_rankButton setTitle:nil forState:UIControlStateNormal];
    } else {
        [_rankButton setImage:nil forState:UIControlStateNormal];
        [_rankButton setTitle:[NSString stringWithFormat:@"%ld",(long)index+1] forState:UIControlStateNormal];
    }
}

- (void)setUserImageUrl:(NSString *)userImageUrl {
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:userImageUrl]];
}

- (void)setNickName:(NSString *)nickName {
    _nickNameLabel.text = nickName;
}

- (void)setUserSex:(YFBUserSex)userSex {
    if (userSex == YFBUserSexFemale) {
        [_sexButton setImage:[UIImage imageNamed:@"discover_female"] forState:UIControlStateNormal];
        [_sexButton setBackgroundColor:kColor(@"#FD97BE")];
    } else {
        [_sexButton setImage:[UIImage imageNamed:@"discover_male"] forState:UIControlStateNormal];
        [_sexButton setBackgroundColor:kColor(@"#97BCF0")];
    }
}

- (void)setAge:(NSString *)age {
    [_sexButton setTitle:age forState:UIControlStateNormal];
}

- (void)setDistance:(NSString *)distance {
    _distanceLabel.text = distance;
}

- (void)setRankType:(YFBRankType)rankType {
    if (rankType == YFBRankTypeSend) {
        _rankTypeLabel.text = @"送出：";
    } else {
        _rankTypeLabel.text = @"收到：";
    }
}

- (void)setGiftCount:(NSInteger)giftCount {
    _giftLabel.text = [NSString stringWithFormat:@"%ld个礼物",giftCount];
}
@end
