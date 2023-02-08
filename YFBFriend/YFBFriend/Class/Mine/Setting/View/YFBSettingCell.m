//
//  YFBSettingCell.m
//  YFBFriend
//
//  Created by Liang on 2017/3/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBSettingCell.h"

@interface YFBSettingCell ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UISwitch *functionSwith;
@property (nonatomic,strong) UILabel    *noticeLabel;
@end

@implementation YFBSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kColor(@"#333333");
        _titleLabel.font = kFont(14);
        [self.contentView addSubview:_titleLabel];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.height.mas_equalTo(kWidth(34));
            }];
        }
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)setSettingType:(YFBSettingCellType)settingType {
    _settingType = settingType;
    if (settingType == YFBSettingCellTypeSwitch) {
        [_noticeLabel removeFromSuperview];
        
        self.functionSwith = [[UISwitch alloc] init];
        [self.contentView addSubview:_functionSwith];
        
        [_functionSwith mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView.mas_right).offset(-kWidth(40));
            make.size.mas_equalTo(CGSizeMake(kWidth(100), kWidth(60)));
        }];
        
    } else if (settingType == YFBSettingCellTypeNotice) {
        [_functionSwith removeFromSuperview];
        
        self.noticeLabel = [[UILabel alloc] init];
        _noticeLabel.textColor = kColor(@"#999999");
        _noticeLabel.font = kFont(12);
        _noticeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_noticeLabel];
        
        [_noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView.mas_right).offset(-kWidth(40));
            make.height.mas_equalTo(kWidth(34));
        }];
        
    } else if (settingType == YFBSettingCellTypeNone) {
        [_functionSwith removeFromSuperview];
        [_noticeLabel removeFromSuperview];
    }
}

- (void)setFunctionOpen:(BOOL)functionOpen {
    if (_functionSwith) {
        [_functionSwith setOn:functionOpen animated:YES];
    } else if (_noticeLabel) {
        _noticeLabel.text = functionOpen ? @"已开启" : @"未开启";
    }
}

@end
