//
//  SAAccountDetailCell.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger,SAMineAccountDetailStatus) {
//    SAMineAccountDetailStatusRegister = 0,  //注册
//    SAMineAccountDetailStatusSignIn,        //签到
//    SAMineAccountDetailStatusShare,         //分享
//    SAMineAccountDetailStatusRecruit,       //招募
//    SAMineAccountDetailStatusRevenue        //分成
//};

@interface SAAccountDetailCell : UITableViewCell

//@property (nonatomic) SAMineAccountDetailStatus incomeStatus;

@property (nonatomic) NSString *type;

@property (nonatomic) NSString *count;

@property (nonatomic) NSString *timeStr;

@end
