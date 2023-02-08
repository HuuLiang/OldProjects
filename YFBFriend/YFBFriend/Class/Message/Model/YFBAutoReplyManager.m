//
//  YFBAutoReplyManager.m
//  YFBFriend
//
//  Created by Liang on 2017/5/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBAutoReplyManager.h"
#import "YFBMessageModel.h"
#import "YFBContactManager.h"
#import "YFBContactView.h"

static NSString *const kYFBFriendGetRobotReplyMessageKeyName = @"kYFBFriendGetRobotReplyMessageKeyName";

static NSString *const KYFBFriendGetRobotTimesKeyName = @"KYFBFriendGetRobotTimesKeyName";

static const NSUInteger kRollingTimeInterval = 5;

@implementation YFBAutoReplyMessage
@end

@implementation YFBRobotMsgModel
@end

@implementation YFBRobotContactModel
- (Class)robotMsgListElementClass {
    return [YFBRobotMsgModel class];
}
@end

@implementation YFBAutoReplyResponse
- (Class)userListElementClass {
    return [YFBRobotContactModel class];
}

- (Class)userLoginInfoClass {
    return [YFBRobotContactModel class];
}

@end

@interface YFBAutoReplyManager ()
@property (nonatomic,retain) dispatch_queue_t replyQueue;
@property (nonatomic,strong) dispatch_source_t timer;
@property (nonatomic) __block NSUInteger timeInterval;
@end

@implementation YFBAutoReplyManager
QBDefineLazyPropertyInitialization(NSMutableArray, allReplyMsgs);

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBAutoReplyResponse class];
}


+ (instancetype)manager {
    static YFBAutoReplyManager *_autoReplyManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _autoReplyManager = [[YFBAutoReplyManager alloc] init];
    });
    return _autoReplyManager;
}

- (void)deleteYesterdayMessages {
    //删除数据库中不是今天的数据
    if(![YFBUtil isToday]) {
        [YFBAutoReplyMessage deleteObjectsByCriteria:[NSString stringWithFormat:@"where messageTime!=\'%@\'",[YFBUtil timeStringFromDate:[NSDate date] WithDateFormat:KDateFormatShortest]]];
        [YFBMessageModel deleteAllPreviouslyMessages];
    }
}

- (void)getRobotReplyMessages {
    //需要将dispatch_source_t timer设置为成员变量，不然会立即释放@property (nonatomic, strong) dispatch_source_t timer;
    //定时器开始执行的延时时间NSTimeInterval delayTime = 3.0f;
    //定时器间隔时间NSTimeInterval timeInterval = 3.0f;
    //创建子线程队列dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //使用之前创建的队列来创建计时器_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置延时执行时间，delayTime为要延时的秒数dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC));
    //设置计时器dispatch_source_set_timer(_timer, startDelayTime, timeInterval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    // 启动计时器dispatch_resume(_timer);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_source_set_timer(_timer, delayTime, 1*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        //执行事件
        QBLog(@"注意当前的计时器时间 %ld",_timeInterval);
        if (_timeInterval == 0 || _timeInterval == 60 * 5 || _timeInterval == 60 * 10) {
            
            __block NSNumber * reqNum = [[NSUserDefaults standardUserDefaults] objectForKey:KYFBFriendGetRobotTimesKeyName];
            if (!reqNum) {
                reqNum = @(1);
                [[NSUserDefaults standardUserDefaults] setObject:reqNum forKey:KYFBFriendGetRobotTimesKeyName];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                                     @"userId":[YFBUser currentUser].userId,
                                     @"token":[YFBUser currentUser].token,
                                     @"pageNum":reqNum};
            
            [self requestURLPath:YFB_MSGLIST_URL
                  standbyURLPath:nil
                      withParams:params
                 responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
             {
                 YFBAutoReplyResponse *resp = nil;
                 if (respStatus == QBURLResponseSuccess) {
                     resp = self.response;
                     if (resp.userList.count > 0) {
                         reqNum = @([reqNum integerValue] + 1);
                         [[NSUserDefaults standardUserDefaults] setObject:reqNum forKey:KYFBFriendGetRobotTimesKeyName];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                     }
                     [self saveRobotMessagesWith:resp.userList];
//                     [self performSelector:@selector(getRobotReplyMessages) withObject:nil afterDelay:60*15];
                 }
             }];
        }
        _timeInterval++;
        [[NSUserDefaults standardUserDefaults] setObject:@(_timeInterval) forKey:kYFBFriendGetRobotMsgTimeIntervalKeyName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
    
     _timeInterval = [[[NSUserDefaults standardUserDefaults] objectForKey:kYFBFriendGetRobotMsgTimeIntervalKeyName] integerValue];
    
    if (![YFBUtil isVip] || [YFBUser currentUser].diamondCount < 100) {
        if (![YFBUtil isToday]) {
            //判断不是今天 刷新在线市场计时器
            _timeInterval = 0;
            [[NSUserDefaults standardUserDefaults] setObject:@(_timeInterval) forKey:kYFBFriendGetRobotMsgTimeIntervalKeyName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_resume(_timer);
        } else {
            //是今天 沿用保存的时间继续开始计时器
            if (_timeInterval > 60 * 20) {
                //如果在线时间超过规定的时间 则不做处理
                return;
            } else {
                //如果不超出规定时间 则继续计时
                dispatch_resume(_timer);
            }
        }
    }
}

- (void)getAutoReplyMessageWithUserId:(NSString *)userId {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"userIdStr":userId};
    [self requestURLPath:YFB_GETMSGLIST_URL
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBAutoReplyResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
            [self saveRobotMessagesWith:resp.userList];
        }
    }];
}

