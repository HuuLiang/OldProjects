//
//  SAReqManager.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAReqManager.h"
#import "QBDataManager.h"
#import "QBDataResponse.h"

@implementation SAReqManager

+ (instancetype)manager {
    static SAReqManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[SAReqManager alloc] init];
    });
    return _manager;
}

- (NSDictionary *)params {
    NSDictionary *baseParams = @{@"appId":SA_REST_APPID,
                                 @"channelNo":SA_CHANNEL_NO,
                                 @"appVersion":SA_REST_APP_VERSION,
                                 @"cVersion":SA_CONTENT_VERSION};
    return baseParams;
}

- (BOOL)checkResponseCodeObject:(id)obj error:(NSError *)error {
    QBLog(@"obj=%@ error = %@",obj,error);
    
    if (!obj || error) {
        return NO;
    }
    
    QBDataResponse *resp = obj;
    NSInteger respCode = [resp.code integerValue];
    switch (respCode) {
        case 200:
            return YES;
            break;
        
        case 300:
            [[SAHudManager manager] showHudWithText:@"参数不正确"];
            return NO;
            break;
            
        case 301:
            [[SAHudManager manager] showHudWithText:@"手机号已经注册"];
            return NO;
            break;
            
        case 302:
            [[SAHudManager manager] showHudWithText:@"账号或密码不正确"];
            return NO;
            break;
            
        case 303:
            [[SAHudManager manager] showHudWithText:@"账号余额不足"];
            return NO;
            break;
            
        case 304:
            [[SAHudManager manager] showHudWithText:@"已签到"];
            return NO;
            break;
        
        case 305:
            [[SAHudManager manager] showHudWithText:@"验证码不正确"];
            return NO;
            break;

        case 306:
            [[SAHudManager manager] showHudWithText:@"手机号未注册"];
            return NO;
            break;
            
        case 307:
            [[SAHudManager manager] showHudWithText:@"更新失败"];
            return NO;
            break;
            
        case 400:
            [[SAHudManager manager] showHudWithText:@"解密失败"];
            return NO;
            break;
            
        case 401:
            [[SAHudManager manager] showHudWithText:@"签名不通过"];
            return NO;
            break;

        case 500:
            [[SAHudManager manager] showHudWithText:@"系统异常"];
            return NO;
            break;

        
        default:
            return NO;
            break;
    }
}

- (void)fetchColumnContentWithClass:(Class)modelClass CompletionHandler:(SACompletionHandler)handler {
    [[QBDataManager manager] requestUrl:SA_SHARECOLUMN_URL
                             withParams:[self params]
                                  class:modelClass
                                handler:^(id obj, NSError *error)
    {
        handler([self checkResponseCodeObject:obj error:error],obj);
    }];
}

- (void)fetchShareListWithColumnId:(NSString *)columnId class:(Class)modelClass handler:(SACompletionHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self params]];
    [params setObject:columnId forKey:@"columnId"];
    
    [[QBDataManager manager] requestUrl:SA_SHARELIST_URL
                             withParams:params
                                  class:modelClass handler:^(id obj, NSError *error)
    {
        handler([self checkResponseCodeObject:obj error:error],obj);
    }];
}

- (void)fetchActivateInfoWithClass:(Class)modelClass Handler:(SACompletionHandler)handler {
    [[QBDataManager manager] requestUrl:SA_ACTIVATE_URL
                             withParams:[self params]
                                  class:modelClass
                                handler:^(id obj, NSError *error)
    {
        handler([self checkResponseCodeObject:obj error:error],obj);
    }];
}

- (void)registerUserWithInfo:(SAUser *)userInfo class:(Class)modelClass handler:(SACompletionHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self params]];
    [params addEntriesFromDictionary:@{@"phone":userInfo.phone,
                                       @"password":userInfo.password,
                                       @"code":userInfo.verifyCode,
                                       @"nickName":userInfo.nickName}];
    
    [[QBDataManager manager] requestUrl:SA_REGISTER_URL
                             withParams:params
                                  class:modelClass
                                handler:^(id obj, NSError *error)
    {
        handler([self checkResponseCodeObject:obj error:error],obj);
    }];
}

- (void)changePasswordWithInfo:(SAUser *)userInfo class:(Class)modelClass handler:(SACompletionHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self params]];
    [params addEntriesFromDictionary:@{@"phone":userInfo.phone,
                                       @"password":userInfo.password,
                                       @"code":userInfo.verifyCode}];
    
    [[QBDataManager manager] requestUrl:SA_RESET_URL
                             withParams:params
                                  class:modelClass
                                handler:^(id obj, NSError *error)
     {
         handler([self checkResponseCodeObject:obj error:error],obj);
     }];
}

- (void)loginWithPhontNumber:(NSString *)phone password:(NSString *)password class:(Class)modelClass handler:(SACompletionHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self params]];
    [params addEntriesFromDictionary:@{@"phone":phone,
                                       @"password":password}];
    
    [[QBDataManager manager] requestUrl:SA_LOGIN_URL withParams:params class:modelClass handler:^(id obj, NSError *error) {
        handler([self checkResponseCodeObject:obj error:error],obj);
    }];
}

