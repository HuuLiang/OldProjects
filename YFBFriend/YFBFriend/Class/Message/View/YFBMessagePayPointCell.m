//
//  YFBMessagePayPointCell.m
//  YFBFriend
//
//  Created by Liang on 2017/4/24.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessagePayPointCell.h"
#import "YFBPayButton.h"

@interface YFBMessagePayPointCell ()
@property (nonatomic,weak) UILabel *priceLabel;
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UILabel *descLabel;
@property (nonatomic,strong) UIButton *selectedButton;
@end

@implementation YFBMessagePayPointCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.textColor = kColor(@"#EB6894");
        priceLabel.font = kFont(20);
        [self.contentView addSubview:priceLabel];
        _priceLabel = priceLabel;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kColor(@"#333333");
        titleLabel.font = kFont(12);
        [self.contentView addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.textColor = kColor(@"#999999");
        descLabel.font = kFont(12);
        [self.contentView addSubview:descLabel];
        _descLabel = descLabel;
        
        self.selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedButton setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
        [self.contentView addSubview:_selectedButton];
        
        {
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(40));
                make.height.mas_equalTo(_priceLabel.font.lineHeight);
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView.mas_centerY).offset(-kWidth(4));
                make.left.equalTo(self.contentView.mas_left).offset(kWidth(180));
                make.height.mas_equalTo(_titleLabel.font.lineHeight);
            }];
            
            [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_centerY).offset(kWidth(4));
                make.left.equalTo(_titleLabel);
                make.height.mas_equalTo(_descLabel.font.lineHeight);
            }];
            
            [_selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(32), kWidth(32)));
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

- (void)setPrice:(NSString *)price {
    _priceLabel.text = price;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

- (void)setDescStr:(NSString *)descStr {
    _descLabel.text = descStr;
}

@end
