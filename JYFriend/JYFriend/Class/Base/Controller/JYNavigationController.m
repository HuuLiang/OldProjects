//
//  JYNavigationController.m
//  JYFriend
//
//  Created by Liang on 2016/12/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYNavigationController.h"
#import "JYBaseViewController.h"

@interface JYNavigationController () <UINavigationControllerDelegate>

@end

@implementation JYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.]};
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL alwaysHideNavigationBar = NO;
    if ([viewController isKindOfClass:[JYBaseViewController class]]) {
        alwaysHideNavigationBar = ((JYBaseViewController *)viewController).alwaysHideNavigationBar;
    }
    if (self.navigationBarHidden != alwaysHideNavigationBar) {
        [self setNavigationBarHidden:alwaysHideNavigationBar animated:animated];
    }
}
@end
