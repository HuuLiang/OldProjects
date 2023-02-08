//
//  YFBMessagePayTypeCell.m
//  YFBFriend
//
//  Created by Liang on 2017/4/24.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessagePayTypeCell.h"
#import "YFBPayButton.h"

@interface YFBMessagePayTypeCell ()
@property (nonatomic,strong) UIButton *wxPayButton;
@property (nonatomic,strong) UIButton *aliPayButton;
@end


@implementation YFBMessagePayTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.wxPayButton = [YFBPayButton buttonWithType:UIButtonTypeCustom];
        [_wxPayButton setTitle:@"微信" forState:UIControlStateNormal];
        [_wxPayButton setTitleColor:kColor(@"") forState:UIControlStateNormal];
        _wxPayButton.backgroundColor = kColor(@"#00AC0A");
        _wxPayButton.layer.cornerRadius = 3;
        [_wxPayButton setImage:[UIImage imageNamed:@"message_wx"] forState:UIControlStateNormal];
        @weakify(self);
        [_wxPayButton bk_addEventHandler:^(id sender) {
            @strongify(self);
                if (self.payTypeAction) {
                    self.payTypeAction(@(YFBPayTypeWeiXin));
                }
        } forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_wxPayButton];
        
        self.aliPayButton = [YFBPayButton buttonWithType:UIButtonTypeCustom];
        [_aliPayButton setTitle:@"支付宝" forState:UIControlStateNormal];
        [_aliPayButton setTitleColor:kColor(@"") forState:UIControlStateNormal];
        _aliPayButton.backgroundColor = kColor(@"#49ABF5");
        _aliPayButton.layer.cornerRadius = 3;
        [_aliPayButton setImage:[UIImage imageNamed:@"message_ali"] forState:UIControlStateNormal];
        [_aliPayButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.payTypeAction) {
                self.payTypeAction(@(YFBPayTypeAliPay));
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_aliPayButton];
        
        {
            [_wxPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(self.contentView.mas_top).offset(kWidth(8));
                make.size.mas_equalTo(CGSizeMake(kWidth(450), kWidth(70)));
            }];
            
            
            [_aliPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(450), kWidth(70)));
            }];
        }
        
        [self.contentView.subviews enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *thisButton = (UIButton *)obj;
                thisButton.imageEdgeInsets = UIEdgeInsetsMake(thisButton.imageEdgeInsets.top, thisButton.imageEdgeInsets.left - 3, thisButton.imageEdgeInsets.bottom, thisButton.imageEdgeInsets.right + 3);
                thisButton.titleEdgeInsets = UIEdgeInsetsMake(thisButton.titleEdgeInsets.top, thisButton.titleEdgeInsets.left + 3, thisButton.titleEdgeInsets.bottom, thisButton.titleEdgeInsets.right - 3);
            }
        }];
    }
    return self;
}

@end
