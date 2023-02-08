//
//  JYMessageModel.h
//  JYFriend
//
//  Created by Liang on 2016/12/27.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JKDBModel.h"

typedef NS_ENUM(NSUInteger, JYMessageType) {
    JYMessageTypeText = 1,      //文字消息
    JYMessageTypePhoto = 2,     //图片消息
    JYMessageTypeVioce = 3,     //声音消息
    JYMessageTypeEmotion = 4,   //表情消息
    JYMessageTypeNormal = 5,    //未开通VIP
    JYMessageTypeVIP = 6,       //开通VIP
    JYMessageTypeCount
};

//XHBubbleMessageMediaTypeText = 0,
//XHBubbleMessageMediaTypePhoto = 1,
//XHBubbleMessageMediaTypeVideo = 2,
//XHBubbleMessageMediaTypeVoice = 3,
//XHBubbleMessageMediaTypeEmotion = 4,

@interface JYMessageModel : JKDBModel

@property (nonatomic) NSString *sendUserId;
@property (nonatomic) NSString *receiveUserId;
@property (nonatomic) NSString *messageTime;

@property (nonatomic) JYMessageType messageType;

@property (nonatomic) NSString *messageContent;

@property (nonatomic) NSString *photokey;
@property (nonatomic) NSString *standbyContent;
//@property (nonatomic) BOOL     isRead;


//@property (nonatomic) NSString *options;

//+ (instancetype)chatMessage;
+ (NSArray<JYMessageModel *> *)allMessagesForUser:(NSString *)userId;


//+ (instancetype)chatMessageFromPushedMessage:(YPBPushedMessage *)message;
@end

@interface JYUserFirstMessage : JKDBModel
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *time;

+ (BOOL)isFirstMessageWithUserId:(NSString *)userId msgTime:(NSString *)time;

@end

