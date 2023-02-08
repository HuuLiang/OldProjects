//
//  JYRecommendCell.m
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYRecommendCell.h"

@interface JYRecommendCell ()
{
    UIImageView *_userImgV;
    UIButton    *_selectedBtn;
}
@end

@implementation JYRecommendCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        
        _userImgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_userImgV];
        
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"recommend_selected"] forState:UIControlStateSelected];
        [self.contentView addSubview:_selectedBtn];
        
        {
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
            
            [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(6));
                make.top.equalTo(self.contentView).offset(kWidth(12));
                make.size.mas_equalTo(CGSizeMake(kWidth(40), kWidth(40)));
            }];
        }
    }
    return self;
}

- (void)setUserImgStr:(NSString *)userImgStr {
    [_userImgV sd_setImageWithURL:[NSURL URLWithString:userImgStr]];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    _selectedBtn.selected = isSelected;
}

@end
