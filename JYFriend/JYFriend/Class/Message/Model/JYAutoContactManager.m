//
//  JYAutoContactManager.m
//  JYFriend
//
//  Created by Liang on 2017/1/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYAutoContactManager.h"
#import "JYContactModel.h"
#import "JYMessageModel.h"
#import "JYUserCreateMessageModel.h"

static const NSUInteger kRollingTimeInterval = 5;

@implementation JYAutoReplyMessageModel

@end


@interface JYAutoContactManager ()
@property (nonatomic,retain) dispatch_queue_t replyQueue;
@end

@implementation JYAutoContactManager

+ (instancetype)manager {
    static JYAutoContactManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JYAutoContactManager alloc] init];
    });
    return _instance;
}

//把机器人的每条回复保存起来
- (void)saveReplyRobots:(NSArray <JYReplyRobot *> *)replyRobots {
    [replyRobots enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(JYReplyRobot * _Nonnull replyRobot, NSUInteger idx, BOOL * _Nonnull stop) {
        //每个机器人设定初始化回复时间
        __block NSTimeInterval timeInterval = [[JYUtil currentDate] timeIntervalSince1970];
        [replyRobot.dialogMsgs enumerateObjectsUsingBlock:^(JYRobotReplyMsgs * _Nonnull replyMsg, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                timeInterval = random() % 10 + 5 + timeInterval;//随机5到15秒
            } else  {
                timeInterval = random() % 240 + 60 + timeInterval;//随机1到5分钟
            }
            JYAutoReplyMessageModel * message = [JYAutoReplyMessageModel findFirstByCriteria:[NSString stringWithFormat:@"WHERE msgId=%@",replyMsg.msgId]];
            if (!message) {
                message = [[JYAutoReplyMessageModel alloc] init];
                message.userId = replyRobot.userId;
                message.nickName = replyRobot.nickName;
                message.logoUrl = replyRobot.logoUrl;
                message.msgId   = replyMsg.msgId;
                message.msg    = replyMsg.msg;
                message.msgType = replyMsg.msgType;
                message.replyTime = timeInterval;
                [message saveOrUpdate];
            } else {
                return;
            }
        }];
    }];
    //开启自动回复
    [self startAutoReplayMessages];
}

//获取所有的自动回复信息
- (NSArray <JYAutoReplyMessageModel *>*)findAllAutoReplyMessages {
    NSArray *array = [JYAutoReplyMessageModel findByCriteria:[NSString stringWithFormat:@"order by replyTime asc"]];
    if (array.count > 0) {
        return array;
    }
    return nil;
}

- (void)startAutoReplayMessages {
    if (self.replyQueue) {
        return;
    }
    self.replyQueue = dispatch_queue_create("JYFrient.AutoReply.Queue", nil);
    [self rollingReplayMessages];
}

- (void)rollingReplayMessages {
    dispatch_async(self.replyQueue, ^{
        
        __block uint nextRollingReplyTime = kRollingTimeInterval;
        
        NSArray *array = [self findAllAutoReplyMessages];
        
        
        [array enumerateObjectsUsingBlock:^(JYAutoReplyMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSTimeInterval currentTimeInterval = [[JYUtil currentDate] timeIntervalSince1970];
            if (obj.replyTime <= currentTimeInterval) {
                //向聊天详情中插入一条记录
                JYMessageModel *msgModel = [[JYMessageModel alloc] init];
                msgModel.sendUserId = obj.userId;
                msgModel.receiveUserId = [JYUser currentUser].userId;
                msgModel.messageTime = [JYUtil timeStringFromDate:[NSDate dateWithTimeIntervalSince1970:obj.replyTime] WithDateFormat:KDateFormatLong];
                msgModel.messageType = [obj.msgType integerValue];
                msgModel.messageContent = obj.msg;
                [msgModel saveOrUpdate];
                //向消息记录中插入一条最近消息
                JYContactModel *contact =  [JYContactModel findFirstByCriteria:[NSString stringWithFormat:@"WHERE userId=%@",obj.userId]];
                if (!contact) {
                    contact = [[JYContactModel alloc] init];
                    contact.userType = JYContactUserTypeNormal;
                    contact.userId = obj.userId;
                    contact.logoUrl = obj.logoUrl;
                    contact.nickName = obj.nickName;
                }
                if ([obj.msgType integerValue] == JYMessageTypePhoto) {
                    obj.msg = [NSString stringWithFormat:@"%@向您发送了一张图片",obj.nickName];
                }
                contact.recentMessage = obj.msg;
                contact.recentTime = [[JYUtil currentDate] timeIntervalSince1970];
                contact.unreadMessages += 1;
                [contact saveOrUpdate];
                //删除已经回复过的缓存
                [obj deleteObject];
                //向消息界面发出通知更改角标数字
                [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateContactUnReadMessageNotification object:obj];
            } else {
                NSTimeInterval nextTime = obj.replyTime - [[JYUtil currentDate] timeIntervalSince1970];
                if (nextTime < nextRollingReplyTime) {
                    nextRollingReplyTime = nextTime;
                }
                QBLog(@"下次循环推送时间 %d",nextRollingReplyTime);
            }
            
        }];
        
        QBLog(@"回复池数量%ld 下次循环推送时间 %d",array.count,nextRollingReplyTime);

        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            sleep(nextRollingReplyTime);
            [self rollingReplayMessages];
        });

    });
}


@end
