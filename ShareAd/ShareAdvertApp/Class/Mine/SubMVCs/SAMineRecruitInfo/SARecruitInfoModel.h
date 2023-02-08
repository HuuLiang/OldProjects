//
//  SARecruitInfoModel.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "QBDataResponse.h"

@interface SARecruitDetailModel : NSObject
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *createTime;
@end

@interface SARecruitInfoModel : QBDataResponse
@property (nonatomic) NSArray <SARecruitDetailModel *> * apprentice;
@end
