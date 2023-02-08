//
//  SADrawMoneyModel.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "QBDataResponse.h"

@interface SADrawDetailModel : NSObject
@property (nonatomic) NSInteger wiAmount;
@property (nonatomic) NSString *wiStatus;
@property (nonatomic) NSString *createTime;
@end

@interface SADrawMoneyModel : QBDataResponse

@property (nonatomic) NSArray <SADrawDetailModel *> * withdraw;

@end
