//
//  JYUpdateUserVipModel.m
//  JYFriend
//
//  Created by Liang on 2017/1/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYUpdateUserVipModel.h"
#import "JYSystemConfigModel.h"


@implementation JYUpdateUserVipResponse


@end


@implementation JYUpdateUserVipModel

+ (Class)responseClass {
    return [JYUpdateUserVipResponse class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 30;
}

- (BOOL)updateUserVipInfo:(JYVipType)vipType CompletionHandler:(QBCompletionHandler)handler {
    NSInteger months = 0;
    if (vipType == JYVipTypeYear) {
        months = [JYSystemConfigModel sharedModel].vipMonthC;
    } else if (vipType == JYVipTypeQuarter) {
        months = [JYSystemConfigModel sharedModel].vipMonthB;
    } else if (vipType == JYVipTypeMonth) {
        months = [JYSystemConfigModel sharedModel].vipMonthA;
    }
    
    
    NSDictionary *params = @{@"userId":[JYUser currentUser].userId,
                             @"vipMonths":@(months)};
    
    BOOL success = [self requestURLPath:JY_VIPUPDATE_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        JYUpdateUserVipResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
            [JYUtil setVipExpireTime:resp.vipEndDate];
        }
    }];
    
    return success;
}

@end
