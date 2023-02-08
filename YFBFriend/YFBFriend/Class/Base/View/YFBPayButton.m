//
//  YFBPayButton.m
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBPayButton.h"

@interface YFBPayButton ()
@property (nonatomic) UILabel *label;
@property (nonatomic) UILabel *subTitleLabel;
@property (nonatomic) UILabel *detailLabel;
@property (nonatomic) UIImageView *selectImageView;
@end

@implementation YFBPayButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kColor(@"#f4f4f4");
        self.layer.borderWidth = 1;
        self.layer.borderColor = kColor(@"#e0e0e0").CGColor;
        self.layer.cornerRadius = 5;
        [self clipsToBounds];
        _selectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_pay_selcte_icon"]];
        [self addSubview:_selectImageView];
        {
            [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.mas_equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(40), kWidth(40)));
            }];
        }
        _selectImageView.hidden = YES;
    }
    return self;
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        _selectImageView.hidden = NO;
        self.backgroundColor = kColor(@"#f3eaea");
        self.layer.borderWidth = 1;
        self.layer.borderColor = kColor(@"#f34254").CGColor;
        
    }else{
        _selectImageView.hidden = YES;
        self.backgroundColor = kColor(@"#f4f4f4");
        self.layer.borderWidth = 1;
        self.layer.borderColor = kColor(@"#e0e0e0").CGColor;
    }
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    _label = [[UILabel alloc] init];
    _label.text = title;
    _label.font = kFont(18);
    _label.textColor = kColor(@"#000000");
    _label.textAlignment = NSTextAlignmentCenter;
    _label.backgroundColor = [UIColor clearColor];
    [self addSubview:_label];
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    
    _subTitleLabel = [[UILabel alloc] init];
    _subTitleLabel.font = kFont(18);
    _subTitleLabel.text = subTitle;
    _subTitleLabel.textColor = kColor(@"#666666");
    _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    _subTitleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_subTitleLabel];
}

- (void)setDetailTitle:(NSString *)detailTitle {
    _detailTitle = detailTitle;
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.font = kFont(13);
    _detailLabel.text = detailTitle;
    _detailLabel.textColor = kColor(@"#f63f50");
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_detailLabel];
}

- (void)layoutSubviews {
    
    if (_label && !_subTitleLabel && !_detailLabel) {
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(kWidth(40));
        }];
    }
    
    if (_label && _subTitleLabel && _detailLabel) {
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(kWidth(40));
        }];
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(_subTitleLabel.mas_top).offset(-kWidth(12));
            make.height.mas_equalTo(kWidth(40));
        }];
        
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(_subTitleLabel.mas_bottom).offset(kWidth(12));
            make.height.mas_equalTo(kWidth(40));
        }];
    }
    
    if (_label && !_subTitleLabel && _detailLabel) {
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.mas_centerY).offset(-kWidth(6));
            make.height.mas_equalTo(kWidth(40));
        }];
        
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.mas_centerY).offset(kWidth(6));
            make.height.mas_equalTo(kWidth(40));
        }];
        
    }

    
    [super layoutSubviews];
}

@end
