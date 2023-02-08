//
//  YFBDiamondTitleCell.m
//  YFBFriend
//
//  Created by Liang on 2017/5/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDiamondTitleCell.h"

@interface YFBDiamondTitleCell ()
@property (nonatomic) UIImageView *imgV;
@property (nonatomic) UILabel *label;
@end


@implementation YFBDiamondTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diamond_img"]];
        [self.contentView addSubview:_imgV];
        
        self.label = [[UILabel alloc] init];
        _label.text = @"开通聊天套餐，即可与心仪的异性无限畅聊";
        _label.font = kFont(12);
        _label.textColor = kColor(@"#333333");
        _label.numberOfLines = 0;
        [self.contentView addSubview:_label];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView.mas_left).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(180), kWidth(180)));
            }];
            
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_imgV.mas_right).offset(kWidth(20));
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(70));
                make.top.equalTo(self.contentView).offset(kWidth(36));
            }];
        }
    }
    return self;
}

@end
