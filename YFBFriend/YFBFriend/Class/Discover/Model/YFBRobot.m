//
//  YFBRobot.m
//  YFBFriend
//
//  Created by Liang on 2017/3/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBRobot.h"

@implementation YFBRobot

+ (BOOL)checkUserIsGreetedWithUserId:(NSString *)userId {
    YFBRobot *robot = [self findFirstByCriteria:[NSString stringWithFormat:@"WHERE userId=\'%@\'",userId]];
    if (!robot) {
        return NO;
    }
    if (robot) {
        return robot.greeted;
    }
    return NO;
}

@end
