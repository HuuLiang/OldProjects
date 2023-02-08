//
//  YFBInteractionManager.m
//  YFBFriend
//
//  Created by Liang on 2017/4/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBInteractionManager.h"
#import "YFBRobot.h"
#import "YFBMessageModel.h"
#import "YFBAutoReplyManager.h"

static NSString *const kYFBFriendGreetToOneUserKeyName = @"kYFBFriendGreetToOneUserKeyName";
static NSString *const KYFBFriendGreetToAllUsersKeyName = @"KYFBFriendGreetToAllUsersKeyName";

NSString *const kYFBFriendReferContactQQKeyName     = @"QQ";
NSString *const kYFBFriendReferContactWXKeyName     = @"WEIXIN";
NSString *const kYFBFriendReferContactPhoneKeyName  = @"MOBILE_PHONE";

#define GreetToOneUserCount 20
#define GreetToAllUsersCount 4

@implementation YFBInteractionResponse
@end

@interface YFBInteractionManager ()
@end

@implementation YFBInteractionManager

+ (instancetype)manager {
    static YFBInteractionManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[YFBInteractionManager alloc] init];
    });
    return _manager;
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBInteractionResponse class];
}

//打招呼
- (void)greetWithUserInfoList:(NSArray<YFBRobot *> *)userList
                   toAllUsers:(BOOL)toAll
                      handler:(void (^)(BOOL))handler
{
    if (![YFBUtil isVip]) {
        NSInteger userCount = [[[NSUserDefaults standardUserDefaults] objectForKey:toAll ? KYFBFriendGreetToAllUsersKeyName : kYFBFriendGreetToOneUserKeyName] integerValue];
        NSInteger count = toAll ? GreetToAllUsersCount : GreetToOneUserCount;
        if (userCount >= count) {
            [[YFBHudManager manager] showHudWithText:toAll ? @"超出每日群体招呼次数限制" : @"超出每日单人招呼次数限制"];
            return;
        } else {
            userCount++;
            [[NSUserDefaults standardUserDefaults] setObject:@(userCount) forKey:toAll ? KYFBFriendGreetToAllUsersKeyName : kYFBFriendGreetToOneUserKeyName];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    [self fetchGreetingInfoWithUserIdStr:userList CompletionHandler:^(BOOL success, id obj) {
        QBSafelyCallBlock(handler,success);
    }];
}

- (BOOL)fetchGreetingInfoWithUserIdStr:(NSArray <YFBRobot *> *)userList
                     CompletionHandler:(QBCompletionHandler)handler
{
    NSMutableArray *availableUserList = [NSMutableArray array];
    NSMutableArray *userIdList = [NSMutableArray array];
    
    [userList enumerateObjectsUsingBlock:^(YFBRobot * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![YFBRobot checkUserIsGreetedWithUserId:obj.userId]) {
            [userIdList addObject:obj.userId];
            [availableUserList addObject:obj];
        }
    }];
    
    if (userIdList.count == 0) {
        [[YFBHudManager manager] showHudWithText:@"已打过招呼"];
        return YES;
    }
    
    NSString *userIdString = [userIdList componentsJoinedByString:@","];
    
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"userIdStr":userIdString};
    
    BOOL success = [self requestURLPath:YFB_GREET_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        if (respStatus == QBURLResponseSuccess) {
                            
//                            [[YFBAutoReplyManager manager] getAutoReplyMessageWithUserId:userIdString];
                            
                            [availableUserList enumerateObjectsUsingBlock:^(YFBRobot *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                obj.greeted = YES;
                                [obj saveOrUpdate];
                            }];
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess,nil);
                        }
                    }];
    return success;
}

