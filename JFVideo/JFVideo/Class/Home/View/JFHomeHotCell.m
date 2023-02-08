//
//  JFHomeHotCell.m
//  JFVideo
//
//  Created by Liang on 16/6/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFHomeHotCell.h"

@interface JFHomeHotCell ()
{
    UIImageView *_bgImgv;
    UILabel *_titleLabel;
    UIImageView *_isFreeImg;
}
@end


@implementation JFHomeHotCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _bgImgv = [[UIImageView alloc] init];
        [_bgImgv YPB_addAnimationForImageAppearing];
        [self addSubview:_bgImgv];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14.];
        [self addSubview:_titleLabel];
        
        _isFreeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_freePlay_icon"]];
        [self addSubview:_isFreeImg];
        
        {
            [_bgImgv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self);
                make.height.mas_equalTo((kScreenWidth-25)/3*300 / 227.);
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bgImgv.mas_bottom).offset(5);
                make.left.equalTo(self).offset(5);
                make.right.equalTo(self).offset(-5);
                make.height.mas_equalTo(20);
            }];
            
            [_isFreeImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(30, 30));
            }];
        }

        
    }
    return self;
}

- (void)setImgUrl:(NSString *)imgUrl {
    [_bgImgv sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)setIsFree:(BOOL)isFree {
    _isFreeImg.hidden = !isFree;
}


@end
