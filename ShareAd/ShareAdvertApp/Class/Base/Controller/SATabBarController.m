//
//  SATabBarController.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SATabBarController.h"
#import "SANavigationController.h"
#import "SALoginViewController.h"

#import "SAShareViewController.h"
#import "SARecruitViewController.h"
#import "SAMineViewController.h"
#import "SAMineAlertUIHelper.h"

#import "SAReqManager.h"
#import "SAConfigModel.h"
#import "SAUserAccountModel.h"

@interface SATabBarController () <UITabBarControllerDelegate>
@end

@implementation SATabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchSystemConfigInfo];
    [self configViewControllers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:kSAUserLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTabBarIndex) name:kSAReturnTabBarFirstNotification object:nil];
    
    if ([SAUtil checkUserIsLogin]) {
        [SAUtil fetchAccountInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)configViewControllers {
    SAShareViewController *shareVC = [[SAShareViewController alloc] initWithTitle:@"微金赚"];
    SANavigationController *shareNav = [[SANavigationController alloc] initWithRootViewController:shareVC];
    shareNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"分享赚钱"
                                                        image:[[UIImage imageNamed:@"tabbar_share_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                selectedImage:[[UIImage imageNamed:@"tabbar_share_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    SARecruitViewController *recruitVC = [[SARecruitViewController alloc] initWithTitle:@"收徒赚钱"];
    SANavigationController *recruitNav = [[SANavigationController alloc] initWithRootViewController:recruitVC];
    recruitNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:recruitVC.title
                                                          image:[[UIImage imageNamed:@"tabbar_recruit_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                  selectedImage:[[UIImage imageNamed:@"tabbar_recruit_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    SAMineViewController *mineVC = [[SAMineViewController alloc] initWithTitle:@"个人中心"];
    SANavigationController *mineNav = [[SANavigationController alloc] initWithRootViewController:mineVC];
    mineNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:mineVC.title
                                                       image:[[UIImage imageNamed:@"tabbar_mine_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                               selectedImage:[[UIImage imageNamed:@"tabbar_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    
    self.tabBar.translucent = NO;
    self.delegate = self;
    self.viewControllers = @[shareNav,recruitNav,mineNav];
}

- (void)fetchSystemConfigInfo {
    [[SAReqManager manager] fetchConfigInfoClass:[SAConfigModel class] handler:^(BOOL success, SAConfigModel * obj) {
        if (success) {
            [SAConfigModel defaultConfig].config = obj.config;
            NSLog(@"系统配置获取成功");
            if ([SAConfigModel defaultConfig].config.NOTICE.length > 0) {
                [SAMineAlertUIHelper showAlertUIWithType:SAMineAlertTypeAnnouncement onCurrentVC:self];
            }
        }
    }];
    
}

- (void)login {
    SALoginViewController *loginVC = [[SALoginViewController alloc] initWithTitle:@"登录"];
    SANavigationController *loginNav = [[SANavigationController alloc] initWithRootViewController:loginVC];
    if (!self.presentedViewController) {
        [self presentViewController:loginNav animated:loginNav completion:nil];
    }
}

- (void)changeTabBarIndex {
    [self setSelectedIndex:0];
}

@end
