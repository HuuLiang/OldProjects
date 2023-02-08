//
//  JYDetailUserInfoCell.m
//  JYFriend
//
//  Created by ylz on 2016/12/27.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYDetailUserInfoCell.h"

@interface JYDetailUserInfoCell ()

@property (nonatomic,retain) UILabel *titleLabel;
//@property (nonatomic,retain) UILabel *detailLabel;
@property (nonatomic,retain) UIButton *vipBtn;

@end

@implementation JYDetailUserInfoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:kWidth(35.)];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self addSubview:_titleLabel];
    {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).mas_offset(kWidth(5));
        make.left.mas_equalTo(self).mas_offset(kWidth(30));
        make.right.mas_equalTo(self).mas_offset(kWidth(-30.));
        make.height.mas_equalTo(kWidth(35.));
    }];
    }
    
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (_detailLabel) {
        return _detailLabel;
    }
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.font = [UIFont systemFontOfSize:kWidth(28.)];
    _detailLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _detailLabel.numberOfLines = 0;
    [self addSubview:_detailLabel];
    {
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(self).mas_offset(kWidth(30));
            make.right.mas_equalTo(self).mas_offset(kWidth(-30.));
//            make.height.mas_equalTo(kWidth(32.));
        }];
    }
    
    return _detailLabel;

}

- (UIButton *)vipBtn {
    if (_vipBtn) {
        return _vipBtn;
    }
    _vipBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    _vipBtn.backgroundColor = [UIColor colorWithHexString:@"#e147a5"];
//    if (![JYUtil isVip]) {
//        [_vipBtn setTitle:@"成为VIP" forState:UIControlStateNormal];
//    }else{
//        [_vipBtn setTitle:@"续费VIP" forState:UIControlStateNormal];
//    }
    [_vipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _vipBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(24.)];
    _vipBtn.layer.cornerRadius = 3.;
    _vipBtn.clipsToBounds = YES;
    [self addSubview:_vipBtn];
    {
    [_vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self).mas_offset(kWidth(-30));
        make.size.mas_equalTo(CGSizeMake(kWidth(170), kWidth(64)));
    }];
    }
    @weakify(self);
    [_vipBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        if (self.vipAction) {
            self.vipAction(sender);
        }
    } forControlEvents:UIControlEventTouchUpInside];
    return _vipBtn;
}


- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setDetailTitle:(NSString *)detailTitle {
    _detailTitle = detailTitle;
    self.detailLabel.text = detailTitle;
}

- (void)setVipTitle:(NSString *)vipTitle {
    _vipTitle = vipTitle;
    if (vipTitle) {
        [self.vipBtn setTitle:vipTitle forState:UIControlStateNormal];
        _vipBtn.hidden = NO;
    }
//    else {
//        if (_vipBtn) {
//            _vipBtn.hidden = YES;
//            [_vipBtn removeFromSuperview];
//        }
//    }

}

@end
