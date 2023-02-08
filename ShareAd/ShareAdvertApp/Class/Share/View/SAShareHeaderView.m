//
//  SAShareHeaderView.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAShareHeaderView.h"

@interface SAShareHeaderView ()

/** 标题 */
@property (nonatomic) UILabel *titleLabel;
/** 余额 */
@property (nonatomic) UILabel *balanceLabel;
/** 今日收徒 */
@property (nonatomic) UILabel *toRecruitLabel;
/** 今日收入 */
@property (nonatomic) UILabel *toEarningsLabel;
/**  分割线  */
@property (nonatomic) UIImageView *lineV;

@end

@implementation SAShareHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kColor(@"#FF3366");
//        self.backgroundColor = [UIColor greenColor];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"当前余额";
        _titleLabel.font = kFont(14);
        _titleLabel.textColor = [kColor(@"#ffffff") colorWithAlphaComponent:0.65];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        self.balanceLabel = [[UILabel alloc] init];
        _balanceLabel.textColor = kColor(@"#ffffff");
        _balanceLabel.textAlignment = NSTextAlignmentCenter;
        _balanceLabel.font = kFont(50);
        [self addSubview:_balanceLabel];
        
        self.lineV = [[UIImageView alloc] init];
        _lineV.backgroundColor = [kColor(@"#ffffff") colorWithAlphaComponent:0.4];
        [self addSubview:_lineV];
        
        self.toRecruitLabel = [[UILabel alloc] init];
        _toRecruitLabel.textColor = kColor(@"#ffffff");
        _toRecruitLabel.font = kFont(14);
        _toRecruitLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_toRecruitLabel];
        
        
        self.toEarningsLabel = [[UILabel alloc] init];
        _toEarningsLabel.textColor = kColor(@"#ffffff");
        _toEarningsLabel.font = kFont(14);
        _toEarningsLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_toEarningsLabel];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(kWidth(44));
                make.height.mas_equalTo(_titleLabel.font.lineHeight);
            }];
            
            [_balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_titleLabel.mas_bottom).offset(kWidth(24));
                make.height.mas_equalTo(_balanceLabel.font.lineHeight);
            }];
            
            [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self.mas_bottom).offset(-kWidth(60));
                make.size.mas_equalTo(CGSizeMake(1, kWidth(28)));
            }];
            
            [_toRecruitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_lineV);
                make.right.equalTo(_lineV.mas_left).offset(-kWidth(26));
                make.height.mas_equalTo(_toRecruitLabel.font.lineHeight);
            }];
            
            [_toEarningsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_lineV);
                make.left.equalTo(_lineV.mas_right).offset(kWidth(26));
                make.height.mas_equalTo(_toEarningsLabel.font.lineHeight);
            }];
        }
        
    }
    return self;
}

- (void)setBalance:(NSInteger)balance {
    _balanceLabel.text = [NSString stringWithFormat:@"%.2f",(float)balance/100];
}

- (void)setToRecruit:(NSInteger)toRecruit {
    _toRecruitLabel.text = [NSString stringWithFormat:@"今日收徒 %ld 人",toRecruit];
}

- (void)setToEarnings:(NSInteger)toEarnings {
    _toEarningsLabel.text = [NSString stringWithFormat:@"今日收入 %.2f 元",(float)toEarnings/100];
}

@end
