//
//  JYBaseViewController.m
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYBaseViewController.h"
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "JYDetailViewController.h"
#import "JYPaymentViewController.h"
#import "JYNavigationController.h"


@interface JYBaseViewController ()

@end

@implementation JYBaseViewController

- (instancetype)initWithTitle:(NSString *)title {
    self = [self init];
    if (self) {
        self.title = title;
        
    }
    return self;
}

- (void)dealloc {
    QBLog(@"%@ alloc", [self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)pushDetailViewControllerWithUserId:(NSString *)userId time:(NSString *)timeStr distance:(NSString *)distance nickName:(NSString *)nickName{
    if (timeStr) {
        timeStr = [JYUtil timeStringFromDate:[JYUtil dateFromString:timeStr WithDateFormat:KDateFormatLong] WithDateFormat:@"yyyy年MM月dd日 hh:mm:ss"];
    }
    JYDetailViewController *detailVC = [[JYDetailViewController alloc] initWithUserId:userId time:timeStr distance:distance nickName:nickName];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)presentPayViewController {
    JYPaymentViewController *payVC = [[JYPaymentViewController alloc] init];
    JYNavigationController *payNav = [[JYNavigationController alloc] initWithRootViewController:payVC];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:payNav animated:YES completion:nil];
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


@end
