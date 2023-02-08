//
//  JYSendDynamicCell.m
//  JYFriend
//
//  Created by ylz on 2017/1/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYSendDynamicCell.h"

@interface JYSendDynamicCell ()
{
    UIImageView *_currentImageView;
}
@property (nonatomic,retain) UIImageView *playImageView;
@end

@implementation JYSendDynamicCell

- (UIImageView *)playImageView {
    if (_playImageView) {
        return _playImageView;
    }
    _playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_play_icon"]];
    [self addSubview:_playImageView];
    {
        [_playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kWidth(80), kWidth(80)));
        }];
    }
    return _playImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _currentImageView = [[UIImageView alloc] init];
//        _currentImageView.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"];
        [self addSubview:_currentImageView];
        {
        [_currentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        }
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _currentImageView.image = image;
}

- (void)setIsVideo:(BOOL)isVideo {
    _isVideo = isVideo;
    if (isVideo) {
        self.playImageView.hidden = NO;
    }else {
        if (_playImageView) {
            _playImageView.hidden = YES;
            [_playImageView removeFromSuperview];
        }
    
    }

}

@end
