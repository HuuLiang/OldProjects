//
//  SADrawMoneyDetailVC.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SABaseViewController.h"

@interface SADrawMoneyDetailVC : SABaseViewController

- (instancetype)initWithStatus:(NSString *)status;

@end

extern NSString *const kSADrawMoneyStatusAllKeyName;
extern NSString *const kSADrawMoneyStatusProcessing;
extern NSString *const kSADrawMoneyStatusSuccess;
extern NSString *const kSADrawMoneyStatusFailed;
