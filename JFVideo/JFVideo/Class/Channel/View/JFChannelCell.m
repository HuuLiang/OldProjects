//
//  JFChannelCell.m
//  JFVideo
//
//  Created by Liang on 16/7/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFChannelCell.h"

@interface JFChannelCell ()
{
    UIImageView *_bgImgv;
    UIImageView *_imageV;
    
    UIImageView *_rankImgV;
    UILabel *_rankLabel;
    
    UIImageView*_titleImgV;
    UILabel *_titleLabel;
    
    UIImageView *_hotImgv;
    UILabel *_hotLabel;
}
@end

@implementation JFChannelCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"channel_bgimg_icon"]];
//        _imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageV];
        
        _bgImgv = [[UIImageView alloc] init];
        _bgImgv.layer.cornerRadius = kScreenHeight * 8 / 1334.;
        _bgImgv.layer.masksToBounds = YES;
        [_bgImgv YPB_addAnimationForImageAppearing];
        [self addSubview:_bgImgv];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.35];
        bgView.layer.masksToBounds = YES;
        [_bgImgv addSubview:bgView];
        
        _rankImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"channel_rank_icon"]];
        [self addSubview:_rankImgV];
        
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _rankLabel.font = [UIFont systemFontOfSize:kScreenWidth * 28 / 750.];
        [self addSubview:_rankLabel];
        
        _titleImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"channel_titleimg_icon"]];
        [self addSubview:_titleImgV];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:kScreenHeight * 28 /1334.];
        [_titleImgV addSubview:_titleLabel];
        
        _hotImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"channel_hot_icon"]];
        [self addSubview:_hotImgv];
        
        _hotLabel = [[UILabel alloc] init];
        _hotLabel.textColor = [UIColor colorWithHexString:@"#d2d2d2"];
        _hotLabel.font = [UIFont systemFontOfSize:kScreenWidth * 20 / 750.];
        [self addSubview:_hotLabel];
        
        {
            
            [_bgImgv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self);

                //                make.size.mas_equalTo(CGSizeMake(kScreenWidth * 360 / 750., MAX(kScreenHeight * 452 / 1334., 190)));
                make.width.mas_equalTo(_bgImgv.mas_width).multipliedBy(360/336.);
                make.height.mas_equalTo(_bgImgv.mas_height).multipliedBy(452/432.);
                
            }];
            
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_bgImgv);
            }];
            
            [_rankImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kScreenWidth * 10 / 750.);
                make.top.equalTo(self).offset(kScreenHeight * 10 / 1334.);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth * 29./750, kScreenHeight * 32./1334.));
            }];
            
            [_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_rankImgV.mas_right).offset(kScreenWidth * 10 /750.);
                make.centerY.equalTo(_rankImgV);
                make.height.mas_equalTo(kScreenHeight * 34 / 1334.);
            }];
            
            [_titleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self).offset(-kScreenHeight * 60 / 1334.);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth * 220./750, kScreenHeight * 71./1334.));
            }];
    
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(_titleImgV);
                make.left.equalTo(_titleImgV).offset(3);
                make.right.equalTo(_titleImgV).offset(-3);
                make.height.mas_equalTo(kScreenHeight * 60 / 1334.);
            }];
            
            [_hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-kScreenWidth * 10 /750.);
                make.bottom.equalTo(self).offset(-kScreenHeight * 10 / 1334.);
                make.height.mas_equalTo(kScreenHeight * 30 / 1334.);
            }];
            
            [_hotImgv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_hotLabel.mas_left).offset(-kScreenWidth * 10 /750.);
                make.centerY.equalTo(_hotLabel);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth * 26./750, kScreenHeight * 34./1334.));
                
            }];
        }
    }
    return self;
}

- (void)setRankCount:(NSInteger)rankCount {
    if (rankCount == 0 || rankCount == 1 || rankCount == 2) {
        _rankLabel.hidden = NO;
        _rankImgV.hidden = NO;
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"NO.%ld",rankCount+1]];
        NSRange rankRange = [attr.string rangeOfString:[NSString stringWithFormat:@"%ld",rankCount+1]];
        [attr addAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:kScreenWidth * 30 /750.]} range:rankRange];
        _rankLabel.attributedText = attr;
    } else {
        _rankImgV.hidden = YES;
        _rankLabel.hidden = YES;
    }
}

- (void)setImgUrl:(NSString *)imgUrl {
    [_bgImgv sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = [NSString stringWithFormat:@"%@视频集",title];
    CGFloat widht = [_titleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:kScreenHeight * 28 /1334.] maxSize:CGSizeMake(MAXFLOAT, kScreenHeight * 60 / 1334.)].width;
    [_titleImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-kScreenHeight * 60 / 1334.);
        make.size.mas_equalTo(CGSizeMake(widht + 15, kScreenHeight * 71./1334.));
    }];
}

-(void)setHotCount:(NSString *)hotCount {
    _hotLabel.text = hotCount;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    DLog(@"%@ %f",NSStringFromCGSize(_imageV.frame.size),kScreenHeight * 452 / 1334.);
    DLog(@"%@",NSStringFromCGSize(_bgImgv.frame.size));
    DLog(@"%@",NSStringFromCGSize(self.frame.size));
}

@end
