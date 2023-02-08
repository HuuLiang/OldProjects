//
//  YFBMineGiftCell.m
//  YFBFriend
//
//  Created by Liang on 2017/4/19.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMineGiftCell.h"

@interface YFBMineGiftCell ()
{
    UIView *_bgView;
    UIImageView *_imageView;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UIButton *_diamondBtn;
    UIButton *_giveBtn;
}

@end

@implementation YFBMineGiftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kColor(@"#e6e6e6");
        [self addSubview:lineView];
        {
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.mas_equalTo(self);
                make.left.mas_equalTo(self).mas_offset(kWidth(102));
                make.height.mas_equalTo(1);
            }];
        }
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = kColor(@"#f0f0f0");
        _bgView.layer.cornerRadius = kWidth(10);
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
        
        {
            [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self);
                make.left.mas_equalTo(self).mas_offset(kWidth(108));
                make.size.mas_equalTo(CGSizeMake(kWidth(110), kWidth(110)));
            }];
        }
        
        _imageView = [[UIImageView alloc] init];
        [_bgView addSubview:_imageView];
        {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_bgView).mas_equalTo(UIEdgeInsetsMake(kWidth(10), kWidth(10), kWidth(10), kWidth(10)));
            }];
        }
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFont(12);
        _nameLabel.textColor = kColor(@"#333333");
        [self addSubview:_nameLabel];
        {
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgView.mas_right).mas_offset(kWidth(24));
                make.top.mas_equalTo(_bgView).mas_offset(kWidth(10));
            }];
        }
        
        _diamondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_diamondBtn setImage:[UIImage imageNamed:@"gift_pop_diamond_icon"] forState:UIControlStateNormal];
        _diamondBtn.titleLabel.font = kFont(12);
        [_diamondBtn setTitleColor:kColor(@"#999999") forState:UIControlStateNormal];
        [self addSubview:_diamondBtn];
        {
            [_diamondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_nameLabel);
                make.top.mas_equalTo(_nameLabel.mas_bottom).mas_offset(kWidth(10));
            }];
        }
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = kFont(10);
        _timeLabel.textColor = kColor(@"#cccccc");
        [self addSubview:_timeLabel];
        {
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_nameLabel);
                make.top.mas_equalTo(_diamondBtn.mas_bottom).mas_offset(kWidth(10));
            }];
        }
        _giveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _giveBtn.titleLabel.font = kFont(14);
        _giveBtn.layer.borderColor = kColor(@"#8458d0").CGColor;
        _giveBtn.layer.borderWidth = 1;
        _giveBtn.layer.cornerRadius = kWidth(26);
        _giveBtn.clipsToBounds = YES;
        [_giveBtn setTitleColor:kColor(@"#8458D0") forState:UIControlStateNormal];
        [_giveBtn setTitle:@"赠送" forState:UIControlStateNormal];
        [self addSubview:_giveBtn];
        {
            [_giveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_bgView);
                make.right.mas_equalTo(self).mas_offset(kWidth(-52));
                make.height.mas_equalTo(kWidth(52));
                make.width.mas_equalTo(kWidth(140));
                //                make.left.mas_lessThanOrEqualTo(_diamondBtn.mas_right).mas_offset(kWidth(20));
            }];
        }
        @weakify(self);
        [_giveBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            QBSafelyCallBlock(self.giveAction)
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setName:(NSString *)name {
    _name = name;
    _nameLabel.text = name;
}

- (void)setTime:(NSString *)time {
    _time = time;
    _timeLabel.text = time;
}

- (void)setDiamond:(NSString *)diamond {
    _diamond = diamond;
    [_diamondBtn setTitle:diamond forState:UIControlStateNormal];
}

- (void)setGiveStr:(NSString *)giveStr {
    _giveStr = giveStr;
    [_giveBtn setTitle:giveStr forState:UIControlStateNormal];
}

- (void)setGiftUrl:(NSString *)giftUrl {
    [_imageView sd_setImageWithURL:[NSURL URLWithString:giftUrl]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _giveBtn.width = _giveBtn.width + kWidth(26);
}

@end
