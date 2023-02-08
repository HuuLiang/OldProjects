//
//  YFBDetailCell.m
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDetailCell.h"

@interface YFBDetailCell ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@end

@implementation YFBDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(15);
        [self.contentView addSubview:_titleLabel];
        
        self.contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = kColor(@"#999999");
        _contentLabel.font = kFont(15);
        _contentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_contentLabel];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.height.mas_equalTo(kWidth(30));
            }];
            
            [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(30));
                make.height.mas_equalTo(kWidth(40));
            }];
        }
    }
    return self;
}

- (void)setIsTitle:(BOOL)isTitle {
    if (isTitle) {
        _titleLabel.textColor = kColor(@"#999999");
        _contentLabel.text = @"";
    }
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
    _titleLabel.textColor = kColor(@"#333333");
}

- (void)setContent:(NSString *)content {
    _contentLabel.text = content;
}

@end
