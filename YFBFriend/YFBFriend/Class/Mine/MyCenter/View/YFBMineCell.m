//
//  YFBMineCell.m
//  YFBFriend
//
//  Created by Liang on 2017/3/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMineCell.h"

@interface YFBMineCell ()
{
    UIImageView *_iconImageView;
    UILabel *_titleLabel;
}
@property (nonatomic,retain) UILabel *subLabel;
@end

@implementation YFBMineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
        {
            [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).mas_offset(kWidth(30));
                make.centerY.mas_equalTo(self.contentView);
                make.height.equalTo(@(kWidth(50)));
                make.width.equalTo(_iconImageView.mas_height);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16.];
        _titleLabel.textColor = kColor(@"#333333");
        [self.contentView addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_iconImageView);
                make.left.mas_equalTo(_iconImageView.mas_right).mas_offset(kWidth(20));
            }];
        }

    }
    return self;
}

- (UILabel *)subLabel {
    if (_subLabel) {
        return _subLabel;
    }
    _subLabel = [[UILabel alloc] init];
    _subLabel.font = [UIFont systemFontOfSize:kWidth(28)];
    _subLabel.textColor = kColor(@"#8458d0");
    _subLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_subLabel];
    {
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).mas_offset(kWidth(-65));
        make.height.mas_equalTo(kWidth(28));
    }];
    }
    return _subLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setIconImage:(NSString *)iconImage {
    _iconImage = iconImage;
    _iconImageView.image = [UIImage imageNamed:iconImage];
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    if (subTitle) {
        self.subLabel.text = subTitle;
    }else {
        if (_subLabel) {
            [_subLabel removeFromSuperview];
            _subLabel = nil;
        }
    }
}

@end
