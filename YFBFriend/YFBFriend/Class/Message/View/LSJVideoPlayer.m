//
//  LSJVideoPlayer.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJVideoPlayer.h"

@import AVFoundation;

@interface LSJVideoPlayer ()
{
    UILabel *_loadingLabel;
}
@property (nonatomic,retain) AVPlayer *player;

@end

@implementation LSJVideoPlayer

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (instancetype)initWithVideoURL:(NSURL *)videoURL {
    self = [self init];
    if (self) {
        
        self.backgroundColor = [kColor(@"#1D1F26") colorWithAlphaComponent:0.88];
        
        _videoURL = videoURL;
        
        _loadingLabel = [[UILabel alloc] init];
        _loadingLabel.text = @"加载中...";
        _loadingLabel.textColor = [UIColor whiteColor];
        _loadingLabel.font = [UIFont systemFontOfSize:14.];
        [self addSubview:_loadingLabel];
        {
            [_loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
            }];
        }
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"gift_close_btn_icon"] forState:UIControlStateNormal];
        @weakify(self);
        [closeButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            [self didEndPlay];
        } forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        {
            [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.mas_bottom).offset(-kWidth(100));
                make.size.mas_equalTo(CGSizeMake(kWidth(60), kWidth(60)));
            }];
        }
        
        self.player = [AVPlayer playerWithURL:videoURL];
        [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndPlay) name:AVPlayerItemDidPlayToEndTimeNotification  object:nil];
    }
    return self;
}

- (void)startToPlay {
    [self.player play];
}

- (void)pause {
    [self.player pause];
}

- (void)dealloc {
    [self.player removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusReadyToPlay:
                _loadingLabel.hidden = YES;
                break;
            default:
                _loadingLabel.hidden = NO;
                _loadingLabel.text = @"加载失败";
                break;
        }
    }
}

- (void)didEndPlay {
    if (self.endPlayAction) {
        self.endPlayAction(self);
    }
}
@end
