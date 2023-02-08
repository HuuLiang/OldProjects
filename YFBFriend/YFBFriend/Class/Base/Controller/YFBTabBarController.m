//
//  YFBTabBarController.m
//  YFBFriend
//
//  Created by Liang on 2017/2/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBTabBarController.h"

#import "YFBDiscoverViewController.h"
#import "YFBSocialViewController.h"
#import "YFBContactViewController.h"
#import "YFBMineViewController.h"

#import "YFBDiamondManager.h"
#import "YFBGiftManager.h"
#import "YFBPayConfigManager.h"
#import "YFBExampleManager.h"
#import "YFBMessageRecordManager.h"
#import "YFBAutoReplyManager.h"
#import "YFBContactManager.h"
#import "YFBAskGiftManager.h"

#import "YFBAutoReplyManager.h"
#import "YFBContactView.h"
#import "YFBFaceTimeView.h"
#import "YFBMessageViewController.h"

#import "YFBTelChargeVC.h"
#import "YFBLocationManager.h"

#define WakeGiftManagerTimeInterval (60 * 5)

@interface YFBTabBarController () <UITabBarControllerDelegate>
@property (nonatomic) UIImageView *activityView;
@end

@implementation YFBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    self.tabBar.layer.borderWidth = 0.5;
    
    [self setChildViewControllers];

    [self configActivityView];
    
    [self loadDefaultConfig];
    
    [self performSelector:@selector(wakeAskGiftManager) withObject:nil afterDelay:WakeGiftManagerTimeInterval];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger unreadMessages = [[YFBContactManager manager] allUnReadMessageCount];
        UITabBarItem *contactItem = self.tabBar.items[2];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (unreadMessages > 0) {
                if (unreadMessages < 100) {
                    contactItem.badgeValue = [NSString stringWithFormat:@"%ld", (unsigned long)unreadMessages];
                } else {
                    contactItem.badgeValue = @"99+";
                }
            } else {
                contactItem.badgeValue = nil;
            }
        });
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showContactViewWithContactInfo:) name:kYFBFriendShowMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showActivityView) name:kYFBShowChargeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideActivityView) name:kYFBHideChargeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//预加载相关配置
- (void)loadDefaultConfig {
    [[YFBDiamondManager manager] getDiamondListCache];                              //获取钻石列表
    [[YFBGiftManager manager] getGiftListCache];                                    //获取礼物列表
    [[YFBPayConfigManager manager] getPayConfig];                                   //获取支付配置
    [[YFBExampleManager manager] getExampleList];                                   //获取支付例子列表
    [[YFBMessageRecordManager manager] deleteYesterdayRecordMessages];              //删除昨日消息记录
    [[YFBAutoReplyManager manager] deleteYesterdayMessages];                        //删除昨日推送记录
    [[YFBContactManager manager] deleteAllPreviouslyContactInfo];                   //删除昨日的消息列表消息里的消息内容
    [YFBAutoReplyManager manager].canReplyNotificationMessage = YES;                //允许开始推动固定通知下发的消息
    [[YFBAutoReplyManager manager] getRobotReplyMessages];                          //获取批量的机器人消息留作推送
    [[YFBAutoReplyManager manager] startAutoRollingToReply];                        //开始推送机器人
    [[YFBAskGiftManager manager] startAutoBlagActionInViewController:self];         //开始索要礼物功能
    [[YFBLocationManager manager] loadLocationManager];                             //申请定位权限
}

- (void)wakeAskGiftManager {
    
}

- (void)setChildViewControllers {
    YFBDiscoverViewController *discoverVC = [[YFBDiscoverViewController alloc] initWithTitle:@"发现"];
    UINavigationController *discoverNav = [[UINavigationController alloc] initWithRootViewController:discoverVC];
    discoverNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:discoverVC.title
                                                          image:[[UIImage imageNamed:@"discover_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]
                                                  selectedImage:[[UIImage imageNamed:@"discover_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    YFBSocialViewController *socialVC = [[YFBSocialViewController alloc] initWithTitle:@"同城服务"];
    UINavigationController *socialNav = [[UINavigationController alloc] initWithRootViewController:socialVC];
    socialNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:socialVC.title
                                                         image:[[UIImage imageNamed:@"social_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]
                                                 selectedImage:[[UIImage imageNamed:@"social_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    YFBContactViewController *contactVC = [[YFBContactViewController alloc] initWithTitle:@"消息"];
    UINavigationController *contactNav = [[UINavigationController alloc] initWithRootViewController:contactVC];
    contactNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:contactVC.title
                                                           image:[[UIImage imageNamed:@"contact_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                   selectedImage:[[UIImage imageNamed:@"contact_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    YFBMineViewController *mineVC = [[YFBMineViewController alloc] initWithTitle:@"我的"];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    mineNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:mineVC.title
                                                          image:[[UIImage imageNamed:@"mine_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                  selectedImage:[[UIImage imageNamed:@"mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    
    self.tabBar.translucent = NO;
    self.delegate = self;
    self.viewControllers = @[discoverNav,socialNav,contactNav,mineNav];
}


- (void)showContactViewWithContactInfo:(NSNotification *)notification {
    YFBAutoReplyMessage *messageInfo = (YFBAutoReplyMessage *)[notification object];
    if (messageInfo.msgType == YFBMessageTypeFaceTime) {
        [YFBFaceTimeView showFaceTimeViewWith:messageInfo InCurrentViewController:self];
    } else {
        [YFBContactView showInCurrentViewController:self MessageInfo:messageInfo];
    }
}

- (void)configActivityView {
    self.activityView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_tel"]];
    _activityView.userInteractionEnabled = YES;
    [self.view addSubview:_activityView];
    [self.view bringSubviewToFront:_activityView];
    
    @weakify(self);
    [_activityView bk_whenTapped:^{
        @strongify(self);
        YFBTelChargeVC *telVC = [[YFBTelChargeVC alloc] init];
        UINavigationController *activityNav = [[UINavigationController alloc] initWithRootViewController:telVC];
        activityNav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:activityNav animated:YES completion:nil];
    }];
    
    {
        [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top).offset(kWidth(108)+64);
            make.size.mas_equalTo(CGSizeMake(kWidth(140), kWidth(80)));
        }];
    }
}

- (void)showActivityView {
    _activityView.hidden = NO;
}

- (void)hideActivityView {
    _activityView.hidden = YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    _activityView.hidden = tabBarController.selectedIndex == 3;
}

@end
