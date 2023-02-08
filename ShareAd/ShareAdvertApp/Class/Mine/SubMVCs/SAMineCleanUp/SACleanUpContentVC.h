//
//  SACleanUpContentVC.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SABaseViewController.h"

typedef NS_ENUM(NSInteger,SAMineCleanUpType) {
    SAMineCleanUpTypeShare = 0,
    SAMineCleanUpTypeRecruit
};

@interface SACleanUpContentVC : SABaseViewController

- (instancetype)initWithType:(SAMineCleanUpType)type;

@end
