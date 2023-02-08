//
//  JYMessageNoticeCell.m
//  JYFriend
//
//  Created by Liang on 2017/1/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYMessageNoticeCell.h"

@interface JYMessageNoticeCell ()
{
    UIView  *_grayView;
    UILabel *_descLabel;
}
@end

@implementation JYMessageNoticeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _grayView = [[UIView alloc] init];
        _grayView.backgroundColor = kColor(@"#D3D3D3");
        [self.contentView addSubview:_grayView];
        
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont systemFontOfSize:kWidth(26)];
        _descLabel.numberOfLines = 0;
        [_grayView addSubview:_descLabel];
        
        @weakify(self);
        [_grayView bk_whenTapped:^{
            @strongify(self);
            if (self.payAction) {
                self.payAction(self);
            }
        }];
        
        {
            [_grayView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(10, kWidth(96), 10, kWidth(96)));
            }];
            
            [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_grayView).offset(kWidth(20));
                make.right.equalTo(_grayView.mas_right).offset(-kWidth(20));
                make.centerY.equalTo(_grayView);
                make.height.mas_equalTo(60);
            }];
        }
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange rang = [title rangeOfString:@"点击开通VIP"];
    [attri addAttributes:@{NSForegroundColorAttributeName : kColor(@"#E147A5")} range:rang];
    _descLabel.attributedText = attri;
}

@end
