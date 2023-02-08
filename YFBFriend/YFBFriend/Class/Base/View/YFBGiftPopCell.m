//
//  YFBGiftPopCell.m
//  YFBFriend
//
//  Created by Liang on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBGiftPopCell.h"

@interface YFBGiftPopCell ()
{
    UILabel *_titleLabel;
    UIButton *_diamondBtn;
    UIImageView *_imageView;
}

@end

@implementation YFBGiftPopCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _diamondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_diamondBtn setImage:[UIImage imageNamed:@"gift_pop_diamond_icon"] forState:UIControlStateNormal];
        _diamondBtn.titleLabel.font = kFont(10);
        _diamondBtn.userInteractionEnabled = NO;
        _diamondBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:_diamondBtn];
        {
            [_diamondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self);
                make.right.mas_equalTo(self).mas_offset(kWidth(-9));
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(9);
        _titleLabel.textColor = kColor(@"#ffffff");
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).mas_offset(kWidth(9));
                make.bottom.mas_equalTo(self);
                make.right.mas_lessThanOrEqualTo(_diamondBtn.mas_left).mas_offset(kWidth(6));
            }];
        }
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self).mas_equalTo(UIEdgeInsetsMake(kWidth(30), kWidth(30), kWidth(30), kWidth(30)));
            }];
        }
        
        _diamondBtn.imageEdgeInsets = UIEdgeInsetsMake(_diamondBtn.imageEdgeInsets.top, _diamondBtn.imageEdgeInsets.left - 2, _diamondBtn.imageEdgeInsets.bottom, _diamondBtn.imageEdgeInsets.right + 2);
        _diamondBtn.titleEdgeInsets = UIEdgeInsetsMake(_diamondBtn.titleEdgeInsets.top, _diamondBtn.titleEdgeInsets.left + 2, _diamondBtn.titleEdgeInsets.bottom, _diamondBtn.titleEdgeInsets.right - 2);
        
    }
    return self;
}

- (void)setDefaultColor:(UIColor *)defaultColor {
    _defaultColor = defaultColor;
    self.backgroundColor = defaultColor;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setDiamondCount:(NSInteger)diamondCount {
    _diamondCount = diamondCount;
    [_diamondBtn setTitle:[NSString stringWithFormat:@"%zd",diamondCount] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.backgroundColor = [_defaultColor colorWithAlphaComponent:0.5];
        [_imageView startAnimation];
    } else {
        self.backgroundColor = _defaultColor;
    }
}

@end
