//
//  JYPhotoCollectionViewCell.m
//  JYFriend
//
//  Created by ylz on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYPhotoCollectionViewCell.h"

@interface JYPhotoCollectionViewCell ()
{
    UIImageView *_currentImageView;
}

@property (nonatomic,retain) UIImageView *playImageView;
@property (nonatomic,retain) UIView *effectView;
@end

@implementation JYPhotoCollectionViewCell

- (UIImageView *)playImageView {
    if (_playImageView) {
        return _playImageView;
    }
    _playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_play_icon"]];
    [self addSubview:_playImageView];
    {
    [_playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kWidth(100), kWidth(100)));
    }];
    }
    return _playImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         self.backgroundColor = [UIColor whiteColor];
        _currentImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _currentImageView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_currentImageView];
        {
        [_currentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        }
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [_currentImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];

}

- (void)setIsVideoImage:(BOOL)isVideoImage {
    _isVideoImage = isVideoImage;
    if (isVideoImage) {
        self.playImageView.hidden = NO;
    }else {
        if (_playImageView) {
            _playImageView.hidden = YES;
            [_playImageView removeFromSuperview];
    }
    }
}

- (void)setImageUrl:(NSString *)imageUrl isFirstPhoto:(BOOL)isFirstPhoto isSendPacket:(BOOL)isSendPacket{
    [_currentImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image && !isFirstPhoto && ![JYUtil isVip] && !isSendPacket) {
            _currentImageView.image = [image blurWithIsSmallPicture:YES];
        }
    }];
}

//- (void)setIsFirstPhoto:(BOOL)isFirstPhoto {
//    _isFirstPhoto = isFirstPhoto;
//    if (![JYUtil isVip]) {
//        if (isFirstPhoto) {
//            [_currentImageView JY_RemoveBlur];
//        }else {
//            
//            [_currentImageView JY_AddBlurWithAlpha:0.9];
//        }
//    }
//
//}

@end
