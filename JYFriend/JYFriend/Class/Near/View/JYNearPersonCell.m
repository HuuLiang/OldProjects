//
//  JYNearPersonCell.m
//  JYFriend
//
//  Created by ylz on 2016/12/22.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYNearPersonCell.h"
#import "JYNearPersonBtn.h"

@interface JYNearPersonCell ()

{
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    JYNearPersonBtn *_genderBtn;
    UILabel *_heightLabel;
    UILabel *_detaiLabel;
    UILabel *_distanceLabel;
}

@property (nonatomic,retain) UILabel *vipLabel;

@end

@implementation JYNearPersonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _headerImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_headerImageView];
        {
            [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).mas_offset(kWidth(30));
                make.centerY.mas_equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(kWidth(140), kWidth(140)));
            }];
        }
        
        _genderBtn = [JYNearPersonBtn buttonWithType:UIButtonTypeCustom];
        _genderBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(24.)];
        UIEdgeInsets imageInsets = _genderBtn.imageEdgeInsets;
        UIEdgeInsets titleInsets = _genderBtn.titleEdgeInsets;
        
        _genderBtn.imageEdgeInsets = UIEdgeInsetsMake(imageInsets.top, imageInsets.left-kWidth(6), imageInsets.bottom, imageInsets.right);
        _genderBtn.titleEdgeInsets = UIEdgeInsetsMake(titleInsets.top, titleInsets.left, titleInsets.bottom, titleInsets.right-kWidth(6));
        
        [self.contentView addSubview:_genderBtn];
        {
        [_genderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_headerImageView);
            make.left.mas_equalTo(_headerImageView.mas_right).mas_offset(kWidth(20.));
            make.size.mas_equalTo(CGSizeMake(kWidth(80.), kWidth(32.)));
        }];
        }

        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:kWidth(32.)];
        _nameLabel.textColor = kColor(@"#333333");
        [self.contentView addSubview:_nameLabel];
        {
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headerImageView.mas_right).mas_offset(kWidth(20.));
            make.bottom.mas_equalTo(_genderBtn.mas_top).mas_offset(kWidth(-22.));
            make.height.mas_equalTo(kWidth(32.));
        }];
        }
        
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _distanceLabel.font = [UIFont systemFontOfSize:kWidth(28.)];
        [self.contentView addSubview:_distanceLabel];
        {
            [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_nameLabel);
                make.right.mas_equalTo(self.contentView.mas_right).mas_offset(kWidth(-30.));
                make.height.mas_equalTo(kWidth(26.));
            }];
        }
        
        _heightLabel = [[UILabel alloc] init];
        _heightLabel.backgroundColor = [UIColor colorWithHexString:@"#e147a5"];
        _heightLabel.font = [UIFont systemFontOfSize:kWidth(24.)];
        _heightLabel.textAlignment = NSTextAlignmentCenter;
        _heightLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_heightLabel];
        {
        [_heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_genderBtn);
            make.left.mas_equalTo(_genderBtn.mas_right).mas_offset(kWidth(10.));
            make.height.mas_equalTo(_genderBtn);
            make.width.mas_equalTo(kWidth(88.));
        }];
        }
        
        _detaiLabel = [[UILabel alloc] init];
        _detaiLabel.font = [UIFont systemFontOfSize:kWidth(28.)];
        _detaiLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        [self.contentView addSubview:_detaiLabel];
        {
        [_detaiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_genderBtn);
            make.top.mas_equalTo(_genderBtn.mas_bottom).mas_offset(kWidth(22.));
            make.size.mas_equalTo(CGSizeMake(kWidth(480.), kWidth(28.)));
        }];
        }
    }
    return self;
}

- (UILabel *)vipLabel {
    if (_vipLabel) {
        return _vipLabel;
    }
    
    _vipLabel = [[UILabel alloc] init];
    _vipLabel.backgroundColor = [UIColor colorWithHexString:@"#fd774d"];
    _vipLabel.font = [UIFont systemFontOfSize:kWidth(24.)];
    _vipLabel.textColor = [UIColor whiteColor];
    _vipLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_vipLabel];
    {
    [_vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_genderBtn);
        make.left.mas_equalTo(_heightLabel.mas_right).mas_offset(kWidth(10.));
        make.height.mas_equalTo(_heightLabel);
        make.width.mas_equalTo(kWidth(52.));
    }];
    }
    
    return _vipLabel;
}


- (void)setHeaderImageUrl:(NSString *)headerImageUrl {
    headerImageUrl = headerImageUrl;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImageUrl]];
}

- (void)setName:(NSString *)name {
    _name = name;
    _nameLabel.text = name;
}

//- (void)setGender:(NSInteger)gender {
//    _gender = gender;
//    if (gender == 0) {
//        [_genderBtn setImage:[UIImage imageNamed:@"near_gender_boy_icon"] forState:UIControlStateNormal];
//        [_genderBtn setBackgroundColor:[UIColor colorWithHexString:@"#7b96ff"]];
//    }else {
//        [_genderBtn setImage:[UIImage imageNamed:@"near_gender_girl_icon"] forState:UIControlStateNormal];
//        [_genderBtn setBackgroundColor:[UIColor colorWithHexString:@"#e147a5"]];
//    }
//}
- (void)setSex:(JYUserSex)sex {
    _sex = sex;
    if (sex == JYUserSexMale) {
        [_genderBtn setImage:[UIImage imageNamed:@"near_gender_boy_icon"] forState:UIControlStateNormal];
        [_genderBtn setBackgroundColor:[UIColor colorWithHexString:@"#7b96ff"]];
    }else if (sex == JYUserSexFemale ){
        [_genderBtn setImage:[UIImage imageNamed:@"near_gender_girl_icon"] forState:UIControlStateNormal];
        [_genderBtn setBackgroundColor:[UIColor colorWithHexString:@"#e147a5"]];
    }
}


- (void)setAge:(NSString *)age {
    _age = age;
    [_genderBtn setTitle:age forState:UIControlStateNormal];
}

//- (void)setDistance:(NSInteger)distance {
//    _distance = distance;
//    if (distance < 1000) {
//        distance = (distance /100 +1)*100;
//        _distanceLabel.text = [NSString stringWithFormat:@"<%ldm",distance];
//    }else {
//        CGFloat distan = distance /1000. + 0.1;
//        _distanceLabel.text = [NSString stringWithFormat:@"<%.1fkm",distan];
//    }
//
//}

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

- (void)setDetaiTitle:(NSString *)detaiTitle {
    _detaiTitle = detaiTitle;
    _detaiLabel.text = detaiTitle;

}

- (void)setDistance:(NSString *)distance {
    _distance = distance;
    _distanceLabel.text = distance;
}

@end
