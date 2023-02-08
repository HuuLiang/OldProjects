//
//  YFBBuyVipCell.m
//  YFBFriend
//
//  Created by Liang on 2017/5/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBuyVipCell.h"
#import "YFBPayConfigManager.h"

@interface YFBBuyVipCell ()
@property (nonatomic) UIImageView *imgV;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *priceLabel;
@property (nonatomic) UILabel *descLabel;
@property (nonatomic) UIButton *payButton;
@end

@implementation YFBBuyVipCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.imgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgV];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(15);
        _titleLabel.textColor = kColor(@"#333333");
        [self.contentView addSubview:_titleLabel];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = kColor(@"#EB6894");
        _priceLabel.font = kFont(14);
        [self.contentView addSubview:_priceLabel];
        
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = kFont(12);
        _descLabel.textColor = kColor(@"#EB6894");
        [self.contentView addSubview:_descLabel];
        
        self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [_payButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        _payButton.titleLabel.font = kFont(14);
        _payButton.layer.cornerRadius = 3;
        _payButton.backgroundColor = kColor(@"#EB6894");
        [self.contentView addSubview:_payButton];
        
        @weakify(self);
        [_payButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.payAction) {
                self.payAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(26));
                make.size.mas_equalTo(CGSizeMake(kWidth(60), kWidth(52)));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(114));
                make.top.equalTo(self.contentView).offset(kWidth(30));
                make.height.mas_equalTo(_titleLabel.font.lineHeight);
            }];
            
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_titleLabel);
                make.top.equalTo(_titleLabel.mas_bottom).offset(kWidth(14));
                make.height.mas_equalTo(_priceLabel.font.lineHeight);
            }];
            
            [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_priceLabel);
                make.top.equalTo(_priceLabel.mas_bottom).offset(kWidth(6));
                make.height.mas_equalTo(_descLabel.font.lineHeight);
            }];
            
            [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(20));
                make.centerY.equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(kWidth(160), kWidth(64)));
            }];
        }
    }
    return self;
}

- (void)setVipType:(YFBBuyVipType)vipType {
    if (vipType == YFBBuyVipTypeGold) {
        _imgV.image = [UIImage imageNamed:@"vip_gold"];
        _titleLabel.text = @"黄金";
        _priceLabel.text = [NSString stringWithFormat:@"%@ ¥%ld",[YFBPayConfigManager manager].vipInfo.secondInfo.vipDesc,(long)([YFBPayConfigManager manager].vipInfo.secondInfo.price/100)];
        _descLabel.text = [YFBPayConfigManager manager].vipInfo.secondInfo.title;
    } else if (vipType == YFBBuyVipTypeSliver) {
        _imgV.image = [UIImage imageNamed:@"vip_sliver"];
        _titleLabel.text = @"白银";
        _priceLabel.text = [NSString stringWithFormat:@"%@ ¥%ld",[YFBPayConfigManager manager].vipInfo.firstInfo.vipDesc,(long)([YFBPayConfigManager manager].vipInfo.firstInfo.price/100)];
        _descLabel.text = [YFBPayConfigManager manager].vipInfo.firstInfo.title;
    }
}

@end
