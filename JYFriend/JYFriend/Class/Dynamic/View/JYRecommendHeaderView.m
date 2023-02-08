//
//  JYRecommendHeaderView.m
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYRecommendHeaderView.h"

@implementation JYRecommendHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"同城在线美女推荐";
        label.textColor = kColor(@"#333333");
        label.font = [UIFont systemFontOfSize:kWidth(32)];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
    }
    return self;
}

@end
