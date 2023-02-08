//
//  SAUserAccountModel.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "QBDataResponse.h"

@interface SAUserAccountDetailModel : NSObject

/** 当前金额 */
@property (nonatomic) NSInteger amount;

/** 累计收徒金额 */
@property (nonatomic) NSInteger apAmount;

/** 累计徒弟赚钱分成金额 */
@property (nonatomic) NSInteger apDiAmount;

/** 累计收徒个数 */
@property (nonatomic) NSInteger apNumber;

/** 今日收入 */
@property (nonatomic) NSInteger todayAmount;

/** 今日收徒个数 */
@property (nonatomic) NSInteger todayApNumber;

/** 累计金额 */ 
@property (nonatomic) NSInteger totalAmount;

/** 用户id */
@property (nonatomic) NSString *userId;
@end

@interface SAUserAccountModel : QBDataResponse

+ (instancetype)account;

@property (nonatomic) SAUserAccountDetailModel *account;

- (void)refreshAccountInfo;

@end
