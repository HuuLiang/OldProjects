//
//  JYPayPointCell.m
//  JYFriend
//
//  Created by ylz on 2017/1/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYPayPointCell.h"
#import "JYSystemConfigModel.h"

@interface JYPayPointCell ()

{
    UIView *_frameView;
    UILabel *_title;
    UILabel *_subTitle;
    UILabel *_moneyLabel;
    UIImageView *_seletedImgV;
}

@end

@implementation JYPayPointCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        
        _frameView = [[UIView alloc] init];
        _frameView.layer.cornerRadius = [JYUtil isIpad] ? 20 : kWidth(20);
        _frameView.layer.borderColor = [UIColor colorWithHexString:@"#E147A5"].CGColor;
        _frameView.layer.borderWidth = kWidth(2);
        _frameView.layer.masksToBounds = YES;
        [self.contentView addSubview:_frameView];
        
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor colorWithHexString:@"#333333"];
        _title.font = [UIFont boldSystemFontOfSize:[JYUtil isIpad] ? 38 : kWidth(38)];
        _title.textAlignment = NSTextAlignmentCenter;
        [_frameView addSubview:_title];
        
        _subTitle = [[UILabel alloc] init];
        _subTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        _subTitle.font = [UIFont systemFontOfSize:[JYUtil isIpad] ? 28 : kWidth(28)];
        _subTitle.textAlignment = NSTextAlignmentCenter;
        [_frameView addSubview:_subTitle];
        
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#FF5722"];
        _moneyLabel.font = [UIFont systemFontOfSize:[JYUtil isIpad] ? 36 : kWidth(36)];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        [_frameView addSubview:_moneyLabel];
        
        _seletedImgV = [[UIImageView alloc] init];
        [_frameView addSubview:_seletedImgV];
        
        {
            [_frameView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, kWidth(30), kWidth(20), kWidth(30)));
                make.bottom.mas_equalTo(self.contentView).mas_offset(kWidth(-20));
            }];
            
            [_title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_frameView).offset(kWidth(30));
                make.top.equalTo(_frameView).offset([JYUtil deviceType] < JYDeviceType_iPhone5 ? kWidth(22) : kWidth(42));
                make.height.mas_equalTo(kWidth(40));
            }];
            
            [_subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_frameView).offset(kWidth(30));
                make.bottom.equalTo(_frameView.mas_bottom).offset([JYUtil deviceType] < JYDeviceType_iPhone5 ? kWidth(-22) : kWidth(-42));
                make.height.mas_equalTo(kWidth(30));
            }];
            
            [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_frameView);
                make.right.equalTo(_frameView.mas_right).offset(-kWidth(106));
                make.height.mas_equalTo(kWidth(30));
            }];
            
            [_seletedImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_frameView);
                make.right.equalTo(_frameView.mas_right).offset(-kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(40), kWidth(40)));
            }];
        }
        
    }
    return self;
}

- (void)setVipLevel:(JYVipType)vipLevel {
    _vipLevel = vipLevel;
    if (vipLevel == JYVipTypeYear) {
        _title.text = @"年度会员";
        _subTitle.text = @"充值100送100话费";
        _moneyLabel.text = [NSString stringWithFormat:@"¥%ld",[JYSystemConfigModel sharedModel].vipPriceC/100];
    } else if (vipLevel == JYVipTypeQuarter) {
        _title.text = @"季度会员";
        _subTitle.text = @"充值50送30元话费";
        _moneyLabel.text = [NSString stringWithFormat:@"¥%ld",[JYSystemConfigModel sharedModel].vipPriceB/100];
       
    } else if (vipLevel == JYVipTypeMonth) {
        _title.text = @"月度会员";
        _subTitle.text = @"充值便可查看用户隐私信息";
        _moneyLabel.text = [NSString stringWithFormat:@"¥%ld",[JYSystemConfigModel sharedModel].vipPriceA/100];
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    if (_isSelected) {
        _title.textColor = [UIColor colorWithHexString:@"#E147A5"];
        _subTitle.textColor = [UIColor colorWithHexString:@"#E147A5"];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#E147A5"];
        _seletedImgV.image = [UIImage imageNamed:@"pay_selected"];
        _frameView.layer.borderColor = [UIColor colorWithHexString:@"#E147A5"].CGColor;
    } else {
        _title.textColor = [UIColor colorWithHexString:@"#333333"];
        _subTitle.textColor = [UIColor colorWithHexString:@"#666666"];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#FF680D"];
        _seletedImgV.image = [UIImage imageNamed:@"pay_normal"];
        _frameView.layer.borderColor = [UIColor colorWithHexString:@"#D4D4D4"].CGColor;
    }
}

@end
