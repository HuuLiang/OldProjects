//
//  JYCharacterCell.m
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYCharacterCell.h"

@interface JYCharacterCell ()
{
    UIImageView *_userImgV;
    UILabel     *_nickNameLabel;
    UILabel     *_ageLabel;
}
@end

@implementation JYCharacterCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        
        _userImgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_userImgV];
        
        UIView *shadowView = [[UIView alloc] init];
        shadowView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        [self.contentView addSubview:shadowView];
        
        _ageLabel = [[UILabel alloc] init];
        _ageLabel.textColor = kColor(@"#ffffff");
        _ageLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _ageLabel.textAlignment = NSTextAlignmentRight;
        [shadowView addSubview:_ageLabel];
        
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textColor = kColor(@"#ffffff");
        _nickNameLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [shadowView addSubview:_nickNameLabel];

        
        {
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
            
            [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.contentView);
                make.height.mas_equalTo(kWidth(50));
            }];
            
            [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(shadowView);
                make.width.mas_equalTo(kWidth(70));
                make.right.equalTo(shadowView.mas_right).offset(-kWidth(5));
            }];
            
            [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(shadowView);
                make.right.equalTo(shadowView.mas_right).offset(-kWidth(75));
                make.left.equalTo(shadowView).offset(kWidth(10));
            }];
            
        }
    }
    return self;
}

- (void)setUserImgStr:(NSString *)userImgStr {
    [_userImgV sd_setImageWithURL:[NSURL URLWithString:userImgStr]];
}

- (void)setNickNameStr:(NSString *)nickNameStr {
    _nickNameLabel.text = nickNameStr;
}

- (void)setAgeStr:(NSString *)ageStr {
    _ageLabel.text = [NSString stringWithFormat:@"%@岁",ageStr];
}

@end
