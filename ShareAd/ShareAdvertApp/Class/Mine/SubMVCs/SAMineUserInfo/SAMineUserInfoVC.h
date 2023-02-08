//
//  SAMineUserInfoVC.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SABaseViewController.h"

typedef NS_ENUM(NSInteger,SAPushUserInfoVCType) {
    SAPushUserInfoVCTypeNormal = 0,
    SAPushUserInfoVCTypeWx
};

@interface SAMineUserInfoVC : SABaseViewController

@property (nonatomic) SAPushUserInfoVCType type;

@end
