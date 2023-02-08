//
//  JYPayHeaderCell.m
//  JYFriend
//
//  Created by ylz on 2017/1/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYPayHeaderCell.h"

@interface JYPayHeaderCell ()
{
    UILabel *_title;
    UILabel *_subTitle;
}
@end

@implementation JYPayHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor colorWithHexString:@"#333333"];
        _title.font = [UIFont boldSystemFontOfSize:[JYUtil isIpad] ? 38 : kWidth(38)];
        _title.text = @"成为会员无限发送信息";
        _title.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_title];
        
        _subTitle = [[UILabel alloc] init];
        _subTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        _subTitle.font = [UIFont systemFontOfSize:[JYUtil isIpad] ? 32 : kWidth(32)];
        _subTitle.textAlignment = NSTextAlignmentCenter;
        _subTitle.text = @"选取会员等级";
        [self.contentView addSubview:_subTitle];
        
        {
            [_subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView.mas_bottom).offset([JYUtil isIpad] ? -kWidth(30) : -kWidth(30));
                make.left.right.equalTo(self.contentView);
                make.height.mas_equalTo(kWidth(44));
            }];
            
            [_title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_subTitle.mas_top).offset(-kWidth(20));
                make.left.right.equalTo(self.contentView);
                make.height.mas_equalTo(kWidth(52));
            }];
        }
    }
    return self;
}

@end
