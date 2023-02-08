//
//  JFPhotoCell.m
//  JFVideo
//
//  Created by Liang on 16/7/8.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPhotoCell.h"

@interface JFPhotoCell ()
{
    UIImageView *_imgV;
}
@end

@implementation JFPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imgV = [[UIImageView alloc] init];
        [self addSubview:_imgV];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        
    }
    return self;
}

- (void)setImgUrl:(NSString *)imgUrl {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

@end
