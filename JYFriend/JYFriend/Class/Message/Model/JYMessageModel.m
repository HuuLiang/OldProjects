//
//  JYMessageModel.m
//  JYFriend
//
//  Created by Liang on 2016/12/27.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMessageModel.h"

@implementation JYMessageModel
+ (NSArray<JYMessageModel *> *)allMessagesForUser:(NSString *)userId {
    return [self findByCriteria:[NSString stringWithFormat:@"WHERE sendUserId=%@ or receiveUserId=%@",userId,userId]];
}

@end

@implementation JYUserFirstMessage

+ (BOOL)isFirstMessageWithUserId:(NSString *)userId msgTime:(NSString *)time {
    JYUserFirstMessage *firstMsg = [self findFirstByCriteria:[NSString stringWithFormat:@"WHERE userId=%@",userId]];
    if (!firstMsg) {
        firstMsg = [[JYUserFirstMessage alloc] init];
        firstMsg.userId = userId;
        firstMsg.time = time;
        [firstMsg saveOrUpdate];
        return YES;
    }
    //判断数据库里保存的这个用户的信息时间是否是今天
    //是今天 不是第一条信息 返回否  不是今天 返回是 是今天第一条信息
    NSDate *date = [JYUtil dateFromString:firstMsg.time WithDateFormat:KDateFormatLong];
    if ([date isToday]) {
        return NO;
    } else {
        firstMsg.time = time;
        [firstMsg saveOrUpdate];
        return YES;
    }
}

@end
