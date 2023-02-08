//
//  JYPayTypeCell.m
//  JYFriend
//
//  Created by ylz on 2017/1/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYPayTypeCell.h"

@interface JYPayTypeCell ()
{
    UIButton *_payButton;
}
@end

@implementation JYPayTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:[JYUtil isIpad] ? 36 : kWidth(36)];
        _payButton.layer.cornerRadius = [JYUtil isIpad] ? 10 : kWidth(10);
        _payButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_payButton];
        
        {
            [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.centerY.equalTo(self.contentView.mas_centerY).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(360), kWidth(88)));
            }];
        }
        
        @weakify(self);
        [_payButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.payAction) {
                self.payAction(@(_orderPayType));
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setOrderPayType:(QBOrderPayType)orderPayType {
    _orderPayType = orderPayType;
    if (orderPayType == QBOrderPayTypeWeChatPay) {
        [_payButton setTitle:@"微信支付" forState:UIControlStateNormal];
        _payButton.backgroundColor = [UIColor colorWithHexString:@"#72BC22"];
    } else if (orderPayType == QBOrderPayTypeAlipay) {
        [_payButton setTitle:@"支付宝支付" forState:UIControlStateNormal];
        _payButton.backgroundColor = [UIColor colorWithHexString:@"#4A90E2"];
    }
}


@end
