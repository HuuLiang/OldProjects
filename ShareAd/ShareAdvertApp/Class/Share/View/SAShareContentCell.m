//
//  SAShareContentCell.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAShareContentCell.h"

@interface SAShareContentCell ()
@property (nonatomic) UIImageView *imgV;
@property (nonatomic) UILabel *specialLabel;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *priceLabel;
@property (nonatomic) UILabel *readLabel;
@property (nonatomic) UIButton *shareButton;
@end


@implementation SAShareContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.imgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgV];
        
        self.specialLabel = [[UILabel alloc] init];
        _specialLabel.font = kFont(12);
        _specialLabel.textAlignment = NSTextAlignmentCenter;
        _specialLabel.backgroundColor = [kColor(@"#FF3366") colorWithAlphaComponent:0.85];
        [_imgV addSubview:_specialLabel];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kColor(@"#333333");
        _titleLabel.font = kFont(14);
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        
        self.priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = kColor(@"#FF3366");
        _priceLabel.font = kFont(11);
        [self.contentView addSubview:_priceLabel];
        
        self.readLabel = [[UILabel alloc] init];
        _readLabel.textColor = kColor(@"#999999");
        _readLabel.font = kFont(11);
        [self.contentView addSubview:_readLabel];
        
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton setTitleColor:kColor(@"#FF3366") forState:UIControlStateNormal];
        _shareButton.titleLabel.font = kFont(12);
        [_shareButton setImage:[UIImage imageNamed:@"share_share"] forState:UIControlStateNormal];
        _shareButton.layer.cornerRadius = kWidth(28);
        _shareButton.layer.borderWidth = 0.5f;
        _shareButton.layer.borderColor = kColor(@"#FF3366").CGColor;
        [self.contentView addSubview:_shareButton];
        
        @weakify(self);
        [_shareButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.shareAction) {
                self.shareAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        _shareButton.imageEdgeInsets = UIEdgeInsetsMake(_shareButton.imageEdgeInsets.top, _shareButton.imageEdgeInsets.left, _shareButton.imageEdgeInsets.bottom, _shareButton.imageEdgeInsets.right);
        _shareButton.titleEdgeInsets = UIEdgeInsetsMake(_shareButton.titleEdgeInsets.top, _shareButton.titleEdgeInsets.left, _shareButton.titleEdgeInsets.bottom, _shareButton.titleEdgeInsets.right);
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(220), kWidth(160)));
            }];
            
            [_specialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(_imgV);
                make.height.mas_equalTo(_specialLabel.font.lineHeight);
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_imgV.mas_right).offset(kWidth(20));
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(20));
                make.top.equalTo(self.contentView).offset(kWidth(20));
            }];
            
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_titleLabel);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-kWidth(34));
                make.height.mas_equalTo(_priceLabel.font.lineHeight);
            }];
            
            [_readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_priceLabel.mas_right).offset(kWidth(20));
                make.centerY.equalTo(_priceLabel);
                make.height.mas_equalTo(_readLabel.font.lineHeight);
            }];
            
            [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(20));
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-kWidth(24));
                make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(52)));
            }];
        }
        
    }
    return self;
}

- (void)setImgUrl:(NSString *)imgUrl {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

- (void)setSpecilTitle:(NSString *)specilTitle {
    _specialLabel.text = specilTitle;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)setPrice:(NSString *)price {
    _priceLabel.text = price;
}

- (void)setRead:(NSString *)read {
    _readLabel.text = read;
}


@end