- (void)fetchConfigInfoClass:(Class)modelClass handler:(SACompletionHandler)handler {
    [[QBDataManager manager] requestUrl:SA_CONFIG_URL
                             withParams:[self params]
                                  class:modelClass
                                handler:^(id obj, NSError *error)
     {
        handler([self checkResponseCodeObject:obj error:error],obj);
    }];
}

- (void)fetchUserInfoWithUserId:(NSString *)userId class:(Class)modelClass handler:(SACompletionHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self params]];
    [params addEntriesFromDictionary:@{@"userId":userId}];
    
    [[QBDataManager manager] requestUrl:SA_USERINFO_URL
                             withParams:params
                                  class:modelClass
                                handler:^(id obj, NSError *error)
    {
        handler([self checkResponseCodeObject:obj error:error],obj);
    }];
}

- (void)updateUserInfoWithInfo:(NSDictionary *)userInfo class:(Class)modelClass handler:(SACompletionHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self params]];
    [params addEntriesFromDictionary:userInfo];
    
    [[QBDataManager manager] requestUrl:SA_UPDATEUSER_URL
                             withParams:params
                                  class:modelClass
                                handler:^(id obj, NSError *error)
     {
         handler([self checkResponseCodeObject:obj error:error],obj);
     }];
}

- (void)fetchDrawMoenyStatusWithStatus:(NSString *)status
                                  Page:(NSInteger)page
                                 class:(Class)modelClass
                               handler:(SACompletionHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self params]];
    [params addEntriesFromDictionary:@{@"wiStatus":status,
                                       @"page":@(page),
                                       @"userId":[SAUser user].userId}];
    
    [[QBDataManager manager] requestUrl:SA_QUERYWITHDRAW_URL
                             withParams:params
                                  class:modelClass
                                handler:^(id obj, NSError *error)
     {
         handler([self checkResponseCodeObject:obj error:error],obj);
     }];
}

- (void)fetchAccountDetailWithPage:(NSInteger)page class:(Class)modelClass handler:(SACompletionHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self params]];
    [params addEntriesFromDictionary:@{@"page":@(page),
                                       @"userId":[SAUser user].userId}];
    
    [[QBDataManager manager] requestUrl:SA_QUERYACCOUNT_URL
                             withParams:params
                                  class:modelClass
                                handler:^(id obj, NSError *error)
     {
         handler([self checkResponseCodeObject:obj error:error],obj);
     }];
}

- (void)fetchRankingListWithType:(NSInteger)type class:(Class)modelClass handler:(SACompletionHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self params]];
    [params addEntriesFromDictionary:@{@"type":@(type),
                                       @"userId":[SAUser user].userId}];
    
    [[QBDataManager manager] requestUrl:SA_RANKING_URL
                             withParams:params
                                  class:modelClass
                                handler:^(id obj, NSError *error)
     {
         handler([self checkResponseCodeObject:obj error:error],obj);
     }];
}

- (void)fetchUserAccountInfoWithClass:(Class)modelClass handler:(SACompletionHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self params]];
    [params addEntriesFromDictionary:@{@"userId":[SAUser user].userId}];
    
    [[QBDataManager manager] requestUrl:SA_ACCOUNT_URL
                             withParams:params
                                  class:modelClass
                                handler:^(id obj, NSError *error)
     {
         handler([self checkResponseCodeObject:obj error:error],obj);
     }];
}

- (void)updateShareBountyWithPrice:(NSInteger)amount shareId:(NSString *)shareId class:(Class)modelClass handler:(SACompletionHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self params]];
    [params addEntriesFromDictionary:@{@"userId":[SAUser user].userId,
                                       @"amount":@(amount),
                                       @"shareId":shareId}];
    
    [[QBDataManager manager] requestUrl:SA_SHAREBOUNTY_URL
                             withParams:params
                                  class:modelClass
                                handler:^(id obj, NSError *error)
     {
         handler([self checkResponseCodeObject:obj error:error],obj);
     }];
}

- (void)signWithClass:(Class)modelClass handler:(SACompletionHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self params]];
    [params addEntriesFromDictionary:@{@"userId":[SAUser user].userId}];
    
    [[QBDataManager manager] requestUrl:SA_SIGN_URL
                             withParams:params
                                  class:modelClass
                                handler:^(id obj, NSError *error)
     {
         handler([self checkResponseCodeObject:obj error:error],obj);
     }];
}

- (void)drwaMoneyWithAmount:(NSInteger)amount class:(Class)modelClass handler:(SACompletionHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self params]];
    [params addEntriesFromDictionary:@{@"userId":[SAUser user].userId,
                                       @"amount":@(amount)}];
    
    [[QBDataManager manager] requestUrl:SA_WITHDRAW_URL
                             withParams:params
                                  class:modelClass
                                handler:^(id obj, NSError *error)
     {
         handler([self checkResponseCodeObject:obj error:error],obj);
     }];
}

- (void)fetchRecruitInfoWithClass:(Class)modelClass hanler:(SACompletionHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self params]];
    [params addEntriesFromDictionary:@{@"userId":[SAUser user].userId}];
    
    [[QBDataManager manager] requestUrl:SA_QUERYAPPRENTICE_URL
                             withParams:params
                                  class:modelClass
                                handler:^(id obj, NSError *error)
     {
         handler([self checkResponseCodeObject:obj error:error],obj);
     }];
}


@end
