//
//  JFBaseViewController.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFBaseViewController.h"
#import "JFPaymentViewController.h"
#import "JFVideoPlayerController.h"
#import <MWPhotoBrowser.h>
#import "JFDetailModel.h"
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "JFSystemConfigModel.h"

static const void* kPhotoNumberAssociatedKey = &kPhotoNumberAssociatedKey;

@interface JFBaseViewController () <MWPhotoBrowserDelegate>
@property (nonatomic,weak) UIButton *refreshBtn;
@end

@implementation JFBaseViewController

- (NSUInteger)currentIndex {
    return NSNotFound;
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [self init];
    if (self) {
        self.title = title;
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playVideoWithInfo:(JFBaseModel *)model videoUrl:(NSString *)videoUrlStr {
    if (![JFUtil isVip] && model.spec != 4) {
        [self payWithInfo:model];
    } else if (![JFUtil isVip]&& model.spec == 4) {
        JFVideoPlayerController *videoVC = [[JFVideoPlayerController alloc] initWithVideo:videoUrlStr];
        videoVC.baseModel = model;
        [self presentViewController:videoVC animated:YES completion:nil];
    } else {
//        @weakify(self);
//        [[JFVideoTokenManager sharedManager] requestTokenWithCompletionHandler:^(BOOL success, NSString *token, NSString *userId) {
//            @strongify(self);
//            if (!self) {
//                return ;
//            }
//            [self.view endProgressing];
//            
//            if (success) {
//                //            [self loadVideo:[NSURL URLWithString:[[JFVideoTokenManager sharedManager]videoLinkWithOriginalLink:_videoUrl]]];
//                UIViewController *videoPlayVC = [self playerVCWithVideo:[[JFVideoTokenManager sharedManager] videoLinkWithOriginalLink:videoUrlStr]];
//                videoPlayVC.hidesBottomBarWhenPushed = YES;
//                [self presentViewController:videoPlayVC animated:YES completion:nil];
//            } else {
//                [UIAlertView bk_showAlertViewWithTitle:@"无法获取视频信息" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                    
//                }];
//            }
//        }];
        
        
        UIViewController *videoPlayVC = [self playerVCWithVideo:[JFUtil encodeVideoUrlWithVideoUrlStr:videoUrlStr]];
        videoPlayVC.hidesBottomBarWhenPushed = YES;
        [self presentViewController:videoPlayVC animated:YES completion:nil];

    }
}

- (void)playPhotoUrlWithInfo:(JFBaseModel *)model urlArray:(NSArray *)urlArray index:(NSInteger)index {
    if (![JFUtil isVip]) {
        [UIAlertView bk_showAlertViewWithTitle:@"非VIP用户只能浏览小图哦" message:@"开通VIP,高清大图即刻欣赏" cancelButtonTitle:@"再考虑看看" otherButtonTitles:@[@"立即开通"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self payWithInfo:model];
            }
        }];
    } else {
        NSMutableArray<MWPhoto *> *photos = [[NSMutableArray alloc] initWithCapacity:urlArray.count];
        [urlArray enumerateObjectsUsingBlock:^(JFDetailPhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:obj.url]]];
        }];
        
        MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
        photoBrowser.displayActionButton = NO;
        photoBrowser.delegate = self;
        objc_setAssociatedObject(photoBrowser, kPhotoNumberAssociatedKey, @(photos.count), OBJC_ASSOCIATION_COPY_NONATOMIC);
        [photoBrowser setCurrentPhotoIndex:index];
        photoBrowser.zoomPhotosToFill = NO;
        [self.navigationController pushViewController:photoBrowser animated:YES];
    }
}

- (void)payWithInfo:(JFBaseModel *)model {
    [[JFPaymentViewController sharedPaymentVC] popupPaymentInView:self.view.window
                                                        baseModel:model
                                            withCompletionHandler:nil];
}

- (UIViewController *)playerVCWithVideo:(NSString *)videoUrl {
    UIViewController *retVC;
    if (NSClassFromString(@"AVPlayerViewController")) {
        AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
        playerVC.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:videoUrl]];
        [playerVC aspect_hookSelector:@selector(viewDidAppear:)
                          withOptions:AspectPositionAfter
                           usingBlock:^(id<AspectInfo> aspectInfo){
                               AVPlayerViewController *thisPlayerVC = [aspectInfo instance];
                               [thisPlayerVC.player play];
                           } error:nil];
        
        retVC = playerVC;
    } else {
        retVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:videoUrl]];
    }
    
    [retVC aspect_hookSelector:@selector(supportedInterfaceOrientations) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo){
        UIInterfaceOrientationMask mask = UIInterfaceOrientationMaskAll;
        [[aspectInfo originalInvocation] setReturnValue:&mask];
    } error:nil];
    
    [retVC aspect_hookSelector:@selector(shouldAutorotate) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo){
        BOOL rotate = YES;
        [[aspectInfo originalInvocation] setReturnValue:&rotate];
    } error:nil];
    return retVC;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)addRefreshBtnWithCurrentView:(UIView *)view withAction:(JFAction) action;{
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refreshBtn = refreshBtn;
    
    //    [refreshBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    refreshBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(18.)];
    [refreshBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [refreshBtn setTitle:@"点击刷新" forState:UIControlStateNormal];
    refreshBtn.frame = CGRectMake(kScreenWidth/2.-kWidth(40.), (kScreenHeight-113.)/2. -kWidth(40.), kWidth(80.),kWidth(80.));
    refreshBtn.backgroundColor = [UIColor clearColor];
    [view addSubview:refreshBtn];
    [UIView animateWithDuration:0.4 animations:^{
        refreshBtn.transform = CGAffineTransformMakeScale(1.8, 1.8);
    }];
    [refreshBtn bk_addEventHandler:^(id sender) {
        if (action) {
            action(refreshBtn);
        }
        refreshBtn.transform = CGAffineTransformMakeScale(0.56, 0.56);
        [UIView animateWithDuration:0.4 animations:^{
            refreshBtn.transform = CGAffineTransformMakeScale(1.8, 1.8);
        }];

        if (![JFSystemConfigModel sharedModel].loaded) {
            [[JFSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:nil];
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
}
- (void)removeCurrentRefreshBtn{
    if (self.refreshBtn) {
        [self.refreshBtn removeFromSuperview];
    }
    
}
@end
