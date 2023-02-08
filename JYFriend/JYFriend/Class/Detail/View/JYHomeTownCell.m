//
//  JYHomeTownCell.m
//  JYFriend
//
//  Created by ylz on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYHomeTownCell.h"
#import "JYNearPersonBtn.h"

@interface JYHomeTownCell ()
{
    JYNearPersonBtn *_genderBtn;
    UILabel *_heightLabel;
    UILabel *_homeTownLabel;
}

@property (nonatomic,retain) UILabel  *vipLabel;
@property (nonatomic,retain) UILabel *distanceLabel;
@property (nonatomic,retain) UILabel *timeLabel;

@end

@implementation JYHomeTownCell

- (UILabel *)distanceLabel {
    if (_distanceLabel) {
        return _distanceLabel;
    }
    _distanceLabel = [[UILabel alloc] init];
    _distanceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _distanceLabel.font = [UIFont systemFontOfSize:kWidth(28.)];
    [self addSubview:_distanceLabel];
    {
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_genderBtn);
            make.top.mas_equalTo(_genderBtn.mas_bottom).mas_offset(kWidth(26.));
            make.size.mas_equalTo(CGSizeMake(kWidth(100), kWidth(28)));
        }];
    }
    
    return _distanceLabel;
}


- (UILabel *)timeLabel {
    if (_timeLabel) {
        return _timeLabel;
    }
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:kWidth(28.)];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:_timeLabel];
    {
        if (_distanceLabel) {
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_distanceLabel.mas_right).mas_offset(kWidth(20));
                make.top.mas_equalTo(_genderBtn.mas_bottom).mas_offset(kWidth(26.));
                make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(26)));
            }];
        }else {
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).mas_offset(kWidth(30));
                make.top.mas_equalTo(_genderBtn.mas_bottom).mas_offset(kWidth(26.));
                make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(26)));
            }];
        }
    }
    
    return _timeLabel;
}

- (UILabel *)vipLabel {
    if (_vipLabel) {
        return _vipLabel;
    }
    _vipLabel = [[UILabel alloc] init];
    _vipLabel.textColor = [UIColor whiteColor];
    _vipLabel.backgroundColor = [UIColor colorWithHexString:@"#fd774d"];
    _vipLabel.font = [UIFont systemFontOfSize:kWidth(24.)];
    _vipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_vipLabel];
    {
    [_vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_genderBtn);
        make.left.mas_equalTo(_heightLabel.mas_right).mas_offset(kWidth(10));
        make.size.mas_equalTo(CGSizeMake(kWidth(60.), kWidth(32)));
    }];
    }
    return _vipLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
         self.backgroundColor = [UIColor whiteColor];
        _genderBtn = [JYNearPersonBtn buttonWithType:UIButtonTypeCustom];
        _genderBtn.backgroundColor = [UIColor colorWithHexString:@"#e147a5"];
        _genderBtn.titleLabel.font =  [UIFont systemFontOfSize:kWidth(24.)];
        [_genderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_genderBtn];
        {
        [_genderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(kWidth(30.));
            make.top.mas_equalTo(self).mas_offset(kWidth(40.));
            make.size.mas_equalTo(CGSizeMake(kWidth(80.), kWidth(32.)));
        }];
        }
        _heightLabel = [[UILabel alloc] init];
        _heightLabel.backgroundColor = [UIColor colorWithHexString:@"#e147a5"];
        _heightLabel.textColor = [UIColor whiteColor];
        _heightLabel.font = [UIFont systemFontOfSize:kWidth(24.)];
        [self addSubview:_heightLabel];
        {
        [_heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_genderBtn.mas_right).mas_offset(kWidth(10.));
            make.centerY.mas_equalTo(_genderBtn);
            make.size.mas_equalTo(CGSizeMake(kWidth(88.), kWidth(32.)));
        }];
        }
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
        {
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self).mas_offset(kWidth(-200));
                make.centerY.mas_equalTo(self);
                make.height.mas_equalTo(kWidth(self.bounds.size.height *0.85));
                make.width.mas_equalTo(kWidth(1));
            }];
        }
        
        UILabel *homeLabel = [[UILabel alloc] init];
        homeLabel.textAlignment = NSTextAlignmentCenter;
        homeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        homeLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        homeLabel.text = @"家乡";
        [self addSubview:homeLabel];
        {
        [homeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).mas_offset(kWidth(-10));
            make.centerY.mas_equalTo(_genderBtn);
//            make.size.mas_equalTo(CGSizeMake(kWidth(80), kWidth(32)));
            make.left.mas_equalTo(lineView.mas_right).mas_offset(kWidth(10));
            make.height.mas_equalTo(kWidth(32.));
        }];
        }
        
        _homeTownLabel = [[UILabel alloc] init];
        _homeTownLabel.font = [UIFont systemFontOfSize:kWidth(28.)];
        _homeTownLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _homeTownLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_homeTownLabel];
        {
        [_homeTownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(homeLabel.mas_bottom).mas_offset(kWidth(28.));
//            make.right.mas_equalTo(homeLabel);
//            make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(25.)));
            make.left.right.mas_equalTo(homeLabel);
            make.height.mas_equalTo(kWidth(25));
        }];
        }
    }
    
    return self;
}

- (void)setGender:(JYUserSex)gender {
    _gender = gender;
    if (gender == JYUserSexMale) {
        [_genderBtn setImage:[UIImage imageNamed:@"near_gender_boy_icon"] forState:UIControlStateNormal];
        [_genderBtn setBackgroundColor:[UIColor colorWithHexString:@"#7b96ff"]];
    }else if(gender == JYUserSexFemale){
        [_genderBtn setImage:[UIImage imageNamed:@"near_gender_girl_icon"] forState:UIControlStateNormal];
        [_genderBtn setBackgroundColor:[UIColor colorWithHexString:@"#e147a5"]];
    }
}

- (void)setAge:(NSInteger)age {
    _age = age;
    [_genderBtn setTitle:[NSString stringWithFormat:@"%ld",age] forState:UIControlStateNormal];
}

- (void)setHeight:(NSInteger)height {
    _height = height;
    _heightLabel.text = [NSString stringWithFormat:@"%ldcm",height];
}

- (void)setVip:(BOOL)vip {
    _vip = vip;
    if (vip) {
        self.vipLabel.text = @"VIP";
    }else {
        _vipLabel.hidden = YES;
        [_vipLabel removeFromSuperview];
    }
}

- (void)setDistance:(NSString *)distance {
    _distance = distance;
    if (distance) {
        self.distanceLabel.text = distance;
    }else {
        if (_distanceLabel) {
            _distanceLabel.hidden = YES;
        }
    }
    
}

- (void)setTime:(NSString *)time {
    _time = time;
    self.timeLabel.text = time;
}

- (void)setHomeTown:(NSString *)homeTown {
    _homeTown = homeTown;
    _homeTownLabel.text = homeTown;
}


@end
