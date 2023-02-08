//
//  JYSystemHelperCell.m
//  JYFriend
//
//  Created by ylz on 2017/1/19.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYSystemHelperCell.h"

@interface JYSystemHelperCell ()

{
    UIImageView *_headerImageView;
    UILabel *_titleLabel;
}

@end

@implementation JYSystemHelperCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kColor(@"#e147a5");
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(26.)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self.contentView);
            make.width.mas_equalTo(frame.size.width*1.2);
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(kWidth(26));
            
        }];
        }
        
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.backgroundColor = kColor(@"#bcbcbc");
        _headerImageView.forceRoundCorner = YES;
        [self addSubview:_headerImageView];
        {
        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self);
            make.bottom.equalTo(_titleLabel.mas_top).mas_offset(kWidth(-24));
        }];
        }
      
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

- (void)setMatchRate:(NSInteger)matchRate {
    _matchRate = matchRate;
    _titleLabel.text = [NSString stringWithFormat:@"匹配指数%zd％",matchRate];
}


@end
