//
//  SAMineCenterFunctionCell.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/7.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAMineCenterFunctionCell.h"

@interface SAMineCenterFunctionCell ()
@property (nonatomic) UIImageView *iconImgV;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *intoImgV;
@end

@implementation SAMineCenterFunctionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.iconImgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImgV];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kColor(@"#666666");
        _titleLabel.font = kFont(14);
        [self.contentView addSubview:_titleLabel];
        
        self.intoImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_into"]];
        [self.contentView addSubview:_intoImgV];
        
        {
            [_iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(56), kWidth(56)));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(_iconImgV.mas_right).offset(kWidth(20));
                make.height.mas_equalTo(_titleLabel.font.lineHeight);
            }];
            
            [_intoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(14), kWidth(26)));
            }];
        }
        
    }
    return self;
}

- (void)setImgName:(NSString *)imgName {
    _iconImgV.image = [UIImage imageNamed:imgName];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

@end