- (void)getRobotInfoWith:(NSString *)userId handler:(void (^)(YFBRobotContactModel *))handler {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"userIdStr":userId};
    [self requestURLPath:YFB_GETMSGLIST_URL
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
     {
         YFBAutoReplyResponse *resp = nil;
         if (respStatus == QBURLResponseSuccess) {
             resp = self.response;
         }
         if (handler && [resp.userList firstObject]) {
             handler([resp.userList firstObject]);
         }
     }];
}

- (void)insertAutoReplyMessageWithUserIs:(NSString *)userId MessageContent:(NSString *)messageContent {
    __block YFBAutoReplyMessage *replyMsgCache = [YFBAutoReplyMessage findFirstByCriteria:[NSString stringWithFormat:@"where userId=\'%@\'",userId]];
    if (!replyMsgCache) {
        replyMsgCache = [[YFBAutoReplyMessage alloc] init];
        [self getRobotInfoWith:userId handler:^(YFBRobotContactModel * robotContactModel) {
            replyMsgCache.userId = robotContactModel.userId;
            replyMsgCache.nickName = robotContactModel.nickName;
            replyMsgCache.portraitUrl = robotContactModel.portraitUrl;
            replyMsgCache.age = robotContactModel.age;
            replyMsgCache.height = robotContactModel.height;
            replyMsgCache.gender = robotContactModel.gender;
            replyMsgCache.content = messageContent;
            replyMsgCache.msgType = YFBMessageTypeText;//YFBMessageTypeText
//            replyMsgCache.msgId = 1;
            replyMsgCache.replyTime = [[NSDate date] timeIntervalSince1970] + arc4random() % 121 + 60;
            replyMsgCache.replyed = NO;
            [replyMsgCache saveOrUpdate];
            [self.allReplyMsgs addObject:replyMsgCache];
        }];
    } else {
        replyMsgCache.userId = replyMsgCache.userId;
        replyMsgCache.nickName = replyMsgCache.nickName;
        replyMsgCache.portraitUrl = replyMsgCache.portraitUrl;
        replyMsgCache.age = replyMsgCache.age;
        replyMsgCache.height = replyMsgCache.height;
        replyMsgCache.gender = replyMsgCache.gender;
        replyMsgCache.content = messageContent;
        replyMsgCache.msgType = YFBMessageTypeText;//YFBMessageTypeText
        //            replyMsgCache.msgId = 1;
        replyMsgCache.replyTime = [[NSDate date] timeIntervalSince1970] + arc4random() % 121 + 60;
        replyMsgCache.replyed = NO;
        [replyMsgCache saveOrUpdate];
        [self.allReplyMsgs addObject:replyMsgCache];
    }
}

