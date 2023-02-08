//
//  JYDynamicCell.m
//  JYFriend
//
//  Created by Liang on 2016/12/27.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYDynamicCell.h"
#import "JYNearPersonBtn.h"
#import "JYDynamicModel.h"
#import "JYUserCreateMessageModel.h"

@interface JYDynamicCell ()
{
    UIImageView     *_userImgV;
    UILabel         *_nickNameLabel;
    JYNearPersonBtn *_genderBtn;
    UILabel         *_timeLabel;
    UIButton        *_focusButton;
    UIButton        *_greetButton;
    UILabel         *_contentLabel;
    
    UIImageView     *_imgVA;
    UIImageView     *_imgVB;
    UIImageView     *_imgVC;
    
    UIImageView     *_playIcon;
}
@end


@implementation JYDynamicCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        QBLog(@"创建cell");
        self.contentView.backgroundColor = kColor(@"#ffffff");
        
        _userImgV = [[UIImageView alloc] init];
        _userImgV.layer.cornerRadius = kWidth(44);
        _userImgV.layer.masksToBounds = YES;
        _userImgV.userInteractionEnabled = YES;
        [self.contentView addSubview:_userImgV];
        @weakify(self);
        [_userImgV bk_whenTapped:^{
            @strongify(self);
            if (self.userImgAction) {
                self.userImgAction(self);
            }
        }];
        
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textColor = kColor(@"#333333");
        _nickNameLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        [self.contentView addSubview:_nickNameLabel];
        
        _genderBtn = [JYNearPersonBtn buttonWithType:UIButtonTypeCustom];
        _genderBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(25)];
        [_genderBtn setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        [_genderBtn setBackgroundColor:kColor(@"#E147A5")];
        [self.contentView addSubview:_genderBtn];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kColor(@"#999999");
        _timeLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [self.contentView addSubview:_timeLabel];
        
        _focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _focusButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _focusButton.layer.borderWidth = 1;
        _focusButton.layer.cornerRadius = kWidth(4);
        _focusButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_focusButton];
        
        [_focusButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (_isFocus) {
                return ;
            }
            if (self.buttonAction) {
                self.buttonAction(@(JYUserCreateMessageTypeFollow));
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        
        _greetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _greetButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _greetButton.layer.borderWidth = 1;
        _greetButton.layer.cornerRadius = kWidth(4);
        _greetButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_greetButton];
        
        [_greetButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (_isGreet) {
                return ;
            }
            if (self.buttonAction) {
                self.buttonAction(@(JYUserCreateMessageTypeGreet));
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = kColor(@"#333333");
        _contentLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        

        
        {
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.top.equalTo(self.contentView).offset(kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(88), kWidth(88)));
            }];
            
            [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userImgV.mas_right).offset(kWidth(18));
                make.top.equalTo(self.contentView).offset(kWidth(38));
                make.height.mas_equalTo(kWidth(32));
                make.right.lessThanOrEqualTo(_focusButton.mas_left).offset(-kWidth(104));
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nickNameLabel);
                make.top.equalTo(_nickNameLabel.mas_bottom).offset(kWidth(14));
                make.height.mas_equalTo(kWidth(28));
            }];
            
            [_greetButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-kWidth(32));
                make.top.equalTo(self.contentView).offset(kWidth(34));
                make.size.mas_equalTo(CGSizeMake(kWidth(116), kWidth(52)));
            }];
            
            [_focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_greetButton.mas_left).offset(-kWidth(14));
                make.centerY.equalTo(_greetButton);
                make.size.mas_equalTo(CGSizeMake(kWidth(116), kWidth(52)));
            }];

            
            [_genderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_nickNameLabel);
                make.left.equalTo(_nickNameLabel.mas_right).offset(kWidth(10));
                make.size.mas_equalTo(CGSizeMake(kWidth(76), kWidth(32)));
            }];
            
            
            [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.top.equalTo(_userImgV.mas_bottom).offset(kWidth(32));
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(32));
            }];
        }
    }
    return self;
}

- (void)setLogoUrl:(NSString *)logoUrl {
    [_userImgV sd_setImageWithURL:[NSURL URLWithString:logoUrl]];
}

- (void)setNickName:(NSString *)nickName {
    _nickNameLabel.text = nickName;
}

- (void)setUserSex:(JYUserSex)userSex {
    _userSex = userSex;
    [_genderBtn setImage:[UIImage imageNamed:userSex == JYUserSexMale ? @"near_gender_boy_icon" : @"near_gender_girl_icon"] forState:UIControlStateNormal];
}

