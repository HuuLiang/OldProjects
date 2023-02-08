//
//  SABalanceCell.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SABalanceCell.h"

@interface SABalanceCell ()
@property (nonatomic) UILabel *priceLabel;
@property (nonatomic) UIImageView *selectedImgV;
@end

@implementation SABalanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = kColor(@"#666666");
        _priceLabel.font = kFont(13);
        [self.contentView addSubview:_priceLabel];
        
        self.selectedImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_normal"]];
        [self.contentView addSubview:_selectedImgV];
        
        {
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(80));
                make.height.mas_equalTo(_priceLabel.font.lineHeight);
            }];
            
            [_selectedImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(80));
                make.size.mas_equalTo(CGSizeMake(kWidth(32), kWidth(32)));
            }];
        }
    }
    return self;
}

- (void)setPrice:(NSInteger)price {
    _priceLabel.text = [NSString stringWithFormat:@"%ld元",price/100];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    NSString *imgName = selected ? @"mine_selected" : @"mine_normal";
    _selectedImgV.image = [UIImage imageNamed:imgName];
}

@end