- (void)getRandomReplyMessage {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token};
    [self requestURLPath:YFB_RANDOMMSG_URL
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBAutoReplyResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
            
            YFBRobotMsgModel *robotMsgModel = [resp.userLoginInfo.robotMsgList firstObject];
            if (!robotMsgModel) {
                [self getRandomReplyMessage];
                return ;
            }
            
            YFBAutoReplyMessage *autoReplyMessage = [YFBAutoReplyMessage findFirstByCriteria:[NSString stringWithFormat:@"where msgId=%ld",(long)robotMsgModel.msgId]];
            if (autoReplyMessage) {
                [self getRandomReplyMessage];
                return;
            }
            
            if (!autoReplyMessage) {
                YFBAutoReplyMessage *autoReplyMessage = [[YFBAutoReplyMessage alloc] init];
                autoReplyMessage.userId = resp.userLoginInfo.userId;
                autoReplyMessage.nickName = resp.userLoginInfo.nickName;
                autoReplyMessage.portraitUrl = resp.userLoginInfo.portraitUrl;
                autoReplyMessage.content = robotMsgModel.content;
                autoReplyMessage.msgId = robotMsgModel.msgId;
                autoReplyMessage.msgType = robotMsgModel.msgType;
                autoReplyMessage.age = resp.userLoginInfo.age;
                autoReplyMessage.height = resp.userLoginInfo.height;
                autoReplyMessage.gender = resp.userLoginInfo.gender;
                autoReplyMessage.replyTime = [[NSDate date] timeIntervalSince1970] + 1;
                autoReplyMessage.replyed = NO;
                [autoReplyMessage saveOrUpdate];
                
                [self sendReplyMessage:autoReplyMessage];
            }
        }
    }];
}

- (void)sendReplyMessage:(YFBAutoReplyMessage *)replyMessage {
    if (self.canReplyNotificationMessage) {
        [self insertReplyMessageInfo:replyMessage];
    } else {
        [self performSelector:@selector(sendReplyMessage:) withObject:replyMessage afterDelay:1];
    }
}

- (void)saveRobotMessagesWith:(NSArray <YFBRobotContactModel *>*)userList {
    __block NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    
    [userList enumerateObjectsUsingBlock:^(YFBRobotContactModel * _Nonnull contactRobot, NSUInteger idx, BOOL * _Nonnull stop)
     {
         
         if (idx == 0) {
             timeInterval = 10 + timeInterval;//10秒以后开始回复 初始化回复时间
         } else {
             timeInterval = timeInterval + arc4random() % 30 + 15;
         }
         
         __block NSTimeInterval userMsgTime = timeInterval;
//         __block NSTimeInterval randomTime = 0;
         [contactRobot.robotMsgList enumerateObjectsUsingBlock:^(YFBRobotMsgModel * _Nonnull robotMsg, NSUInteger idx, BOOL * _Nonnull stop)
          {
//#ifdef DEBUG
//              userMsgTime += 10;
//#else
//             NSInteger randomTime = arc4random() % 7 + 14;
              userMsgTime += arc4random() % 30 + 18;
//#endif
              YFBAutoReplyMessage *autoReplyMessage = [YFBAutoReplyMessage findFirstByCriteria:[NSString stringWithFormat:@"where msgId=%ld",(long)robotMsg.msgId]];
              if (!autoReplyMessage) {
                  YFBAutoReplyMessage *autoReplyMessage = [[YFBAutoReplyMessage alloc] init];
                  autoReplyMessage.userId = contactRobot.userId;
                  autoReplyMessage.nickName = contactRobot.nickName;
                  autoReplyMessage.portraitUrl = contactRobot.portraitUrl;
                  autoReplyMessage.content = robotMsg.content;
                  autoReplyMessage.msgId = robotMsg.msgId;
                  autoReplyMessage.msgType = robotMsg.msgType;
                  autoReplyMessage.imgUrl = robotMsg.imgUrl;
                  autoReplyMessage.age = contactRobot.age;
                  autoReplyMessage.height = contactRobot.height;
                  autoReplyMessage.gender = contactRobot.gender;
                  autoReplyMessage.replyTime = userMsgTime;
                  autoReplyMessage.replyed = NO;
                  [autoReplyMessage saveOrUpdate];
              }
          }];
     }];
    
    //每次保存完新的自动回复消息之后都刷新内存中的回复池数据
    [self findAllAutoReplyMessages];
}

//获取所有的自动回复信息
- (void)findAllAutoReplyMessages {
    [self.allReplyMsgs removeAllObjects];
    NSArray *array = [YFBAutoReplyMessage findByCriteria:[NSString stringWithFormat:@"where replyed=0 order by replyTime asc"]];
    [self.allReplyMsgs addObjectsFromArray:array];
}


- (void)startAutoRollingToReply {
    if (self.replyQueue) {
        return;
    }
    self.replyQueue = dispatch_queue_create("YFBFriend.AutoReply.Queue", nil);
    [self findAllAutoReplyMessages];
    [self rollingReplayMessages];
}

