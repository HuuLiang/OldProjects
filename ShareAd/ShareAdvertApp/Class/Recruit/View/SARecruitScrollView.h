//
//  SARecruitScrollView.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SARecruitScrollView : UIView

@property (nonatomic) SAAction startRecruitAction;
@property (nonatomic) SAAction QRCodeRecruitAction;

@property (nonatomic) NSInteger toRecruitCount;
@property (nonatomic) NSInteger allRecruitCount;
@property (nonatomic) NSInteger toBalanceCount;
@property (nonatomic) NSInteger allBalanceCount;

@end
