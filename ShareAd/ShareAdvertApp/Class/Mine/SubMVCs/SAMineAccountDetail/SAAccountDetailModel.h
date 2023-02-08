//
//  SAAccountDetailModel.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "QBDataResponse.h"

@interface SADetailModel : NSObject
@property (nonatomic) NSInteger amount;
@property (nonatomic) NSString * type;
@property (nonatomic) NSString * createTime;
@end

@interface SAAccountDetailModel : QBDataResponse
@property (nonatomic) NSArray <SADetailModel *> *accounting;
@end
