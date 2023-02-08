//
//  SAMineUserInfoHeaderView.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAMineUserInfoHeaderView.h"

@interface SAMineUserInfoHeaderView ()
@property (nonatomic) UIImageView *userImgV;
@property (nonatomic) UILabel *userIdLabel;
@end


@implementation SAMineUserInfoHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.userImgV = [[UIImageView alloc] init];
        _userImgV.userInteractionEnabled = YES;
        [self addSubview:_userImgV];
        
        self.userIdLabel = [[UILabel alloc] init];
        _userIdLabel.textColor = kColor(@"#666666");
        _userIdLabel.font = kFont(15);
        [self addSubview:_userIdLabel];
        
        @weakify(self);
        [_userImgV bk_whenTapped:^{
            @strongify(self);
            if (self.changeImgAction) {
                self.changeImgAction();
            }
        }];
        
        {
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(120)));
            }];
            
            [_userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userImgV.mas_right).offset(kWidth(30));
                make.centerY.equalTo(self);
                make.height.mas_equalTo(_userIdLabel.font.lineHeight);
            }];
        }
    }
    return self;
}


- (void)setPortraitUrl:(NSString *)portraitUrl {
    [_userImgV sd_setImageWithURL:[NSURL URLWithString:portraitUrl] placeholderImage:[UIImage imageNamed:@"mine_img"]];
}

- (void)setUserId:(NSString *)userId {
    _userIdLabel.text = [NSString stringWithFormat:@"ID:%@",userId];
}

@end
