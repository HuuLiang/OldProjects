//
//  SARankDetailCell.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SARankDetailCell.h"

@interface SARankDetailCell ()
@property (nonatomic) UIImageView *userImgV;
@property (nonatomic) UILabel *nickNameLabel;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *incomeLabel;
@end

@implementation SARankDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.userImgV = [[UIImageView alloc] init];
        _userImgV.layer.cornerRadius = kWidth(45);
        [self.contentView addSubview:_userImgV];
        
        self.nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textColor = kColor(@"#666666");
        _nickNameLabel.font = kFont(14);
        [self.contentView addSubview:_nickNameLabel];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kColor(@"#999999");
        _titleLabel.font = kFont(12);
        _titleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_titleLabel];
        
        self.incomeLabel = [[UILabel alloc] init];
        _incomeLabel.textColor = kColor(@"#FF3366");
        _incomeLabel.font = kFont(15);
        [self.contentView addSubview:_incomeLabel];
        
        
        {
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(90), kWidth(90)));
            }];
            
            [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView.mas_left).offset(kWidth(140));
                make.height.mas_equalTo(_nickNameLabel.font.lineHeight);
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(154));
                make.height.mas_equalTo(_titleLabel.font.lineHeight);
            }];
            
            [_incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(_titleLabel.mas_right).offset(kWidth(6));
                make.height.mas_equalTo(_incomeLabel.font.lineHeight);
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

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;;
}

- (void)setType:(NSInteger)type {
    _type = type;
    if (type == 1) {
        _titleLabel.text = @"累计收益";
    } else if (type == 2) {
        _titleLabel.text = @"累计收徒";
    }
}

- (void)setCount:(NSString *)count {
    NSString *unit = nil;
    if (_type == 1) {
        unit = @"元";
    } else if (_type == 2) {
        unit = @"人";
    }
    _incomeLabel.text = [NSString stringWithFormat:@"%@%@",count,unit];
}

@end
