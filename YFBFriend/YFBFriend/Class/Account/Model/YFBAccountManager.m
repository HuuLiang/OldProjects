//
//  YFBAccountManager.m
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBAccountManager.h"
#import "WXApi.h"
#import <AFNetworking.h>


@implementation YFBRegisterUserResponse

@end


@interface YFBAccountManager ()
@property (nonatomic,copy) RegisterResult result;
@end

@implementation YFBAccountManager
+ (instancetype)manager {
    static YFBAccountManager *_accountManger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _accountManger = [[YFBAccountManager alloc] init];
    });
    return _accountManger;
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBRegisterUserResponse class];
}

- (void)loginWithAccountAndPassword {
    
}

- (void)registerUserWithUserInfo:(YFBUser *)user handler:(void(^)(BOOL success))handler {
    [self registerUserWithUserInfo:user CompletionHandler:^(BOOL success, YFBRegisterUserResponse * resp) {
        if (success) {
            [YFBUser currentUser].userId = resp.userId;
            [YFBUser currentUser].token = resp.token;
            [YFBUser currentUser].expireTime = resp.vipExpireDate;
            [YFBUser currentUser].diamondCount = resp.myDiamonds;
            [[YFBUser currentUser] saveOrUpdateUserInfo];
        }
        if (handler) {
            handler(success);
        }
    }];
}

- (BOOL)registerUserWithUserInfo:(YFBUser *)user CompletionHandler:(QBCompletionHandler)handler {
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:@{@"channelNo":YFB_CHANNEL_NO,
                                                                                      @"loginType":@(user.loginType),
                                                                                      @"password":user.password,
                                                                                      @"nickName":user.nickName,
                                                                                      @"portraitUrl":user.userImage ?: @"",
                                                                                      @"age":@(user.age),
                                                                                      @"vocation":user.job,
                                                                                      @"education":user.education,
                                                                                      @"monthlyIncome":user.income,
                                                                                      @"height":@(user.height),
                                                                                      @"marriageStatus":@(user.marriageStatus),
                                                                                      @"gender":user.userSex == YFBUserSexMale ? @"M" : @"F"}];
    
    if (user.loginType > YFBLoginTypeDefine) {
        [userInfo setValue:user.loginName forKey:@"loginName"];
        [userInfo setValue:user.userId forKey:@"userId"];
    }
    
    BOOL success = [self requestURLPath:user.loginType > YFBLoginTypeDefine ? YFB_LOGIN_URL : YFB_USERCREATE_URL
                         standbyURLPath:nil
                             withParams:userInfo
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        YFBRegisterUserResponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                        }
                        if (handler) {
                            QBSafelyCallBlock(handler,respStatus == QBURLResponseSuccess,resp);
                        }
                    }];
    return success;
}

- (BOOL)loginUserInfoWithUserId:(NSString *)userId password:(NSString *)password handler:(void (^)(BOOL success))handler {
    NSDictionary *params = @{@"userId":userId,
                             @"password":password};
    BOOL success = [self requestURLPath:YFB_LOGIN_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBRegisterUserResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
            
            [YFBUser currentUser].userId = resp.userId;
            [YFBUser currentUser].token = resp.token;
            [YFBUser currentUser].diamondCount = resp.myDiamonds;
            [YFBUser currentUser].userImage = resp.portraitUrl;
            [YFBUser currentUser].expireTime = resp.vipExpireDate;
            [YFBUser currentUser].userSex = [resp.gender isEqualToString:@"M"] ? YFBUserSexMale : YFBUserSexFemale;
            
            [[YFBUser currentUser] saveOrUpdateUserInfo];
        }
        if (handler) {
            handler(respStatus == QBURLResponseSuccess);
        }
    }];
    return success;
}



- (void)updateUserInfoWithType:(NSString *)type content:(id)content handler:(void (^)(BOOL success))handler {
    if ([content isKindOfClass:[NSDictionary class]]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:content options:NSJSONWritingPrettyPrinted error:nil];
        if (!jsonData) {
            return;
        }
        
        content = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"type":type,
                             @"content":content};
    [self requestURLPath:YFB_UPDATEUSERINFO_URL
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        if (respStatus != QBURLResponseSuccess) {
            [[YFBHudManager manager] showHudWithText:@"未知网络问题"];
        }
        
        if (handler) {
            handler(respStatus == QBURLResponseSuccess);
        }
    }];
}


- (void)loginWithWXhandler:(RegisterResult)handler {
    _result = handler;
    
    SendAuthReq *loginReq = [[SendAuthReq alloc] init];
    loginReq.scope = @"snsapi_userinfo";
    loginReq.state = @"123";
    loginReq.openID = @"100";
    [WXApi sendReq:loginReq];
}

- (void)sendAuthRespCode:(SendAuthResp *)resp {
    NSString *tokenUrl = [NSString stringWithFormat:@"%@appid=%@&secret=%@&code=%@&grant_type=authorization_code",YFB_WECHAT_TOKEN,YFB_WEXIN_APP_ID,YFB_WECHAT_SECRET,resp.code];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:tokenUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * tokenDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (tokenDic[@"errcode"] != nil) {
            [[YFBHudManager manager] showHudWithText:[NSString stringWithFormat:@"errcode:%@\nerrmsg:%@",tokenDic[@"errcode"],tokenDic[@"errmsg"]]];
        }
        [self getUserInfoWithTokenDic:tokenDic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[YFBHudManager manager] showHudWithText:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)getUserInfoWithTokenDic:(NSDictionary *)tokenDic {
    NSString *userInfoUrl = [NSString stringWithFormat:@"%@access_token=%@&openid=%@&lang=%@",YFB_WECHAT_USERINFO,tokenDic[@"access_token"],tokenDic[@"openid"],@"zh_CN"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:userInfoUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * userInfoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        QBLog(@"responseObject:%@ \n userInfoDic:%@",responseObject,userInfoDic);
        [YFBUser currentUser].liveCity = userInfoDic[@"city"];
        [YFBUser currentUser].nickName = userInfoDic[@"nickname"];
        [YFBUser currentUser].userImage = userInfoDic[@"headimgurl"];
//        [YFBUser currentUser].userSex = [userInfoDic[@"sex"] integerValue];
        [YFBUser currentUser].loginName = userInfoDic[@"openid"];
        BOOL success = [[YFBUser currentUser] saveOrUpdate];

        if (success && self.result) {
            QBSafelyCallBlock(self.result,success);
        }
        
        if (userInfoDic[@"errcode"] != nil) {
            [[YFBHudManager manager] showHudWithText:[NSString stringWithFormat:@"errcode:%@\nerrmsg:%@",userInfoDic[@"errcode"],userInfoDic[@"errmsg"]]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[YFBHudManager manager] showHudWithText:[NSString stringWithFormat:@"%@",error]];
    }];

}

@end
