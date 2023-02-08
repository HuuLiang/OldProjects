//
//  YFBUserDataInfoCell.m
//  YFBFriend
//
//  Created by Liang on 2017/3/21.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBUserDataInfoCell.h"

@interface YFBUserDataInfoCell ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIImageView *arrowImageView;
@end

@implementation YFBUserDataInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;

        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kColor(@"#333333");
        [self.contentView addSubview:_titleLabel];
        
        self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_datainfo_into"]];
        [self.contentView addSubview:_arrowImageView];
        
        self.detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = kColor(@"#999999");
        _detailLabel.font = kFont(14);
        _detailLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_detailLabel];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.height.mas_equalTo(kWidth(40));
            }];
            
            [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(16), kWidth(28)));
            }];
            
            [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(_arrowImageView.mas_left).offset(-kWidth(20));
                make.height.mas_equalTo(kWidth(28));
            }];
        }
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.font = kFont(17);
    _titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _arrowImageView.hidden = NO;
    _detailLabel.text = subTitle;
}

- (void)setDescTitle:(NSString *)descTitle font:(UIFont *)font {
    _arrowImageView.hidden = YES;
    _titleLabel.font = font;
    _titleLabel.text = descTitle;
    _detailLabel.text = @"";
}
@end
