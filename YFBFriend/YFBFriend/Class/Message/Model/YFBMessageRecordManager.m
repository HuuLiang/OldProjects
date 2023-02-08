//
//  YFBMessageRecordManager.m
//  YFBFriend
//
//  Created by Liang on 2017/5/2.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessageRecordManager.h"
#import "YFBMessageModel.h"

#define VipDiamondCount         1       //vip用户发送消息消耗的钻石数量
#define NormalDiamondCount      80      //非vip用户发送消息消耗的钻石数量
#define FirstDayReplyCount      1       //首日回复人数数量
#define OtherDayReplyCount      1       //非首日回复人数数量


@implementation YFBMessageRecordModel



@end


@implementation YFBMessageRecordManager

+ (instancetype)manager {
    static YFBMessageRecordManager *_messageRecordManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _messageRecordManager = [[YFBMessageRecordManager alloc] init];
    });
    return _messageRecordManager;
}

- (void)deleteYesterdayRecordMessages {
    //删除数据库中不是今天的数据
    if (![YFBUtil isFirstDay]) {
        [YFBMessageRecordModel deleteObjectsByCriteria:[NSString stringWithFormat:@"where messageTime!=\'%@\'",[YFBUtil timeStringFromDate:[NSDate date] WithDateFormat:KDateFormatShortest]]];
    }
}

- (YFBMessageRecordType)checkMessageRecordWithChatMessages:(NSArray <YFBMessageModel *>*)chatMessages thisMessage:(YFBMessageModel *)messageModel {
    
    //如果是vip  检测钻石是否充足
    YFBMessageRecordType recordType;
    
    if ([YFBUtil isVip]) {
        BOOL enoughDiamond = [self checkUserDiamondWithCount:VipDiamondCount];
        if (enoughDiamond) {
            recordType = YFBMessageRecordTypeAllowVip;
        } else {
            recordType = YFBMessageRecordTypeBuyDiamond;
        }
    } else {
        //如果不是vip
        recordType = [self checkUserReplyMessageCountWithMessageInfo:messageModel];
    }
    
    return recordType;
}

//检测钻石是否足够
//充足则允许 否则提示购买钻石
- (BOOL)checkUserDiamondWithCount:(NSInteger)diamondCount {
    if ([YFBUser currentUser].diamondCount >= diamondCount) {
        return YES;
    } else {
        return NO;
    }
}

//检测今天是否能够继续发送消息
- (YFBMessageRecordType)checkUserReplyMessageCountWithMessageInfo:(YFBMessageModel *)messageModel {
    YFBMessageRecordType messageRecordType;
    
    NSString *todayStr = [YFBUtil timeStringFromDate:[NSDate date] WithDateFormat:@"yyyyMMdd"];
    
    //检测今天是否还能够对这个机器人发送免费或者钻石消息
    NSArray *todayMessages = [YFBMessageRecordModel findByCriteria:[NSString stringWithFormat:@"where userId=\'%@\'",messageModel.receiveUserId]];
    
    
    if (todayMessages.count == 0) {
        //未发送过消息 检测是否能够发送免费消息
        BOOL canSendFreeMessage = [self checkUserCanSendMessageWithTimeStr:todayStr recordType:YFBMessageRecordTypeAllowFree];
        if (canSendFreeMessage) {
            messageRecordType = YFBMessageRecordTypeAllowFree;
        } else {
            BOOL canSendDiamondMessage = [self checkUserCanSendMessageWithTimeStr:todayStr recordType:YFBMessageRecordTypeAllowDiamond];
            if (canSendDiamondMessage) {
                BOOL enoughDiamond = [self checkUserDiamondWithCount:NormalDiamondCount];
                if (enoughDiamond) {
                    messageRecordType = YFBMessageRecordTypeAllowDiamond;
                } else {
                    messageRecordType = YFBMessageRecordTypeBuyDiamond;
                }
            } else {
                messageRecordType= YFBMessageRecordTypeBuyVip;
            }
        }
    } else if (todayMessages.count == 1) {
        //发送过一条消息 检测这条消息的类型 如果是免费的 则看是否能够发送钻石消息  //如果是钻石的 则不能够继续发送
        YFBMessageRecordModel * messageRecord = [todayMessages firstObject];
        if (messageRecord.type == YFBMessageRecordTypeAllowFree) {
            BOOL canSendDiamondMessage = [self checkUserCanSendMessageWithTimeStr:todayStr recordType:YFBMessageRecordTypeAllowDiamond];
            if (canSendDiamondMessage) {
                BOOL enoughDiamond = [self checkUserDiamondWithCount:NormalDiamondCount];
                if (enoughDiamond) {
                    messageRecordType = YFBMessageRecordTypeAllowDiamond;
                } else {
                    messageRecordType = YFBMessageRecordTypeBuyDiamond;
                }
            } else {
                messageRecordType = YFBMessageRecordTypeBuyVip;
            }
        } else if (messageRecord.type == YFBMessageRecordTypeAllowDiamond) {
            messageRecordType = YFBMessageRecordTypeBuyVip;
        } else {
            messageRecordType = YFBMessageRecordTypeUnknow;
        }
    } else {
        //都发送过了 需要付费购买VIP
        messageRecordType = YFBMessageRecordTypeBuyVip;
    }
    
    return messageRecordType;
}

- (BOOL)checkUserCanSendMessageWithTimeStr:(NSString *)timeStr recordType:(YFBMessageRecordType)recordType {
    //检测是否可以发送指定类型消息  先检测今天的指定类型消息总条数
    NSArray * freeMessageCount = [YFBMessageRecordModel findByCriteria:[NSString stringWithFormat:@"where messageTime=\'%@\' and type=%ld",timeStr,recordType]];
    
    NSInteger replyCount = 0;
    if ([YFBUtil isFirstDay]) {
        replyCount = FirstDayReplyCount;
    } else {
        replyCount = OtherDayReplyCount;
    }
    
    if (freeMessageCount.count >= replyCount) {
        //超出条数限制
        return NO;
    }
    return YES;
}

@end
