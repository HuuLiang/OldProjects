//
//  SABaseViewController.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SABaseViewController.h"

@interface SABaseViewController ()

@end

@implementation SABaseViewController

- (instancetype)initWithTitle:(NSString *)title {
    self = [self init];
    if (self) {
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewControllerWith:(Class)classVC title:(NSString *)title {
    UIViewController *targetVC = [[classVC alloc] initWithTitle:title];
    [self.navigationController pushViewController:targetVC animated:YES];
}

@end
