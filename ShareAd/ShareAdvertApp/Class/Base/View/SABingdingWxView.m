//
//  SABingdingWxView.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/11.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SABingdingWxView.h"

@interface SABingdingWxView ()
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *noticeLabel;
@property (nonatomic) UILabel *typeLabel;
@property (nonatomic) UIButton *bindingButton;
@end

@implementation SABingdingWxView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = kColor(@"#ffffff");
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(13);
        _titleLabel.textColor = kColor(@"#666666");
        _titleLabel.text = @"温馨提示";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        self.noticeLabel = [[UILabel alloc] init];
        _noticeLabel.font = kFont(12);
        _noticeLabel.textColor = kColor(@"#333333");
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
        _noticeLabel.text = @"您尚未绑定含有您实名认证银行开的微信号，请绑定后进行提现。";
        _noticeLabel.numberOfLines = 2;
        [self addSubview:_noticeLabel];
        
        
        self.typeLabel = [[UILabel alloc] init];
        _typeLabel.font = kFont(12);
        _typeLabel.textColor = kColor(@"#333333");
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.text = @"提现金额将以微信打款的方式到您的账户";
        _typeLabel.numberOfLines = 2;
        [self addSubview:_typeLabel];
        
        self.bindingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bindingButton setTitle:@"绑定微信" forState:UIControlStateNormal];
        [_bindingButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        _bindingButton.titleLabel.font = kFont(14);
        _bindingButton.backgroundColor = kColor(@"#FF3366");
        [self addSubview:_bindingButton];
        
        @weakify(self);
        [_bindingButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.confirmAction) {
                self.confirmAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(kWidth(40));
                make.height.mas_equalTo(_titleLabel.font.lineHeight);
            }];
            
            [_noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_titleLabel.mas_bottom).offset(kWidth(64));
                make.size.mas_equalTo(CGSizeMake(kWidth(458), _noticeLabel.font.lineHeight*2));
            }];
            
            [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_noticeLabel.mas_bottom).offset(kWidth(32));
                make.size.mas_equalTo(CGSizeMake(kWidth(458), _typeLabel.font.lineHeight*2));
            }];
            
            [_bindingButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.mas_bottom).offset(-kWidth(34));
                make.size.mas_equalTo(CGSizeMake(kWidth(416), kWidth(72)));
            }];
        }
        
    }
    return self;
}

@end
