//
//  SABaseViewController.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SABaseViewController : UIViewController

@property (nonatomic) BOOL alwaysHideNavigationBar;

- (instancetype)initWithTitle:(NSString *)title;

- (void)pushViewControllerWith:(Class)classVC title:(NSString *)title;

@end
