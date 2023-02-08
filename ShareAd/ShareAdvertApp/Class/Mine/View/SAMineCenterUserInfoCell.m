//
//  SAMineCenterUserInfoCell.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/7.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAMineCenterUserInfoCell.h"

@interface SAMineCenterUserInfoCell ()
@property (nonatomic) UIImageView *userImgV;
@property (nonatomic) UILabel *nickNameLabel;
@property (nonatomic) UILabel *userIdLabel;
@property (nonatomic) UIImageView *intoImgV;
@end

@implementation SAMineCenterUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.userImgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_userImgV];
        
        self.nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textColor = kColor(@"#333333");
        _nickNameLabel.font = kFont(15);
        [self.contentView addSubview:_nickNameLabel];
        
        self.userIdLabel = [[UILabel alloc] init];
        _userIdLabel.textColor = kColor(@"#333333");
        _userIdLabel.font = kFont(12);
        [self.contentView addSubview:_userIdLabel];
        
        self.intoImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_into"]];
        [self.contentView addSubview:_intoImgV];
        
        {
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(120)));
            }];
            
            [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userImgV.mas_right).offset(kWidth(28));
                make.bottom.equalTo(_userImgV.mas_centerY).offset(-2);
                make.height.mas_equalTo(_nickNameLabel.font.lineHeight);
            }];
            
            [_userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nickNameLabel);
                make.top.equalTo(_userImgV.mas_centerY).offset(2);
                make.height.mas_equalTo(_userIdLabel.font.lineHeight);
            }];
            
            [_intoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(14), kWidth(26)));
            }];
        }
    }
    return self;
}

- (void)setPortraitUrl:(NSString *)portraitUrl {
    [_userImgV sd_setImageWithURL:[NSURL URLWithString:portraitUrl] placeholderImage:[UIImage imageNamed:@"mine_img"]];
}

- (void)setNickName:(NSString *)nickName {
    _nickNameLabel.text = nickName;
}

- (void)setUserId:(NSString *)userId {
    _userIdLabel.text = [NSString stringWithFormat:@"ID:%@",userId];
}

@end
