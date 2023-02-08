//
//  YFBBuyServerCell.m
//  YFBFriend
//
//  Created by ZF on 2017/6/9.
//  Copyright © 2017年 ZF. All rights reserved.
//

#import "YFBBuyServerCell.h"

@interface YFBBuyServerCell ()
@property (nonatomic) UIImageView *imgV;
@property (nonatomic) UILabel * optionLabel;
@property (nonatomic) UILabel * descLabel;
@property (nonatomic) UIButton *selectedButton;
@property (nonatomic) UILabel *priceLabel;
@property (nonatomic) UILabel *originalPriceLabel;
@end

@implementation YFBBuyServerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = kColor(@"#ffffff");
        self.contentView.backgroundColor = kColor(@"#ffffff");
        
        self.imgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgV];
        
        self.optionLabel = [[UILabel alloc] init];
        _optionLabel.textColor = kColor(@"#333333");
        _optionLabel.font = kFont(12);
        [self.contentView addSubview:_optionLabel];
        
        self.descLabel = [[UILabel alloc] init];
        _descLabel.textColor = kColor(@"#B3B3B3");
        _descLabel.font = kFont(12);
        [self.contentView addSubview:_descLabel];
        
        self.selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedButton setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
        [self.contentView addSubview:_selectedButton];
        
        self.priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = kColor(@"#DC2C41");
        _priceLabel.font = kFont(16);
        _priceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_priceLabel];
        
        self.originalPriceLabel = [[UILabel alloc] init];
        _originalPriceLabel.textColor = kColor(@"#B3B3B3");
        _originalPriceLabel.font = kFont(12);
        _originalPriceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_originalPriceLabel];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(56), kWidth(56)));
            }];
            
            [_optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_imgV.mas_right).offset(kWidth(18));
                make.top.equalTo(_imgV);
                make.height.mas_equalTo(_optionLabel.font.lineHeight);
            }];
            
            [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_optionLabel);
                make.bottom.equalTo(_imgV);
                make.height.mas_equalTo(_descLabel.font.lineHeight);
            }];
            
            [_selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(32), kWidth(32)));
            }];
            
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(_selectedButton.mas_left).offset(-kWidth(30));
                make.height.mas_equalTo(_priceLabel.font.lineHeight);
            }];
            
            [_originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(_priceLabel.mas_left).offset(-kWidth(10));
                make.height.mas_equalTo(_originalPriceLabel.font.lineHeight);
            }];
        }
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        [_selectedButton setImage:[UIImage imageNamed:@"pay_selected"] forState:UIControlStateNormal];
    } else {
        [_selectedButton setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
    }
    
}

- (void)setImgUrl:(NSString *)imgUrl {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

- (void)setOption:(NSString *)option {
    _optionLabel.text = option;
}

- (void)setDesc:(NSString *)desc {
    _descLabel.text = desc;
}

- (void)setPrice:(NSInteger)price {
    _priceLabel.text = [NSString stringWithFormat:@"¥%ld",(long)(price/100)];
}

- (void)setOriginalPrice:(NSInteger)originalPrice {
    if (originalPrice == 0) {
        return;
    }
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)(originalPrice/100)] attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    _originalPriceLabel.attributedText = attri;
}

@end
