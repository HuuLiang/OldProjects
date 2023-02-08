//
//  YFBRegisterDetailCell.m
//  YFBFriend
//
//  Created by Liang on 2017/3/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBRegisterDetailCell.h"

@interface YFBRegisterDetailCell ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIImageView *arrowImgV;
@end

@implementation YFBRegisterDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kColor(@"#333333");
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(34)];
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = kColor(@"#333333");
        _contentLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [self.contentView addSubview:_contentLabel];
        
        _arrowImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_into"]];
        [self.contentView addSubview:_arrowImgV];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(40));
                make.height.mas_equalTo(kWidth(34));
            }];
            
            [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(_titleLabel.mas_right).offset(kWidth(50));
                make.height.mas_equalTo(kWidth(28));
            }];
            
            [_arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(18), kWidth(30)));
            }];
        }
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)setContent:(NSString *)content {
    _contentLabel.text = content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
