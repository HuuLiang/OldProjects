//
//  YFBShowPaySuccessView.m
//  YFBFriend
//
//  Created by ZF on 2017/6/10.
//  Copyright © 2017年 ZF. All rights reserved.
//

#import "YFBShowPaySuccessView.h"

@interface YFBShowPaySuccessView ()
@property (nonatomic) UIImageView *imgV;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *notiLabel;
@property (nonatomic) UIButton *button;
@property (nonatomic) UILabel *descLabel;
@end

@implementation YFBShowPaySuccessView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = kColor(@"#ffffff");
        
//        UIView *backView = [[UIView alloc] init];
//        backView.backgroundColor = kColor(@"#ffffff");
//        backView.layer.cornerRadius = 5;
//        [self addSubview:backView];
        
        self.imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_success"]];
        _imgV.layer.cornerRadius = kWidth(50);
        _imgV.layer.masksToBounds = YES;
        _imgV.layer.borderWidth = 2;
        _imgV.layer.borderColor = kColor(@"#ffffff").CGColor;
        [self addSubview:_imgV];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"交易成功";
        _titleLabel.textColor = kColor(@"#333333");
        _titleLabel.font = kFont(18);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        self.notiLabel = [[UILabel alloc] init];
        _notiLabel.text = @"请点击发布者右下角“我的微信”\n获取联系方式！";
        _notiLabel.textColor = kColor(@"#666666");
        _notiLabel.font = kFont(12);
        _notiLabel.textAlignment = NSTextAlignmentCenter;
        _notiLabel.numberOfLines = 2;
        [self addSubview:_notiLabel];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"我知道了" forState:UIControlStateNormal];
        [_button setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        _button.titleLabel.font = kFont(14);
        _button.layer.cornerRadius = 3;
        _button.backgroundColor = kColor(@"#8458D0");
        [self addSubview:_button];
        
        @weakify(self);
        [_button bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.confirmAction) {
                self.confirmAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        self.descLabel = [[UILabel alloc] init];
        _descLabel.text = @"同城秘友提醒您：文明交友，如发现涉嫌发布违规低俗内容，请及时联系官方QQ:3057185386";
        _descLabel.textColor = kColor(@"#666666");
        _descLabel.font = kFont(12);
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.numberOfLines = 0;
        [self addSubview:_descLabel];

        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.centerY.equalTo(self.mas_top);
                make.size.mas_equalTo(CGSizeMake(kWidth(100), kWidth(100)));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self.mas_top).offset(kWidth(70));
                make.height.mas_equalTo(_titleLabel.font.lineHeight);
            }];
            
            [_notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_titleLabel.mas_bottom).offset(kWidth(30));
                make.width.mas_equalTo(kWidth(450));
                make.height.mas_equalTo(_notiLabel.font.lineHeight * 2 + 2);
            }];
            
            [_button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_notiLabel.mas_bottom).offset(kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(320), kWidth(64)));
            }];
            
            [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.width.mas_equalTo(kWidth(470));
                make.top.equalTo(_button.mas_bottom).offset(kWidth(16));
            }];
        }
        
        
    }
    return self;
}

@end
