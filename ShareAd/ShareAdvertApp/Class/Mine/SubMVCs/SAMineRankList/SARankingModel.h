//
//  SARankingModel.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "QBDataResponse.h"

@interface SARankDetailModel : NSObject
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *portraitUrl;
@property (nonatomic) NSInteger value;
@property (nonatomic) NSInteger type;
@end

@interface SARankingModel : QBDataResponse
@property (nonatomic) NSArray <SARankDetailModel *> * ranking;
@end
