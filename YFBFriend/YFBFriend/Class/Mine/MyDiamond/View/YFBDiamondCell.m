//
//  YFBDiamondCell.m
//  YFBFriend
//
//  Created by Liang on 2017/3/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDiamondCell.h"

@interface YFBDiamondCell ()
@property (nonatomic) UIImageView *imageV;
@property (nonatomic) UILabel *amountLabel;
@property (nonatomic) UILabel *priceLabel;
@property (nonatomic) UILabel *descLabel;
@property (nonatomic) UIButton *payButton;
@end

@implementation YFBDiamondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_diamond_icon"]];
        [self.contentView addSubview:_imageV];
        
        self.amountLabel = [[UILabel alloc] init];
        _amountLabel.font = kFont(15);
        _amountLabel.textColor = kColor(@"#333333");
        [self.contentView addSubview:_amountLabel];
        
        self.priceLabel = [[UILabel alloc] init];
        _priceLabel.font = kFont(15);
        _priceLabel.textColor = kColor(@"#333333");
        [self.contentView addSubview:_priceLabel];
        
        self.descLabel = [[UILabel alloc] init];
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
            [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(48), kWidth(40)));
            }];
            
            [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(_imageV.mas_right).offset(kWidth(12));
                make.height.mas_equalTo(_amountLabel.font.lineHeight);
            }];
            
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView.mas_centerY).offset(-kWidth(8));
                make.left.equalTo(self.contentView).offset(kWidth(288));
                make.height.mas_equalTo(_priceLabel.font.lineHeight);
            }];
            
            [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_centerY).offset(kWidth(8));
                make.left.equalTo(_priceLabel);
                make.height.mas_equalTo(_descLabel.font.lineHeight);
            }];
            
            [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(44));
                make.size.mas_equalTo(CGSizeMake(kWidth(160), kWidth(64)));
            }];
        }
        
    }
    return self;
}

- (void)setAmount:(NSString *)amount {
    _amountLabel.text = amount;
}

- (void)setPrice:(NSString *)price {
    _priceLabel.text = price;
}

- (void)setDesc:(NSString *)desc {
    _descLabel.text = desc;
}

@end
