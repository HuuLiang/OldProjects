//
//  SAShareAllContentCell.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAShareAllContentCell.h"

#define cellHeight ;



@interface SAShareAllContentCell ()
@property (nonatomic) UILabel *titleLabel;
@end


@implementation SAShareAllContentCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat height = ceilf((kScreenWidth - kWidth(140))/5*7/15)/2;
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(14);
        _titleLabel.textColor = kColor(@"#333333");
        _titleLabel.backgroundColor = kColor(@"#ffffff");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.cornerRadius = height - 2.0;
        _titleLabel.layer.borderWidth = 1.0f;
        _titleLabel.layer.borderColor = kColor(@"#dcdcdc").CGColor;
        _titleLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_titleLabel];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView).mas_equalTo(UIEdgeInsetsMake(2, 2, 2, 2));
            }];
        }
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        _titleLabel.textColor = kColor(@"#ffffff");
        _titleLabel.backgroundColor = kColor(@"#FF3366");
        _titleLabel.layer.borderColor = [UIColor clearColor].CGColor;
    } else {
        _titleLabel.textColor = kColor(@"#333333");
        _titleLabel.backgroundColor = kColor(@"#ffffff");
        _titleLabel.layer.borderColor = kColor(@"#dcdcdc").CGColor;
    }
}


@end