- (void)setAge:(NSString *)age {
    [_genderBtn setTitle:age forState:UIControlStateNormal];
}

- (void)setTimeInterval:(NSInteger)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    _timeLabel.text = [JYUtil timeStringFromDate:date WithDateFormat:@"MM月dd日HH:mm"];
}

- (void)setContent:(NSString *)content {
    _contentLabel.text = content;
}

- (void)setIsFocus:(BOOL)isFocus {
    _isFocus = isFocus;
    if (isFocus) {
        [_focusButton setTitleColor:kColor(@"#E6E6E6") forState:UIControlStateNormal];
        [_focusButton setTitle:@"已关注" forState:UIControlStateNormal];
        _focusButton.layer.borderColor = kColor(@"#E6E6E6").CGColor;
    } else {
        [_focusButton setTitle:[NSString stringWithFormat:@"关注%@",_userSex == JYUserSexMale ? @"他" : @"她"] forState:UIControlStateNormal];
        [_focusButton setTitleColor:kColor(@"#E147A5") forState:UIControlStateNormal];
        _focusButton.layer.borderColor = kColor(@"#E147A5").CGColor;
    }
}

- (void)setIsGreet:(BOOL)isGreet {
    _isGreet = isGreet;
    if (isGreet) {
        [_greetButton setTitleColor:kColor(@"#E6E6E6") forState:UIControlStateNormal];
        [_greetButton setTitle:@"已招呼" forState:UIControlStateNormal];
        _greetButton.layer.borderColor = kColor(@"#E6E6E6").CGColor;
    } else {
        [_greetButton setTitleColor:kColor(@"#E147A5") forState:UIControlStateNormal];
        [_greetButton setTitle:@"打招呼" forState:UIControlStateNormal];
        _greetButton.layer.borderColor = kColor(@"#E147A5").CGColor;
    }
}

