//
//  SADrawMoneyCell.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SAMineDrawMoneyStatus) {
    SAMineDrawMoneyStatusAllRecrod = 0,
    SAMineDrawMoneyStatusProcessing,
    SAMineDrawMoneyStatusFailed,
    SAMineDrawMoneyStatusSuccess
};

@interface SADrawMoneyCell : UITableViewCell

@property (nonatomic) SAMineDrawMoneyStatus drawStatus;

@property (nonatomic) NSString *count;

@property (nonatomic) NSString *timeStr;

@end
