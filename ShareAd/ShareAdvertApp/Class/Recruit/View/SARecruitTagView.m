//
//  SARecruitTagView.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SARecruitTagView.h"

@interface SARecruitTagView ()
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *countLabel;
@end

@implementation SARecruitTagView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        self.backgroundColor = [UIColor greenColor];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(13);
        _titleLabel.textColor = kColor(@"#666666");
        [self addSubview:_titleLabel];
        
        self.countLabel = [[UILabel alloc] init];
//        _countLabel.font = kFont(30);
//        _countLabel.textColor = kColor(@"#FF3366");
        [self addSubview:_countLabel];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.top.equalTo(self);
                make.height.mas_offset(_titleLabel.font.lineHeight);
            }];
            
            [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_titleLabel.mas_bottom).offset(kWidth(20));
                make.centerX.equalTo(self);
                make.height.mas_equalTo(_countLabel.font.lineHeight);
            }];
        }
    }
    return self;
}

- (void)setTagType:(SATagViewType)tagType {
    _tagType = tagType;
    switch (tagType) {
        case SATagViewTypeTodayRecruit:
            _titleLabel.text = @"今日收徒";
            break;
        case SATagViewTypeAllRecruit:
            _titleLabel.text = @"累计收徒";
            break;
        case SATagViewTypeTodayBalance:
            _titleLabel.text = @"累计徒弟提成";
            break;
        case SATagViewTypeAllBalance:
            _titleLabel.text = @"累计收徒奖励";
            break;
            
        default:
            break;
    }
}

- (void)setCount:(NSString *)count {
    NSString *tagStr = nil;
    switch (_tagType) {
        case SATagViewTypeTodayRecruit:
        case SATagViewTypeAllRecruit:
            tagStr = @"人";
            break;
        case SATagViewTypeTodayBalance:
        case SATagViewTypeAllBalance:
            tagStr = @"元";
        default:
            break;
    }
    NSString *fullStr = [NSString stringWithFormat:@"%@%@",count,tagStr];
    
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:fullStr attributes:@{NSFontAttributeName:kFont(30),NSForegroundColorAttributeName:kColor(@"#FF3366")}];
    [attriStr addAttributes:@{NSFontAttributeName:kFont(13),NSForegroundColorAttributeName:kColor(@"#666666")} range:[fullStr rangeOfString:tagStr]];
    _countLabel.attributedText = attriStr;
    
}


@end