- (void)rollingReplayMessages {
    if (![[UIApplication sharedApplication].keyWindow.rootViewController isBeingPresented]) {
        dispatch_async(self.replyQueue, ^{
            
            __block uint nextRollingReplyTime = kRollingTimeInterval;
            
            if (self.allReplyMsgs.count > 0) {
                [self.allReplyMsgs enumerateObjectsUsingBlock:^(YFBAutoReplyMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
                    if (obj.replyTime <= currentTimeInterval) {
                        [self insertReplyMessageInfo:obj];
                    } else {
                        NSTimeInterval nextTime = obj.replyTime - [[NSDate date] timeIntervalSince1970];
                        if (nextTime < nextRollingReplyTime) {
                            nextRollingReplyTime = nextTime;
                        }
                        QBLog(@"下次循环推送时间 %d",nextRollingReplyTime);
                    }
                }];
            }
            
            QBLog(@"回复池数量%ld 下次循环推送时间 %d",self.allReplyMsgs.count,nextRollingReplyTime);
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                sleep(nextRollingReplyTime);
                [self rollingReplayMessages];
            });
        });
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            sleep(2);
            [self rollingReplayMessages];
        });
    }
}

- (void)insertReplyMessageInfo:(YFBAutoReplyMessage *)replyMessage {
    
    [self insertReplyMessageIntoMessageModelWithInfo:replyMessage];
    
    [self insertReplyMessageIntoContactModelWithInfo:replyMessage];
    
    //标记已经回复过的缓存
    replyMessage.replyed = YES;
    [replyMessage saveOrUpdate];
    
    //删除内存中已经回复的消息
    [self.allReplyMsgs removeObject:replyMessage];
}

//向聊天详情中插入一条记录
- (void)insertReplyMessageIntoMessageModelWithInfo:(YFBAutoReplyMessage *)replyMessage {
    YFBMessageModel *msgModel = [[YFBMessageModel alloc] init];
    msgModel.sendUserId = replyMessage.userId;
    msgModel.receiveUserId = [YFBUser currentUser].userId;
    msgModel.messageTime = replyMessage.replyTime;
    msgModel.messageType = replyMessage.msgType;
    msgModel.content = replyMessage.content;
    msgModel.fileUrl = replyMessage.imgUrl;
    msgModel.nickName = replyMessage.nickName;

    if (replyMessage.msgType == YFBMessageTypeVoice) {
        msgModel.fileUrl = [NSString stringWithFormat:@"%ld",(long)ceilf([YFBUtil getVideoLengthWithVideoUrl:[NSURL URLWithString:replyMessage.content]])];
    }  else if (replyMessage.msgType == YFBMessageTypeFaceTime) {
        msgModel.content = [NSString stringWithFormat:@"%@邀请您视频聊天",replyMessage.nickName];
    }
    
    [msgModel saveOrUpdate];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateMessageViewControllerNotification object:msgModel];
}

//向消息记录中插入一条最近消息
- (void)insertReplyMessageIntoContactModelWithInfo:(YFBAutoReplyMessage *)replyMessage {
    YFBContactModel *contact =  [YFBContactModel findFirstByCriteria:[NSString stringWithFormat:@"WHERE userId=\'%@\'",replyMessage.userId]];
    if (!contact) {
        contact = [[YFBContactModel alloc] init];
        contact.unreadMsgCount = 0;
    }
    contact.userId = replyMessage.userId;
    contact.portraitUrl = replyMessage.portraitUrl;
    contact.nickName = replyMessage.nickName;
    contact.messageTime = replyMessage.replyTime;
    contact.messageType = replyMessage.msgType;
    contact.messageContent = replyMessage.content;
    contact.isOneline = YES;

    if (replyMessage.msgType == YFBMessageTypeFaceTime) {
        contact.messageContent = [NSString stringWithFormat:@"%@向您发送视频邀请",replyMessage.nickName];
    }
    
    contact.unreadMsgCount += 1;
    [contact saveOrUpdate];
    
    //如果推送消息的时候是最近的10秒而不是历史消息 显示悬浮消息提醒
    if ([[NSDate date] timeIntervalSince1970] - replyMessage.replyTime<= 10) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kYFBFriendShowMessageNotification object:replyMessage];
    }
    
    //向消息界面发出通知更改角标数字
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateContactUnReadMessageNotification object:contact];

}
@end
