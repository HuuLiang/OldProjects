//
//  SARecruitInfoCell.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SARecruitInfoCell.h"

@interface SARecruitInfoCell ()
@property (nonatomic) UILabel *nickLabel;
@property (nonatomic) UILabel *idLabel;
@property (nonatomic) UILabel *timeLabel;
@end

@implementation SARecruitInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.nickLabel = [[UILabel alloc] init];
        _nickLabel.textColor = kColor(@"#333333");
        _nickLabel.font = kFont(14);
        [self.contentView addSubview:_nickLabel];
        
        self.idLabel = [[UILabel alloc] init];
        _idLabel.textColor = kColor(@"#333333");
        _idLabel.font = kFont(14);
        [self.contentView addSubview:_idLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kColor(@"#333333");
        _timeLabel.font = kFont(14);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
        
        {
            [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(40));
                make.height.mas_equalTo(_nickLabel.font.lineHeight);
            }];
            
            [_idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView.mas_left).offset(kWidth(278));
                make.height.mas_equalTo(_idLabel.font.lineHeight);
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(40));
                make.height.mas_equalTo(_timeLabel.font.lineHeight);
            }];

        }
        
    }
    return self;
}

- (void)setNickName:(NSString *)nickName {
    _nickLabel.text = [NSString stringWithFormat:@"昵称:%@",nickName];
}

- (void)setUserId:(NSString *)userId {
    _idLabel.text = [NSString stringWithFormat:@"ID:%@",userId];
}

- (void)setRecruitTime:(NSString *)recruitTime {
    _timeLabel.text = recruitTime;
}

@end
