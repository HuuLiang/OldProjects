//
//  SADrawMoneyCell.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SADrawMoneyCell.h"

@interface SADrawMoneyCell ()
@property (nonatomic) UILabel *statusLabel;
@property (nonatomic) UILabel *moneyLabel;
@property (nonatomic) UILabel *timeLabel;
@end

@implementation SADrawMoneyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = kColor(@"#666666");
        _statusLabel.font = kFont(14);
        [self.contentView addSubview:_statusLabel];
        
        self.moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = kColor(@"#333333");
        _moneyLabel.font = kFont(16);
        [self.contentView addSubview:_moneyLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kColor(@"#999999");
        _timeLabel.font = kFont(12);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
        
        {
            [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(50));
                make.height.mas_equalTo(_statusLabel.font.lineHeight);
            }];
            
            [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView.mas_left).offset(kWidth(312));
                make.height.mas_equalTo(_moneyLabel.font.lineHeight);
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(48));
                make.height.mas_equalTo(_timeLabel.font.lineHeight);
            }];
        }
    }
    return self;
}

- (void)setDrawStatus:(SAMineDrawMoneyStatus)drawStatus {
    switch (drawStatus) {
        case SAMineDrawMoneyStatusAllRecrod:
            _statusLabel.text = @"全部记录";
            break;
        case SAMineDrawMoneyStatusProcessing:
            _statusLabel.text = @"正在处理";
            break;
        case SAMineDrawMoneyStatusFailed:
            _statusLabel.text = @"提现失败";
            break;
        case SAMineDrawMoneyStatusSuccess:
            _statusLabel.text = @"提现成功";
            break;

        default:
            break;
    }
}

- (void)setCount:(NSString *)count {
    _moneyLabel.text = [NSString stringWithFormat:@"+%@",count];
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeLabel.text = timeStr;
}

@end
