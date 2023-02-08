//
//  JYRedPacketView.m
//  JYFriend
//
//  Created by ylz on 2017/1/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYRedPacketView.h"

@interface JYRedPacketView ()
{
    UIImageView *_bacImageView;
    UIButton *_sendPacketBtn;
    UIButton *_ktVipBtn;
    UIButton *_closeBtn;
    UILabel *_priceLabel;
}

@end

@implementation JYRedPacketView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.35 alpha:0.4];
        @weakify(self);
        _bacImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dynamic_red_packet"]];
        [self addSubview:_bacImageView];
        {
        [_bacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self).mas_offset(kWidth(-100));
            make.size.mas_equalTo(CGSizeMake(kWidth(480), kWidth(720)));
        }];
        }
        _ktVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ktVipBtn setTitle:@"包月更优惠" forState:UIControlStateNormal];
        _ktVipBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _ktVipBtn.backgroundColor = [UIColor redColor];
        _ktVipBtn.layer.borderWidth = 1.;
        _ktVipBtn.layer.borderColor = kColor(@"#F4E822").CGColor;
        [self addSubview:_ktVipBtn];
        {
        [_ktVipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bacImageView);
            make.bottom.mas_equalTo(_bacImageView).mas_offset(kWidth(-60));
            make.size.mas_equalTo(CGSizeMake(kWidth(300), kWidth(56.)));
        }];
        }
        
        [_ktVipBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.ktVipAction) {
                self.ktVipAction(sender);
            }
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        
        _sendPacketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendPacketBtn setTitle:@"发红包" forState:UIControlStateNormal];
        [_sendPacketBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _sendPacketBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _sendPacketBtn.backgroundColor = [UIColor colorWithHexString:@"#F4E822"];
        [self addSubview:_sendPacketBtn];
        {
        [_sendPacketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_ktVipBtn.mas_top).mas_offset(kWidth(-10));
            make.centerX.mas_equalTo(_bacImageView);
            make.size.mas_equalTo(_ktVipBtn);
        }];
        }
        [_sendPacketBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.sendPacketAction) {
                self.sendPacketAction(sender);
            }
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = [UIFont systemFontOfSize:kWidth(88.)];
        [self addSubview:_priceLabel];
        {
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bacImageView);
            make.top.mas_equalTo(_bacImageView).mas_offset(kWidth(92));
        }];
        
        }
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"dynamic_close_icon"] forState:UIControlStateNormal];
        [self addSubview:_closeBtn];
        {
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_bacImageView.mas_top);
            make.right.mas_equalTo(_bacImageView).mas_offset(kWidth(-35));
            make.size.mas_equalTo(CGSizeMake(kWidth(40), kWidth(82)));
        }];
        }
        
        [_closeBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.closeAction) {
                self.closeAction(self);
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setPrice:(NSInteger)price {
    _price = price;
  NSString *priceStr = [NSString stringWithFormat:@"¥%zd",price];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [str addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kWidth(40)]} range:NSMakeRange(0, 1)];
    _priceLabel.attributedText = str;

}


@end
