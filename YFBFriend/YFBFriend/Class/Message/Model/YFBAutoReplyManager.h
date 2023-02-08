//
//  YFBAutoReplyManager.h
//  YFBFriend
//
//  Created by Liang on 2017/5/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBAutoReplyMessage : JKDBModel
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *portraitUrl;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *imgUrl;
@property (nonatomic) NSInteger msgId;
@property (nonatomic) YFBMessageType msgType;
@property (nonatomic) NSTimeInterval replyTime;
@property (nonatomic) NSInteger age;
@property (nonatomic) NSInteger height;
@property (nonatomic) NSString *gender;
@property (nonatomic) BOOL replyed;
@end

@interface YFBRobotMsgModel : NSObject
@property (nonatomic) NSString *content;
@property (nonatomic) NSInteger msgId;
@property (nonatomic) YFBMessageType msgType;
@property (nonatomic) NSString *sendTime;
@property (nonatomic) NSString * imgUrl;
@end

@interface YFBRobotContactModel : NSObject
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *portraitUrl;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSInteger age;
@property (nonatomic) NSInteger height;
@property (nonatomic) NSString *gender;
@property (nonatomic) NSArray <YFBRobotMsgModel *> *robotMsgList;
@end

@interface YFBAutoReplyResponse : QBURLResponse
@property (nonatomic) NSArray <YFBRobotContactModel *> *userList;
@property (nonatomic) NSInteger visitMeCount;

@property (nonatomic) YFBRobotContactModel *userLoginInfo;
@end


@interface YFBAutoReplyManager : QBEncryptedURLRequest
@property (nonatomic) NSMutableArray <YFBAutoReplyMessage *> *allReplyMsgs;
@property (nonatomic) BOOL canReplyNotificationMessage;

+ (instancetype)manager;

- (void)deleteYesterdayMessages;

- (void)getRobotReplyMessages;

- (void)getAutoReplyMessageWithUserId:(NSString *)userId;

- (void)insertAutoReplyMessageWithUserIs:(NSString *)userId MessageContent:(NSString *)messageContent;

- (void)getRandomReplyMessage;

- (void)saveRobotMessagesWith:(NSArray <YFBRobotContactModel *>*)userList;

- (void)startAutoRollingToReply;

@end
