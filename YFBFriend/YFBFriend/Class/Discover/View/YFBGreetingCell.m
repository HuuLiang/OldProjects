//
//  YFBGreetingCell.m
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBGreetingCell.h"

@interface YFBGreetingCell ()
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation YFBGreetingCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        
        {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
        }
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
@end
