//
//  SANavigationController.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SANavigationController.h"
#import "SABaseViewController.h"

@interface SANavigationController () <UINavigationControllerDelegate>

@end

@implementation SANavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.],
                                               NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    self.delegate = self;
//    self.navigationBar.backgroundColor = kColor(@"#FF3366");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL alwaysHideNavigationBar = NO;
    
    if ([viewController isKindOfClass:[SABaseViewController class]]) {
        alwaysHideNavigationBar = ((SABaseViewController *)viewController).alwaysHideNavigationBar;
    }
    
    if (self.navigationBarHidden != alwaysHideNavigationBar) {
        [self setNavigationBarHidden:alwaysHideNavigationBar animated:animated];
    }
    
//    BOOL hideBarBottomLine = NO;
//    
//    if ([viewController isKindOfClass:[SABaseViewController class]]) {
//        hideBarBottomLine = ((SABaseViewController *)viewController).hideBarBottomLine;
//    }
//    
//    if (hideBarBottomLine) {
//        self.navigationBar.barStyle = UIBaselineAdjustmentAlignCenters;
//    } else {
//        self.navigationBar.barStyle = UIBaselineAdjustmentAlignBaselines;
//    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

@end
