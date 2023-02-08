//
//  JYRegisterUserModel.m
//  JYFriend
//
//  Created by Liang on 2017/1/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYRegisterUserModel.h"

@implementation JYRegisterUserResponse

@end


@implementation JYRegisterUserModel

+ (Class)responseClass {
    return [JYRegisterUserResponse class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (BOOL)registerUserWithUserInfo:(JYUser *)user completionHandler:(QBCompletionHandler)handler {
    
//    if (user.birthday == nil || user.birthday.length == 0 || [user.birthday isEqualToString:@""]) {
//        user.birthday = @"";
//    } else {
        user.birthday = [JYUtil timeStringFromDate:[JYUtil dateFromString:user.birthday WithDateFormat:kDateFormatChina] WithDateFormat:kDateFormatShort];
//    }
//    
//    if (user.homeTown == nil || user.homeTown.length == 0) {
//        user.homeTown = @"未填写";
//    }
//    
//    if (user.height == nil || user.height == 0) {
//        user.height = @"未填写";
//    }
    
    NSDictionary *params = @{@"uuid":[JYUtil UUID] ? [JYUtil UUID] : @"",
                             @"nickName":user.nickName,
                             @"clientId":@"defaultClientId",
                             @"province":user.homeTown,
                             @"city":user.homeTown,
                             @"sex":[JYUserSexStringGet objectAtIndex:user.userSex],
                             @"userType":@(2),
                             @"height":user.height,
                             @"birthday":user.birthday};
    
    BOOL success = [self requestURLPath:JY_USERCREATE_URL
                         standbyURLPath:[JYUtil getStandByUrlPathWithOriginalUrl:JY_USERCREATE_URL params:nil]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        JYRegisterUserResponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                        }
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess , resp.userId);
                        }
                    }];
    
    return success;
}


@end
