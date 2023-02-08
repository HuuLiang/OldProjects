//
//  JYAutoContactManager.h
//  JYFriend
//
//  Created by Liang on 2017/1/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JYContactModel;
@class JYMessageModel;
@class JYReplyRobot;

@interface JYAutoReplyMessageModel : JKDBModel
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *logoUrl;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *msgId;
@property (nonatomic) NSString *msg;
@property (nonatomic) NSString *msgType;
@property (nonatomic) NSInteger replyTime;
@end


@interface JYAutoContactManager : NSObject

+ (instancetype)manager;

- (void)saveReplyRobots:(NSArray <JYReplyRobot *> *)replyRobots;

- (NSArray <JYAutoReplyMessageModel *>*)findAllAutoReplyMessages;

- (void)startAutoReplayMessages;

@end
