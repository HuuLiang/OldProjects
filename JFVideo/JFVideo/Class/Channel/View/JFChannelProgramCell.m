//
//  JFChannelProgramCell.m
//  JFVideo
//
//  Created by Liang on 16/7/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFChannelProgramCell.h"

@interface JFChannelProgramCell ()
{
    UIImageView *_bgImgv;
    UILabel *_titleLabel;
}
@end

@implementation JFChannelProgramCell
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
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(24)];
        [self addSubview:_titleLabel];
        {
            [_bgImgv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self);
                make.height.mas_equalTo(_bgImgv.mas_width).multipliedBy(300/227.);//((kScreenWidth-25/375.*kScreenWidth)/3 * 300 / 227.);
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bgImgv.mas_bottom);
                make.left.equalTo(self).offset(5/375.*kScreenWidth);
                make.right.equalTo(self).offset(-5/375.*kScreenWidth);
                make.bottom.equalTo(self);
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

@end
