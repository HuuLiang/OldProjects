//
//  SAMineCenterBalanceCell.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/7.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAMineCenterBalanceCell.h"

@interface SAMineCenterBalanceCell ()
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *balanceLabel;
@property (nonatomic) UIButton *withdrawButton;
@end


@implementation SAMineCenterBalanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"当前余额";
        _titleLabel.textColor = kColor(@"#666666");
        _titleLabel.font = kFont(14);
        [self.contentView addSubview:_titleLabel];
        
        self.balanceLabel = [[UILabel alloc] init];
        _balanceLabel.font = kFont(36);
        [self.contentView addSubview:_balanceLabel];
        
        self.withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_withdrawButton setTitle:@"立即提现" forState:UIControlStateNormal];
        [_withdrawButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        _withdrawButton.titleLabel.font = kFont(13);
        [_withdrawButton setBackgroundColor:kColor(@"#FF3366")];
        _withdrawButton.layer.cornerRadius = kWidth(32);
        [self.contentView addSubview:_withdrawButton];
        
        @weakify(self);
        [_withdrawButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.withDrawAction) {
                self.withDrawAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(34));
                make.top.equalTo(self.contentView).offset(kWidth(36));
                make.height.mas_equalTo(_titleLabel.font.lineHeight);
            }];
            
            [_balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_titleLabel);
                make.top.equalTo(_titleLabel.mas_bottom).offset(kWidth(10));
                make.height.mas_equalTo(_balanceLabel.font.lineHeight);
            }];
            
            [_withdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(160), kWidth(64)));
            }];
        }
        
    }
    return self;
}

- (void)setBalance:(NSString *)balance {
    NSString *fullStr = [NSString stringWithFormat:@"%@元",balance];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:fullStr attributes:@{NSFontAttributeName:kFont(36),NSForegroundColorAttributeName:kColor(@"#FF3366")}];
    [attriStr addAttributes:@{NSForegroundColorAttributeName:kColor(@"#2A2A2A")} range:[fullStr rangeOfString:@"元"]];
    _balanceLabel.attributedText = attriStr;
}

@end
