//
//  YFBMessageDiamondCategoryCell.m
//  YFBFriend
//
//  Created by Liang on 2017/4/25.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessageDiamondCategoryCell.h"

@interface YFBMessageDiamondCategoryCell ()
@property (nonatomic) UIImageView *diamondImageView;
@property (nonatomic) UILabel *diamondLabel;
@property (nonatomic) UILabel *priceLabel;
@property (nonatomic) UIImageView *selectedImageView;
@end

@implementation YFBMessageDiamondCategoryCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView.backgroundColor = kColor(@"#E6E6E6");
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = kColor(@"#C8C9CA").CGColor;
        
        self.diamondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_diamond_icon"]];
        [self.contentView addSubview:_diamondImageView];
        
        self.diamondLabel = [[UILabel alloc] init];
        _diamondLabel.textColor = [kColor(@"#333333") colorWithAlphaComponent:0.87];
        _diamondLabel.font = kFont(14);
        [self.contentView addSubview:_diamondLabel];
        
        self.priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = kColor(@"#74A5F6");
        _priceLabel.font = kFont(14);
        [self.contentView addSubview:_priceLabel];
        
        self.selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_pay_normal_icon"]];
        [self.contentView addSubview:_selectedImageView];
        
        {
            [_diamondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(16));
                make.size.mas_equalTo(CGSizeMake(kWidth(44), kWidth(36)));
            }];
            
            [_diamondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(_diamondImageView.mas_right).offset(kWidth(6));
                make.height.mas_equalTo(kWidth(24));
            }];
            
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(24));
                make.centerY.equalTo(self.contentView);
                make.height.mas_equalTo(kWidth(24));
            }];
            
            [_selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right);
                make.size.mas_equalTo(CGSizeMake(kWidth(40), kWidth(40)));
            }];
        }
    }
    return self;
}

- (void)setDiamondCount:(NSString *)diamondCount {
    _diamondLabel.text = diamondCount;
}

- (void)setPrice:(NSString *)price {
    _priceLabel.text = price;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        _selectedImageView.image = [UIImage imageNamed:@"mine_pay_selcte_icon"];
        self.contentView.backgroundColor = kColor(@"#FFFDE4");
        self.contentView.layer.borderColor = kColor(@"#F64152").CGColor;
    } else {
        _selectedImageView.image = [UIImage imageNamed:@"mine_pay_normal_icon"];
        self.contentView.backgroundColor = kColor(@"#E6E6E6");
        self.contentView.layer.borderColor = kColor(@"#C8C9CA").CGColor;
    }
}

@end
