//
//  YFBAccountManager.h
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@class SendAuthResp;

@interface YFBRegisterUserResponse : QBURLResponse
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *gender;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *portraitUrl;
@property (nonatomic) NSInteger myDiamonds;
@property (nonatomic) NSString *vipExpireDate;
@property (nonatomic) NSString *token;
@end

typedef void(^RegisterResult)(BOOL success);

@interface YFBAccountManager : QBEncryptedURLRequest
+ (instancetype)manager;
- (void)loginWithQQ;
- (void)loginWithWXhandler:(RegisterResult)handler;
- (void)loginWithAccountAndPassword;
- (void)sendAuthRespCode:(SendAuthResp *)resp;
- (void)registerUserWithUserInfo:(YFBUser *)user handler:(void(^)(BOOL success))handler;
- (BOOL)loginUserInfoWithUserId:(NSString *)userId password:(NSString *)password handler:(void (^)(BOOL success))handler;
- (void)updateUserInfoWithType:(NSString *)type content:(id)content handler:(void (^)(BOOL success))handler;
@end
