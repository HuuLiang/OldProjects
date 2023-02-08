//
//  YFBGreetingHeaderView.m
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBGreetingHeaderView.h"

@interface YFBGreetingHeaderView ()
@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) UIView      *shadowView;
@property (nonatomic,strong) UIImageView *frontImageView;
@property (nonatomic,strong) UIButton    *greetingButton;
@property (nonatomic,strong) UILabel     *greetingLabel;
@end

@implementation YFBGreetingHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backImageView = [[UIImageView alloc] init];
        [self addSubview:_backImageView];
        
        self.shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [kColor(@"#ffffff") colorWithAlphaComponent:0.58];
        [_backImageView addSubview:_shadowView];
        
        self.frontImageView = [[UIImageView alloc] init];
        _frontImageView.layer.cornerRadius = kWidth(145);
        _frontImageView.layer.masksToBounds = YES;
        [_backImageView addSubview:_frontImageView];
        
        self.greetingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_greetingButton setTitle:@"一键打招呼" forState:UIControlStateNormal];
        [_greetingButton setTitleColor:kColor(@"") forState:UIControlStateNormal];
        _greetingButton.titleLabel.font = kFont(15);
        _greetingButton.backgroundColor = kColor(@"#8458D0");
        [self addSubview:_greetingButton];
        @weakify(self);
        [_greetingButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.greeingBlock) {
                self.greeingBlock();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        self.greetingLabel = [[UILabel alloc] init];
        _greetingLabel.text = @"一键给她们打招呼";
        _greetingLabel.textColor = kColor(@"#999999");
        _greetingLabel.font = kFont(14);
        _greetingLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_greetingLabel];
        
        {
            [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(kWidth(12));
                make.size.mas_equalTo(CGSizeMake(kWidth(334*2), kWidth(221*2)));
            }];
            
            [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_backImageView);
            }];
            
            [_frontImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_backImageView);
                make.size.mas_equalTo(CGSizeMake(kWidth(145*2), kWidth(145*2)));
            }];
            
            [_greetingButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_backImageView.mas_bottom).offset(kWidth(10));
                make.size.mas_equalTo(CGSizeMake(kWidth(334*2), kWidth(40*2)));
            }];
            
            [_greetingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.mas_bottom);
                make.height.mas_equalTo(kWidth(30));
            }];
        }
    }
    return self;
}

- (void)setBackImageUrl:(NSString *)backImageUrl {
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:backImageUrl]];
}

- (void)setFrontImageUrl:(NSString *)frontImageUrl {
    [_frontImageView sd_setImageWithURL:[NSURL URLWithString:frontImageUrl]];
}

@end
