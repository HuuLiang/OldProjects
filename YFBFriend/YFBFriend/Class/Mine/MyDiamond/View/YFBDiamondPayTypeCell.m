//
//  YFBDiamondPayTypeCell.m
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDiamondPayTypeCell.h"

@interface YFBDiamondPayTypeCell ()
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
}

@property (nonatomic,retain) UIView *lineView;
@end

@implementation YFBDiamondPayTypeCell

- (UIView *)lineView {
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = kColor(@"#999999");
    [self addSubview:_lineView];
    {
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self).mas_offset(-0.5);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _lineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 8;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).mas_offset(kWidth(30));
                make.centerY.mas_equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(120)));
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kColor(@"#333333");
        _titleLabel.font = kFont(17);
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_imageView.mas_right).mas_offset(kWidth(20));
                make.top.mas_equalTo(self).mas_offset(kWidth(32));
                make.size.mas_equalTo(CGSizeMake(kScreenWidth *0.5, kWidth(40)));
            }];
        }
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = kFont(15);
        _subTitleLabel.textColor = kColor(@"#999999");
        [self addSubview:_subTitleLabel];
        {
            [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_titleLabel);
                make.top.mas_equalTo(_titleLabel.mas_bottom).mas_offset(kWidth(20));
                make.right.mas_equalTo(self).mas_offset(kWidth(-70));
                make.height.mas_equalTo(kWidth(36));
            }];
        }
        
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    _subTitleLabel.text = subTitle;
}

- (void)setNeedLine:(BOOL)needLine {
    _needLine = needLine;
    if (needLine) {
        self.lineView.hidden = NO;
    }else{
        if (_lineView) {
            [_lineView removeFromSuperview];
        }
    }
}

@end
