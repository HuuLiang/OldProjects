//
//  SADrawSuccessView.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/11.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SADrawSuccessView.h"

@interface SADrawSuccessView ()
@property (nonatomic) UIImageView *imgV;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *noticeLabel;
@property (nonatomic) UIButton *closeButton;
@end

@implementation SADrawSuccessView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = kColor(@"#ffffff");
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        
        self.imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_drawSuccess"]];
        [self addSubview:_imgV];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kColor(@"#333333");
        _titleLabel.font = kFont(16);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"您的提现已成功";
        [self addSubview:_titleLabel];
        
        self.noticeLabel = [[UILabel alloc] init];
        _noticeLabel.textColor = kColor(@"#333333");
        _noticeLabel.font = kFont(12);
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
        _noticeLabel.text = @"提现发放时间为每周四，请在打款后24小时左右对账核实。";
        _noticeLabel.numberOfLines = 2;
        [self addSubview:_noticeLabel];
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"知道了" forState:UIControlStateNormal];
        [_closeButton setTitleColor:kColor(@"#3584E0") forState:UIControlStateNormal];
        _closeButton.titleLabel.font = kFont(15);
        _closeButton.layer.borderWidth = 1.0f;
        _closeButton.layer.borderColor = kColor(@"#D8D8D8").CGColor;
        [self addSubview:_closeButton];
        
        @weakify(self);
        [_closeButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.compleAction) {
                self.compleAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(96), kWidth(96)));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_imgV.mas_bottom).offset(kWidth(22));
                make.height.mas_equalTo(_titleLabel.font.lineHeight);
            }];
            
            [_noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_titleLabel.mas_bottom).offset(kWidth(26));
                make.size.mas_equalTo(CGSizeMake(kWidth(458), _noticeLabel.font.lineHeight*2));
            }];
            
            [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.height.mas_equalTo(kWidth(80));
            }];
        }
        
    }
    return self;
}


@end
