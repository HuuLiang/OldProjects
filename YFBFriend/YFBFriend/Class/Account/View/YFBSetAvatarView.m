//
//  YFBSetAvatarView.m
//  YFBFriend
//
//  Created by Liang on 2017/3/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBSetAvatarView.h"

@interface YFBSetAvatarView ()
{
    UILabel *_titleLabel;
    UIButton *_avatarButton;
    UILabel *_descLabel;
}
@end


@implementation YFBSetAvatarView

- (instancetype)initWithFrame:(CGRect)frame action:(void (^)(void))handler
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"完善资料，是社交成功的第一步哦";
        _titleLabel.textColor = kColor(@"#8458D0");
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(34)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        
        _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_avatarButton setImage:[UIImage imageNamed:@"login_avatar"] forState:UIControlStateNormal];
        
        [self addSubview:_avatarButton];
        @weakify(self);
        [_avatarButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            handler();
        } forControlEvents:UIControlEventTouchUpInside];
        
        _descLabel = [[UILabel alloc] init];
        _descLabel.text = @"上传真实照片\n交友成功率将大大提高";
        _descLabel.textColor = kColor(@"#333333");
        _descLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.numberOfLines = 2;
        [self addSubview:_descLabel];
        
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(kWidth(34));
                make.height.mas_equalTo(kWidth(34));
            }];
            
            [_avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_titleLabel.mas_bottom).offset(kWidth(74));
                make.size.mas_equalTo(CGSizeMake(kWidth(140), kWidth(140)));
            }];
            
            [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_avatarButton.mas_bottom).offset(kWidth(56));
                make.height.mas_equalTo(kWidth(70));
            }];
        }
    }
    return self;
}

- (void)setUserImg:(UIImage *)userImg {
    [_avatarButton setImage:userImg forState:UIControlStateNormal];
}

- (void)setImageUrl:(NSString *)imageUrl {
    [_avatarButton sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"login_avatar"]];
}

@end
