//
//  YFBMessageDiamondPayTypeCell.m
//  YFBFriend
//
//  Created by Liang on 2017/4/25.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessageDiamondPayTypeCell.h"

@interface YFBMessageDiamondPayTypeCell ()
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *label;
@property (nonatomic) UIImageView *selectedImageView;
@end

@implementation YFBMessageDiamondPayTypeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = kColor(@"#E6E6E6");
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.borderWidth  = 1;
        self.contentView.layer.borderColor  = kColor(@"#C8C9CA").CGColor;
        
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        
        self.label = [[UILabel alloc] init];
        _label.textColor = kColor(@"#333333");
        _label.font = kFont(14);
        [self.contentView addSubview:_label];
        
        self.selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_pay_normal_icon"]];
        [self.contentView addSubview:_selectedImageView];
        
        {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(60));
                make.centerY.equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(kWidth(52), kWidth(52)));
            }];
            
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(_imageView.mas_right).offset(kWidth(6));
                make.height.mas_equalTo(kWidth(40));
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

- (void)setPayType:(YFBPayType)payType {
    if (payType == YFBPayTypeWeiXin) {
        _imageView.image = [UIImage imageNamed:@"mine_wechat_pay_icon"];
        _label.text = @"微信支付";
        _label.textColor = kColor(@"#F63F50");
    } else if (payType == YFBPayTypeAliPay) {
        _imageView.image = [UIImage imageNamed:@"mine_alipay_icon"];
        _label.text = @"支付宝";
        _label.textColor = kColor(@"#333333");
    }
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.contentView.backgroundColor = kColor(@"#FFFDE4");
        self.contentView.layer.borderColor  = kColor(@"#F64152").CGColor;
        _label.textColor = kColor(@"#F63F50");
        _selectedImageView.image = [UIImage imageNamed:@"mine_pay_selcte_icon"];
    } else {
        self.contentView.backgroundColor = kColor(@"#E6E6E6");
        self.contentView.layer.borderColor  = kColor(@"#C8C9CA").CGColor;
        _label.textColor = kColor(@"#333333");
        _selectedImageView.image = [UIImage imageNamed:@"mine_pay_normal_icon"];
    }
}

@end