- (void)setDynamicType:(JYDynamicType)dynamicType {
    
    if (_imgVA) {
        [_imgVA removeFromSuperview];
    }
    if (_imgVB) {
        [_imgVB removeFromSuperview];
    }
    if (_imgVC) {
        [_imgVC removeFromSuperview];
    }
    if (_playIcon) {
        [_playIcon removeFromSuperview];
    }
    
    if (dynamicType == JYDynamicTypeOnePhoto) {
        
        _imgVA = [[UIImageView alloc] init];
        _imgVA.contentMode = UIViewContentModeScaleAspectFill;
        _imgVA.layer.masksToBounds = YES;
        [self.contentView addSubview:_imgVA];
    } else if (dynamicType == JYDynamicTypeTwoPhotos) {
        
        _imgVA = [[UIImageView alloc] init];
        _imgVA.contentMode = UIViewContentModeScaleAspectFill;
        _imgVA.layer.masksToBounds = YES;

        [self.contentView addSubview:_imgVA];
        
        _imgVB = [[UIImageView alloc] init];
        _imgVB.contentMode = UIViewContentModeScaleAspectFill;
        _imgVB.layer.masksToBounds = YES;

        [self.contentView addSubview:_imgVB];
    } else if (dynamicType == JYDynamicTypeThreePhotos) {
        
        _imgVA = [[UIImageView alloc] init];
        _imgVA.contentMode = UIViewContentModeScaleAspectFill;
        _imgVA.layer.masksToBounds = YES;

        [self.contentView addSubview:_imgVA];
        
        _imgVB = [[UIImageView alloc] init];
        _imgVB.contentMode = UIViewContentModeScaleAspectFill;
        _imgVB.layer.masksToBounds = YES;

        [self.contentView addSubview:_imgVB];
        
        _imgVC = [[UIImageView alloc] init];
        _imgVC.contentMode = UIViewContentModeScaleAspectFill;
        _imgVC.layer.masksToBounds = YES;

        [self.contentView addSubview:_imgVC];
    } else if (dynamicType == JYDynamicTypeVideo) {
        _imgVA = [[UIImageView alloc] init];
        _imgVA.contentMode = UIViewContentModeScaleAspectFill;
        _imgVA.layer.masksToBounds = YES;
        [self.contentView addSubview:_imgVA];
        
        _playIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dynamic_play"]];
        [_imgVA addSubview:_playIcon];
    }
    
    if (dynamicType == JYDynamicTypeOnePhoto) {
        [_imgVA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kWidth(30));
            make.top.equalTo(_contentLabel.mas_bottom).offset(kWidth(30));
            make.size.mas_equalTo(CGSizeMake(self.contentView.frame.size.width - kWidth(60), self.contentView.frame.size.width - kWidth(60)));
        }];
    } else if (dynamicType == JYDynamicTypeTwoPhotos) {
        [_imgVA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kWidth(30));
            make.top.equalTo(_contentLabel.mas_bottom).offset(kWidth(30));
            make.size.mas_equalTo(CGSizeMake((self.contentView.frame.size.width - kWidth(70))/2, (self.contentView.frame.size.width - kWidth(70))/2));
        }];
        
        [_imgVB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgVA.mas_right).offset(kWidth(12));
            make.top.equalTo(_contentLabel.mas_bottom).offset(kWidth(30));
            make.size.mas_equalTo(CGSizeMake((self.contentView.frame.size.width - kWidth(70))/2, (self.contentView.frame.size.width - kWidth(70))/2));
        }];
    } else if (dynamicType == JYDynamicTypeThreePhotos) {
        [_imgVA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kWidth(30));
            make.top.equalTo(_contentLabel.mas_bottom).offset(kWidth(30));
            make.size.mas_equalTo(CGSizeMake((self.contentView.frame.size.width - kWidth(72))/3, (self.contentView.frame.size.width - kWidth(72))/3));
        }];
        
        [_imgVB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgVA.mas_right).offset(kWidth(6));
            make.top.equalTo(_contentLabel.mas_bottom).offset(kWidth(30));
            make.size.mas_equalTo(CGSizeMake((self.contentView.frame.size.width - kWidth(72))/3, (self.contentView.frame.size.width - kWidth(72))/3));
        }];
        
        [_imgVC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgVB.mas_right).offset(kWidth(6));
            make.top.equalTo(_contentLabel.mas_bottom).offset(kWidth(30));
            make.size.mas_equalTo(CGSizeMake((self.contentView.frame.size.width - kWidth(72))/3, (self.contentView.frame.size.width - kWidth(72))/3));
        }];
    } else if (dynamicType == JYDynamicTypeVideo) {
        [_imgVA mas_makeConstraints:^(MASConstraintMaker *make) {
            [_imgVA mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.top.equalTo(_contentLabel.mas_bottom).offset(kWidth(30));
                make.size.mas_equalTo(CGSizeMake(self.contentView.frame.size.width - kWidth(60), (self.contentView.frame.size.width - kWidth(60))*207/345));
            }];
        }];
        
        [_playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_imgVA);
            make.size.mas_equalTo(CGSizeMake(kWidth(100), kWidth(100)));
        }];
    }
    
    @weakify(self);
    if ([self.contentView.subviews containsObject:_imgVA]) {
        [_imgVA bk_whenTapped:^{
            @strongify(self);
            if (self.photoBrowser) {
                self.photoBrowser(dynamicType == JYDynamicTypeVideo,0);
            }
        }];
    } else if ([self.contentView.subviews containsObject:_imgVB]) {
        [_imgVB bk_whenTapped:^{
            @strongify(self);
            if (self.photoBrowser) {
                self.photoBrowser(dynamicType == JYDynamicTypeVideo,1);
            }
        }];
    } else if ([self.contentView.subviews containsObject:_imgVC]) {
        [_imgVC bk_whenTapped:^{
            @strongify(self);
            if (self.photoBrowser) {
                self.photoBrowser(dynamicType == JYDynamicTypeVideo,2);
            }
        }];
    }
    
}

- (void)setMoodUrl:(NSArray *)moodUrl {
    [moodUrl enumerateObjectsUsingBlock:^(JYDynamicUrl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            _imgVA.userInteractionEnabled = YES;
            [_imgVA sd_setImageWithURL:[NSURL URLWithString:obj.thumbnail]];
        } else if (idx == 1) {
            _imgVB.userInteractionEnabled = YES;
            [_imgVB sd_setImageWithURL:[NSURL URLWithString:obj.thumbnail]];
        } else if (idx == 2) {
            _imgVC.userInteractionEnabled = YES;
            [_imgVC sd_setImageWithURL:[NSURL URLWithString:obj.thumbnail]];
        }
    }];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIEdgeInsets imageInsets = _genderBtn.imageEdgeInsets;
    UIEdgeInsets titleInsets = _genderBtn.titleEdgeInsets;
    
    _genderBtn.imageEdgeInsets = UIEdgeInsetsMake(imageInsets.top, imageInsets.left-kWidth(4), imageInsets.bottom, imageInsets.right);
    _genderBtn.titleEdgeInsets = UIEdgeInsetsMake(titleInsets.top, titleInsets.left, titleInsets.bottom, titleInsets.right-kWidth(4));
    
}


@end
