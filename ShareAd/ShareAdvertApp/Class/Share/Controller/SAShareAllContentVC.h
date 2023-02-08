//
//  SAShareAllContentVC.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SABaseViewController.h"

@class SAShareColumnModel;

@interface SAShareAllContentVC : SABaseViewController

+ (void)showAllContentVCWithDataSource:(NSArray *)dataSource height:(CGFloat)height InCurrentVC:(UIViewController *)currentVC;

@property (nonatomic) NSArray <SAShareColumnModel *> *dataSource;

@property (nonatomic) CGFloat height;

@end
