//
//  SAUserInfoModel.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "QBDataResponse.h"

@class SAUser;

@interface SAUserInfoModel : QBDataResponse

@property (nonatomic,nullable) SAUser *user;

@end
