//
//  SARankDetailVC.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SABaseViewController.h"

typedef NS_ENUM(NSInteger,SARankingListType) {
    SARankingListTypeIncome = 1,
    SARankingListTypeRecruit
};

@interface SARankDetailVC : SABaseViewController

- (instancetype)initWithType:(SARankingListType)type;

@end
