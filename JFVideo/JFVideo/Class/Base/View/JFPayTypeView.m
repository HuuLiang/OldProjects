//
//  JFPayTypeView.m
//  JFVideo
//
//  Created by Liang on 16/8/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPayTypeView.h"

@interface JFPayTypeView ()
{
    UIView *_wxView;
    UIView *_aliView;
    
}
@property (nonatomic)QBOrderPayType payType;
//@property (nonatomic)QBPaySubType subType;
@end

@implementation JFPayTypeView

- (instancetype)initWithPayTypesArray:(NSArray *)payTypes
{
    self = [super init];
    if (self) {
        
//        self.backgroundColor = [UIColor redColor];
        
        for (NSDictionary *dic in payTypes) {
            _payType = [dic[@"type"] integerValue];
//            _subType = [dic[@"subType"] integerValue];
            
            if (_payType == QBOrderPayTypeAlipay) {
                _aliView = [[UIView alloc] init];
                [self initWithPayTypeView:_aliView PayType:_payType];
            } else if (_payType == QBOrderPayTypeWeChatPay) {
                _wxView = [[UIView alloc] init];
                [self initWithPayTypeView:_wxView PayType:_payType];
            }
        }
        
        if (_wxView && _aliView) {
            [_wxView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(220), kWidth(70)));
            }];
            
            [_aliView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self.mas_right).offset(-kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(220), kWidth(70)));
            }];
        } else if (_wxView && !_aliView) {
            [_wxView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(400), kWidth(70)));
            }];
        } else {
            [_aliView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(400), kWidth(70)));
            }];
        }
        
        
        
    }
    return self;
}

- (void)initWithPayTypeView:(UIView *)view PayType:(QBOrderPayType)type {
    view.userInteractionEnabled = YES;
    view.layer.cornerRadius = kWidth(10);
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor colorWithHexString:type == QBOrderPayTypeAlipay ? @"#0090ff" : @"#08c20c"];
    
    UIImage *image = [UIImage imageNamed:type == QBOrderPayTypeAlipay ? @"pay_ali" : @"pay_weixin"];
    UIImageView * imgV = [[UIImageView alloc] initWithImage:image];
    [view addSubview:imgV];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = type == QBOrderPayTypeAlipay ? @"支付宝" : @"微信支付";
    label.textColor = [UIColor colorWithHexString:@"#ffffff"];
    label.font = [UIFont systemFontOfSize:kWidth(30)];
    [view addSubview:label];
    
    {
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.right.equalTo(view.mas_centerX).offset(-kWidth(40));
//            make.size.mas_equalTo(CGSizeMake(kWidth(image.size.width * 2), kWidth(image.size.height * 2)));
            make.size.mas_equalTo(CGSizeMake(kWidth(44), kWidth(37)));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(imgV.mas_right).offset(kWidth(20));
            make.height.mas_equalTo(kWidth(30));
        }];
    }
    
    
    @weakify(self);
    [view bk_whenTapped:^{
        @strongify(self);
        self.payAction(type);
    }];
    
    [self addSubview:view];

}



@end
