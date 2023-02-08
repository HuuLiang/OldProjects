//
//  JYTabBarController.m
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYTabBarController.h"

#import "JYContactViewController.h"
#import "JYSegmentViewController.h"
#import "JYNearViewController.h"
#import "JYMineViewController.h"

#import "JYNavigationController.h"

#import "JYAutoContactManager.h"
#import "JYContactModel.h"

@interface JYTabBarController () <UITabBarControllerDelegate>
@end

@implementation JYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    self.tabBar.layer.borderWidth = 0.5;
    [self setChildViewControlers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadge:) name:KUpdateContactUnReadMessageNotification object:nil];
}

- (void)updateBadge:(NSNotification *)notification {
    
    JYNavigationController *contactNav = (JYNavigationController *)[self.viewControllers objectAtIndex:1];
    
    NSArray *allContacts = [JYContactModel allContacts];
    __block NSUInteger unreadMessages = 0;
    [allContacts enumerateObjectsUsingBlock:^(JYContactModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        unreadMessages += obj.unreadMessages;
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (unreadMessages > 0) {
            if (unreadMessages < 100) {
                contactNav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (unsigned long)unreadMessages];
            } else {
                contactNav.tabBarItem.badgeValue = @"99+";
            }
        } else {
            contactNav.tabBarItem.badgeValue = nil;
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setChildViewControlers {
    JYSegmentViewController *dynamicVC = [[JYSegmentViewController alloc] initWithTitle:@"动态"];
    JYNavigationController *dynamicNav = [[JYNavigationController alloc] initWithRootViewController:dynamicVC];
    dynamicNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:dynamicVC.title
                                                          image:[UIImage imageNamed:@"tabbar_dynamic_normal"]
                                                  selectedImage:[[UIImage imageNamed:@"tabbar_dynamic_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    JYContactViewController *contactVC = [[JYContactViewController alloc] initWithTitle:@"消息"];
    JYNavigationController *contactNav = [[JYNavigationController alloc] initWithRootViewController:contactVC];
    contactNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:contactVC.title
                                                          image:[UIImage imageNamed:@"tabbar_message_normal"]
                                                  selectedImage:[[UIImage imageNamed:@"tabbar_message_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    JYNearViewController *nearVC = [[JYNearViewController alloc] initWithTitle:@"附近"];
    JYNavigationController *nearNav = [[JYNavigationController alloc] initWithRootViewController:nearVC];
    nearNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:nearVC.title
                                                          image:[UIImage imageNamed:@"tabbar_near_normal"]
                                                  selectedImage:[[UIImage imageNamed:@"tabbar_near_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    JYMineViewController *mineVC = [[JYMineViewController alloc] initWithTitle:@"我的"];
    JYNavigationController *mineNav = [[JYNavigationController alloc] initWithRootViewController:mineVC];
    mineNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:mineVC.title
                                                       image:[UIImage imageNamed:@"tabbar_mine_normal"]
                                               selectedImage:[[UIImage imageNamed:@"tabbar_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    
    self.tabBar.translucent = NO;
    self.delegate = self;
    self.viewControllers = @[dynamicNav,contactNav,nearNav,mineNav];
    
    [[JYAutoContactManager manager] startAutoReplayMessages];
}

#pragma mark -- UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    return YES;
}

@end

