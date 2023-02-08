//
//  YFBBuyVipDescCell.m
//  YFBFriend
//
//  Created by Liang on 2017/5/23.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBuyVipDescCell.h"

@interface YFBBuyVipDescCell ()
@property (nonatomic) UIImageView *imgV;
@property (nonatomic) UILabel *label;
@end

@implementation YFBBuyVipDescCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_power"]];
        [self.contentView addSubview:_imgV];
        
        self.label = [[UILabel alloc] init];
        _label.textColor = kColor(@"#666666");
        _label.font = kFont(13);
        [self addSubview:_label];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(60));
                make.size.mas_equalTo(CGSizeMake(kWidth(24), kWidth(24)));
            }];
            
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(_imgV.mas_right).offset(kWidth(28));
                make.height.mas_equalTo(_label.font.lineHeight);
            }];
        }
        
    }
    return self;
}

- (void)setDescStr:(NSString *)descStr {
    _label.text = descStr;
}


@end
