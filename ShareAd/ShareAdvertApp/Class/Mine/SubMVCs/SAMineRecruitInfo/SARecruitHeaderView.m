//
//  SARecruitHeaderView.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SARecruitHeaderView.h"

@interface SARecruitHeaderView ()
@property (nonatomic) UILabel *recruitLabel;
@property (nonatomic) UILabel *revenueLabel;
@property (nonatomic) UILabel *incomeLabel;
@end

@implementation SARecruitHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = kColor(@"#ffffff");
        
        self.recruitLabel = [[UILabel alloc] init];
        _recruitLabel.font = kFont(12);
        [self addSubview:_recruitLabel];
        
        self.revenueLabel = [[UILabel alloc] init];
        _revenueLabel.font = kFont(12);
        [self addSubview:_revenueLabel];
        
        self.incomeLabel = [[UILabel alloc] init];
        _incomeLabel.font = kFont(12);
        [self addSubview:_incomeLabel];
        
        {
            [_recruitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(kWidth(60));
                make.height.mas_equalTo(_recruitLabel.font.lineHeight);
            }];
            
            [_revenueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_recruitLabel.mas_right);
                make.height.mas_equalTo(_revenueLabel.font.lineHeight);
            }];
            
            [_incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_revenueLabel.mas_right);
                make.height.mas_equalTo(_incomeLabel.font.lineHeight);
            }];
        }
    }
    return self;
}


- (void)setRecruitCount:(NSString *)recruitCount {
    _recruitLabel.attributedText = [self configAttributeStringWihtFullString:[NSString stringWithFormat:@"您共计收徒%@人，",recruitCount] targetChars:recruitCount];

}

- (void)setRevenueCount:(NSString *)revenueCount {
    _revenueLabel.attributedText = [self configAttributeStringWihtFullString:[NSString stringWithFormat:@"累计提成%@元，",revenueCount] targetChars:revenueCount];

}

- (void)setIncomeCount:(NSString *)incomeCount {
    _incomeLabel.attributedText = [self configAttributeStringWihtFullString:[NSString stringWithFormat:@"累计奖励%@元，",incomeCount] targetChars:incomeCount];

}

- (NSMutableAttributedString *)configAttributeStringWihtFullString:(NSString *)fullString targetChars:(NSString *)targetChars {
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:fullString attributes:@{NSForegroundColorAttributeName:kColor(@"#666666"),NSFontAttributeName:kFont(12)}];
    [attriStr addAttributes:@{NSForegroundColorAttributeName:kColor(@"#FF3366"),NSFontAttributeName:kFont(14)} range:[fullString rangeOfString:targetChars]];
    return attriStr;
}

@end