//关注
- (void)concernUserWithUserId:(NSString *)userId
                      handler:(void (^)(BOOL))handler
{
    __block YFBRobot *robot = [YFBRobot findFirstByCriteria:[NSString stringWithFormat:@"where userId=\'%@\'",userId]];
    if (robot && robot.concerned) {
        [[YFBHudManager manager] showHudWithText:@"已经关注过了"];
        return;
    }
    if (!robot) {
        robot = [[YFBRobot alloc] init];
        robot.userId = userId;
    }
    [self concernOrCancleUserWithUserId:userId isConcern:YES CompletionHandler:^(BOOL success, id obj) {
        if (success) {
            
//            [[YFBAutoReplyManager manager] getAutoReplyMessageWithUserId:robot.userId];
            
            if (!robot) {
                robot = [[YFBRobot alloc] init];
                robot.userId = userId;
            }
            robot.concerned = YES;
            [robot saveOrUpdate];
            
            [[YFBHudManager manager] showHudWithText:@"关注成功"];
        } else {
            [[YFBHudManager manager] showHudWithText:@"关注失败，请重试"];
        }
        if (handler) {
            handler(success);
        }
    }];
}

//取消关注
- (void)cancleConcernUserWithUserId:(NSString *)userId
                            handler:(void (^)(BOOL))handler
{
    __block YFBRobot *robot = [YFBRobot findFirstByCriteria:[NSString stringWithFormat:@"where userId=\'%@\'",userId]];
    if (robot.concerned) {
        [self concernOrCancleUserWithUserId:userId isConcern:NO CompletionHandler:^(BOOL success, id obj) {
            if (success) {
                if (!robot) {
                    robot = [[YFBRobot alloc] init];
                    robot.userId = userId;
                }
                robot.concerned = NO;
                [robot saveOrUpdate];
                
                [[YFBHudManager manager] showHudWithText:@"取消关注成功"];
                
            } else {
                [[YFBHudManager manager] showHudWithText:@"取消关注失败，请重试"];
            }
            if (handler) {
                handler(success);
            }
        }];
    } else {
        [[YFBHudManager manager] showHudWithText:@"您还未关注TA哦"];
    }
}

- (BOOL)concernOrCancleUserWithUserId:(NSString *)userId
                            isConcern:(BOOL)isConcern
                    CompletionHandler:(QBCompletionHandler)handler
{
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"toUserId":userId};
    BOOL success = [self requestURLPath:isConcern ? YFB_CONCERN_URL : YFB_CANCELCONCERN_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,nil);
        }
    }];
    
    return success;
}

//意见反馈

- (void)sendAdviceWithContent:(NSString *)content
                      Contact:(NSString *)contact
                      handler:(void (^)(BOOL))handler
{
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"content":content,
                             @"contact":contact};
    
    [self requestURLPath:YFB_FEEDBACK_URL
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        if (handler) {
            handler(respStatus == QBURLResponseSuccess);
        }
    }];
}

//发送消息
//- (void)sendMessageInfoToUserId:(NSString *)userId
//                        content:(NSString *)content
//                           type:(NSInteger)messageType
//                        handler:(void (^)(BOOL))handler {
//    [self sendMessageInfoToUserId:userId
//                          content:content
//                             type:messageType
//                   deductDiamonds:0
//                          handler:handler];
//}

- (void)sendMessageInfoToUserId:(NSString *)userId
                        content:(NSString *)content
                           type:(NSInteger)messageType
                 deductDiamonds:(NSInteger)deductDiamonds
                        handler:(void (^)(BOOL))handler
{
    
    if ([userId isEqualToString:[YFBUser currentUser].userId]) {
        QBLog(@"出现问题啦");
        if (handler) {
            handler(true);
            return;
        }
    }
    
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"versionCode":YFB_REST_APP_VERSION,
                             @"toUserId":userId,
                             @"content":content,
                             @"msgType":@(messageType),
                             @"deductDiamonds":@(deductDiamonds)};
    
    [self requestURLPath:YFB_SENDMSG_URL
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
     {
         if (respStatus == QBURLResponseSuccess) {
//             [[YFBAutoReplyManager manager] getAutoReplyMessageWithUserId:userId];
             [YFBUser currentUser].diamondCount += deductDiamonds;
             [[YFBUser currentUser] saveOrUpdate];
         }
         
         if (handler) {
             handler(respStatus == QBURLResponseSuccess);
         }
     }];
}

//查询微信 手机 qq
- (void)referUserContactWithType:(NSString *)type toUserId:(NSString *)userId handler:(void(^)(BOOL success,NSString *contact))handler {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"toUserId":userId,
                             @"type":type};
    [self requestURLPath:YFB_REFERCONTACT_URL
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBInteractionResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,resp.contact);
        }
    }];
}

@end
