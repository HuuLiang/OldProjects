//
//  SAShareManager.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBDataResponse.h"

@class BaseResp;
@class SendAuthResp;
@class SAShareContentProgramModel;

@interface SAShareManager : QBDataResponse

+ (instancetype)manager;

- (void)startToShareWithModel:(SAShareContentProgramModel *)programModel;

- (void)startToRecruitUrlWoWx;

- (void)fetchUserInfoWithWx:(SACompletionHandler)handler;

- (void)receiveWxResp:(BaseResp *)resp;

- (void)sendAuthRespCode:(SendAuthResp *)resp;

@end
