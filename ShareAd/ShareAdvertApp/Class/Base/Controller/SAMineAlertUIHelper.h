//
//  SAMineAlertUIHelper.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SABaseViewController.h"

typedef NS_ENUM(NSInteger,SAMineAlertType) {
    SAMineAlertTypeNetworkError = 0,
    SAMineAlertTypeRecruitOffline,
    SAMineAlertTypeMineCenterOffline,
    SAMineAlertTypeShareOffline,
    SAMineAlertTypeAnnouncement,
    SAMineAlertTypeSignIn,
    SAMineAlertTypeDrawSuccess,
    SAMineAlertTypeBingding,
    SAMineAlertTypeQRCode,
    SAMineAlertTypeCount
};

@interface SAMineAlertUIHelper : SABaseViewController

+ (void)showAlertUIWithType:(SAMineAlertType)type onCurrentVC:(UIViewController *)currentViewController;

@end
