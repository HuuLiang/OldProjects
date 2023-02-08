//
//  JFVideoPlayerController.m
//  JFVideo
//
//  Created by Liang on 16/6/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFVideoPlayerController.h"
#import "JFVideoPlayer.h"

@interface JFVideoPlayerController ()
{
    JFVideoPlayer *_videoPlayer;
    UIButton *_closeButton;
}
@end

@implementation JFVideoPlayerController

- (instancetype)initWithVideo:(NSString *)videoUrl {
    self = [self init];
    if (self) {
        _videoUrl = videoUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
//    _videoPlayer = [[JFVideoPlayer alloc] initWithVideoURL:[NSURL URLWithString:_videoUrl]];
//    @weakify(self);
//    _videoPlayer.endPlayAction = ^(id sender) {
//        @strongify(self);
//        [self dismissAndPopPayment];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    };
//    [self.view addSubview:_videoPlayer];
//    {
//        [_videoPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
//        }];
//    }
//
//    [_videoPlayer startToPlay];
    
    _closeButton = [[UIButton alloc] init];
    [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.view addSubview:_closeButton];
    {
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.top.equalTo(self.view).offset(30);
        }];
    }
    @weakify(self);
    [_closeButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self->_videoPlayer pause];
        
        [self dismissAndPopPayment];
        [self dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view beginProgressingWithTitle:@"加载中..." subtitle:nil];
//    ;
//    [[JFVideoTokenManager sharedManager] requestTokenWithCompletionHandler:^(BOOL success, NSString *token, NSString *userId) {
//        @strongify(self);
//        if (!self) {
//            return ;
//        }
//        [self.view endProgressing];
//        
//        if (success) {
//            [self loadVideo:[NSURL URLWithString:[[JFVideoTokenManager sharedManager]videoLinkWithOriginalLink:_videoUrl]]];
//        } else {
//            [UIAlertView bk_showAlertViewWithTitle:@"无法获取视频信息" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                @strongify(self);
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
//        }
//    }];
    
    [self loadVideo:[NSURL URLWithString:[JFUtil encodeVideoUrlWithVideoUrlStr:self.videoUrl]]];
    
}

- (void)loadVideo:(NSURL *)videoUrl {
    
    _videoPlayer = [[JFVideoPlayer alloc] initWithVideoURL:videoUrl];
    [self.view insertSubview:_videoPlayer atIndex:0];
    {
        [_videoPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
#ifdef YYK_DISPLAY_VIDEO_URL
    NSString *url = videoUrl.absoluteString;
    [UIAlertView bk_showAlertViewWithTitle:@"视频链接" message:url cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
#endif
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_videoPlayer startToPlay];
}

- (void)dismissAndPopPayment {
    if ([JFUtil isVip]) {
        return;
    }
    [self payWithInfo:self.baseModel];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
