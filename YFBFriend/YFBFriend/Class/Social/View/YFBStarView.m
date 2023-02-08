//
//  YFBStarView.m
//  YFBFriend
//
//  Created by ZF on 2017/6/7.
//  Copyright © 2017年 ZF. All rights reserved.
//

#import "YFBStarView.h"

@interface YFBStarView ()
@property (nonatomic) UIImageView *star1;
@property (nonatomic) UIImageView *star2;
@property (nonatomic) UIImageView *star3;
@property (nonatomic) UIImageView *star4;
@property (nonatomic) UIImageView *star5;
@end

@implementation YFBStarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.star1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_normal"]];
        [self addSubview:_star1];
        
        self.star2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_normal"]];
        [self addSubview:_star2];
        
        self.star3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_normal"]];
        [self addSubview:_star3];
        
        self.star4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_normal"]];
        [self addSubview:_star4];
        
        self.star5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_normal"]];
        [self addSubview:_star5];
        
        
        {
            [_star1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(22), kWidth(22)));
            }];
            
            [_star2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(kWidth(28));
                make.size.mas_equalTo(CGSizeMake(kWidth(22), kWidth(22)));
            }];

            [_star3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(kWidth(28*2));
                make.size.mas_equalTo(CGSizeMake(kWidth(22), kWidth(22)));
            }];

            [_star4 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(kWidth(28*3));
                make.size.mas_equalTo(CGSizeMake(kWidth(22), kWidth(22)));
            }];

            [_star5 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(kWidth(28*4));
                make.size.mas_equalTo(CGSizeMake(kWidth(22), kWidth(22)));
            }];
        }
        
    }
    return self;
}

- (void)setRate:(NSInteger)rate {
    
    [self.subviews enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *starImgV = (UIImageView *)obj;
            starImgV.image = [UIImage imageNamed:@"star_normal"];
        }
    }];
    
    if (rate >= 1) {
        _star1.image = [UIImage imageNamed:@"star_selected"];
    }
    if (rate >= 2) {
        _star2.image = [UIImage imageNamed:@"star_selected"];
    }
    if (rate >= 3) {
        _star3.image = [UIImage imageNamed:@"star_selected"];
    }
    if (rate >= 4) {
        _star4.image = [UIImage imageNamed:@"star_selected"];
    }
    if (rate >= 5) {
        _star5.image = [UIImage imageNamed:@"star_selected"];
    }
}

@end
