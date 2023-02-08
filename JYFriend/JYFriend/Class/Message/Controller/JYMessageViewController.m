//
//  JYMessageViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMessageViewController.h"
#import "JYMessageModel.h"
#import <AVFoundation/AVFoundation.h>
#import "JYMessageViewController+XHBMessageDelegate.h"
#import "JYUserCreateMessageModel.h"
#import "JYAutoContactManager.h"
#import "JYContactModel.h"


@interface JYMessageViewController ()
{
    BOOL currentUserSendingPhoto; //判断用户是否在发送图片决定是否重新加载数据
    BOOL shouldLoadVipNotice;     //判断是否需要加载称为vip的提示
}
@property (nonatomic,retain) NSMutableArray<JYMessageModel *> *chatMessages;
@property (nonatomic) JYSendMessageModel *sendMessageModel;
@end

@implementation JYMessageViewController
QBDefineLazyPropertyInitialization(NSMutableArray, chatMessages)
QBDefineLazyPropertyInitialization(NSArray, emotionManagers)
QBDefineLazyPropertyInitialization(JYSendMessageModel, sendMessageModel)

+ (instancetype)showMessageWithUser:(JYUser *)user inViewController:(UIViewController *)viewController {
    JYMessageViewController *messageVC = [[self alloc] initWithUser:user];
    [viewController.navigationController pushViewController:messageVC animated:YES];
    return messageVC;
}

- (instancetype)initWithUser:(JYUser *)user {
    self = [self init];
    if (self) {
        _user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messageTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.title = self.user.nickName;
    self.messageSender = [JYUser currentUser].userId;
    
    [self registerCustomCell];
    [self configEmotions];
    [self setXHShareMenu];
    [self setupPopMenuTitles];
    
    shouldLoadVipNotice = NO;
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(changeLoadVipNotice) name:kPaidNotificationName object:nil];
}

- (void)changeLoadVipNotice {
    shouldLoadVipNotice = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!currentUserSendingPhoto) {
        [self reloadChatMessages];
    } else {
        currentUserSendingPhoto = NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPaidNotificationName object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    JYMessageModel *lastMessage = [self.chatMessages lastObject];
    JYContactModel *contactModel = [JYContactModel findContactInfoWithUserId:self.user.userId];
    
    if (contactModel == nil) {
        contactModel = [[JYContactModel alloc] init];
        contactModel.logoUrl = self.user.userImgKey;
        contactModel.nickName = self.user.nickName;
        contactModel.userId = self.user.userId;
    }
    
    if (contactModel && lastMessage.messageType < JYMessageTypeNormal && lastMessage != nil) {
        if (![[JYUtil timeStringFromDate:[NSDate dateWithTimeIntervalSince1970:contactModel.recentTime] WithDateFormat:KDateFormatLong] isEqualToString:lastMessage.messageTime]) {
            //时间
            contactModel.recentTime = [[JYUtil dateFromString:lastMessage.messageTime WithDateFormat:KDateFormatLong] timeIntervalSince1970];
            //内容
            if (lastMessage.messageType == JYMessageTypeText) {
                contactModel.recentMessage = lastMessage.messageContent;
            } else if (lastMessage.messageType == JYMessageTypePhoto || lastMessage.messageType == JYMessageTypeEmotion) {
                contactModel.recentMessage = @"[图片表情]";
            } else if (lastMessage.messageType == JYMessageTypeVioce) {
                contactModel.recentMessage = @"[语音消息]";
            }
        }
    } else {
        contactModel.recentTime = [[JYUtil currentDate] timeIntervalSince1970];
    }
    contactModel.unreadMessages = 0;

    [contactModel saveOrUpdate];
}

- (void)reloadChatMessages {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.chatMessages = [JYMessageModel allMessagesForUser:self.user.userId].mutableCopy;
        [self.messages removeAllObjects];
        [self.chatMessages enumerateObjectsUsingBlock:^(JYMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XHMessage *message;
            NSDate *date = [JYUtil dateFromString:obj.messageTime WithDateFormat:KDateFormatLong];
            if (obj.messageType == JYMessageTypeText) {
                message = [[XHMessage alloc] initWithText:obj.messageContent
                                                   sender:obj.sendUserId
                                                timestamp:date];
                message.messageMediaType = XHBubbleMessageMediaTypeText;
            } else if (obj.messageType == JYMessageTypePhoto) {
                message = [[XHMessage alloc] initWithPhoto:obj.photokey.length > 0 ? [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:obj.photokey] : nil
                                              thumbnailUrl:obj.photokey.length > 0 ? nil : obj.messageContent
                                            originPhotoUrl:obj.photokey.length > 0 ? nil : obj.messageContent
                                                    sender:obj.sendUserId
                                                 timestamp:date];
            } else if (obj.messageType == JYMessageTypeVioce) {
                message = [[XHMessage alloc] initWithVoicePath:obj.messageContent
                                                      voiceUrl:nil
                                                 voiceDuration:obj.standbyContent
                                                        sender:obj.sendUserId
                                                     timestamp:date];
            } else if (obj.messageType == JYMessageTypeEmotion) {
                message = [[XHMessage alloc] initWithEmotionPath:obj.messageContent
                                                          sender:obj.sendUserId
                                                       timestamp:date];
            } else if (obj.messageType >= JYMessageTypeNormal) {
                message = [[XHMessage alloc] initWithText:obj.messageContent
                                                   sender:obj.sendUserId
                                                timestamp:date];
                message.messageMediaType = XHBubbleMessageMediaTypeCustom;
            }
            
            if ([obj.sendUserId isEqualToString:[JYUser currentUser].userId]) {
                message.bubbleMessageType = XHBubbleMessageTypeSending;
            } else {
                message.bubbleMessageType = XHBubbleMessageTypeReceiving;
            }
            [self.messages addObject:message];
        }];
        
        if (shouldLoadVipNotice) {
            JYMessageModel *vipMessage = [[JYMessageModel alloc] init];
            vipMessage.messageTime = [JYUtil timeStringFromDate:[JYUtil currentDate] WithDateFormat:KDateFormatLong];
            vipMessage.messageType = JYMessageTypeVIP;
            vipMessage.messageContent = [NSString stringWithFormat:@"恭喜你！你已经成为VIP会员。会员有效期至%@",[JYUtil timeStringFromDate:[JYUtil expireDateTime] WithDateFormat:kDateFormatChina]];
            vipMessage.receiveUserId = [JYUser currentUser].userId;
            vipMessage.sendUserId = self.user.userId;
            
            XHMessage *message = [[XHMessage alloc] initWithText:vipMessage.messageContent sender:vipMessage.sendUserId timestamp:[JYUtil currentDate]];
            message.messageMediaType = XHBubbleMessageMediaTypeCustomVIP;
            [self.messages addObject:message];
            
            shouldLoadVipNotice = NO;
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.messageTableView reloadData];
            [self scrollToBottomAnimated:NO];
        });
    });
    

    
}


//增加一条文本信息
- (void)addTextMessage:(NSString *)message
            withSender:(NSString *)sender
              receiver:(NSString *)receiver
              dateTime:(NSString *)dateTime
{
    JYMessageModel *chatMessage = [[JYMessageModel alloc] init];
    chatMessage.sendUserId = sender;
    chatMessage.receiveUserId = receiver;
    chatMessage.messageTime = dateTime;
    chatMessage.messageType = JYMessageTypeText;
    chatMessage.messageContent = message;
    
    [self addChatMessage:chatMessage];
}

//增加一条图片信息
- (void)addPhotoMessage:(NSString *)imagekey
           thumbnailUrl:(NSString *)thumbnailUrl
         originPhotoUrl:(NSString *)originPhotoUrl
             withSender:(NSString *)sender
               receiver:(NSString *)receiver
               dateTime:(NSString *)dateTime {
    JYMessageModel *chatMessage = [[JYMessageModel alloc] init];
    chatMessage.sendUserId = sender;
    chatMessage.receiveUserId = receiver;
    chatMessage.messageTime = dateTime;
    chatMessage.messageType = JYMessageTypePhoto;
    chatMessage.photokey = imagekey;
    chatMessage.messageContent = thumbnailUrl;
    chatMessage.standbyContent = originPhotoUrl;
    
    currentUserSendingPhoto = YES;
    
    [self addChatMessage:chatMessage];
}

//增加一条音频信息
- (void)addVoiceMessage:(NSString *)voicePath
          voiceDuration:(NSString *)voiceDuration
             withSender:(NSString *)sender
               receiver:(NSString *)receiver
               dateTime:(NSString *)dateTime {
    JYMessageModel *chatMessage = [[JYMessageModel alloc] init];
    chatMessage.sendUserId = sender;
    chatMessage.receiveUserId = receiver;
    chatMessage.messageTime = dateTime;
    chatMessage.messageType = JYMessageTypeVioce;
    chatMessage.messageContent = voicePath;
    chatMessage.standbyContent = voiceDuration;
    
    [self addChatMessage:chatMessage];
}

//增加一个表情
- (void)addEmotionMessage:(NSString *)emotionPath
               WithSender:(NSString *)sender
                 receiver:(NSString *)receiver
                 dateTime:(NSString *)dateTime {
    JYMessageModel *chatMessage = [[JYMessageModel alloc] init];
    chatMessage.sendUserId = sender;
    chatMessage.receiveUserId = receiver;
    chatMessage.messageTime = dateTime;
    chatMessage.messageType = JYMessageTypeEmotion;
    chatMessage.messageContent = emotionPath;
    
    [self addChatMessage:chatMessage];
}

//加入信息到数据源
- (void)addChatMessage:(JYMessageModel *)chatMessage {
    
    if (![JYUtil isVip]) {
        //判断是不是VIP 不是vip 判断是不是今天的第一条 是 发送  不是 发送VIP提示
        if ([self isFirstMessageEveryDayWith:chatMessage] && (chatMessage.messageType == JYMessageTypeText || chatMessage.messageType == JYMessageTypeEmotion)) {
            [self sendMessageToServerWithInfo:chatMessage];
        } else {
            chatMessage.messageContent = @"对方是VIP，您无法给TA发送信息。点击开通VIP，与TA畅聊。";
            chatMessage.messageType = JYMessageTypeNormal;
        }
    } else {
        [self sendMessageToServerWithInfo:chatMessage]; 
    }
    
    [self.chatMessages addObject:chatMessage];
    
    if (chatMessage.messageType < JYMessageTypeNormal) {
        [chatMessage saveOrUpdate];
    }
    
    if (self.isViewLoaded) {
        XHMessage *xhMsg;
        NSDate *date = [JYUtil dateFromString:chatMessage.messageTime WithDateFormat:KDateFormatLong];
        if (chatMessage.messageType == JYMessageTypeText) {
            xhMsg = [[XHMessage alloc] initWithText:chatMessage.messageContent
                                             sender:chatMessage.sendUserId
                                          timestamp:date];
        } else if (chatMessage.messageType == JYMessageTypePhoto) {
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:chatMessage.photokey];
            
            xhMsg = [[XHMessage alloc] initWithPhoto:image
                                        thumbnailUrl:chatMessage.messageContent
                                      originPhotoUrl:chatMessage.standbyContent
                                              sender:chatMessage.sendUserId
                                           timestamp:date];
        } else if (chatMessage.messageType == JYMessageTypeVioce) {
            xhMsg = [[XHMessage alloc] initWithVoicePath:chatMessage.messageContent
                                                voiceUrl:nil
                                           voiceDuration:chatMessage.standbyContent
                                                  sender:chatMessage.sendUserId
                                               timestamp:date isRead:NO];
        } else if (chatMessage.messageType == JYMessageTypeEmotion) {
            xhMsg = [[XHMessage alloc] initWithEmotionPath:chatMessage.messageContent
                                                    sender:chatMessage.sendUserId
                                                 timestamp:date];
        } else if (chatMessage.messageType >= JYMessageTypeNormal) {
            xhMsg = [[XHMessage alloc] initWithText:chatMessage.messageContent
                                             sender:chatMessage.sendUserId
                                          timestamp:date];
            //2种数据模型枚举匹配
            xhMsg.messageMediaType = JYMessageTypeNormal + 2;
        }
        
        if ([chatMessage.sendUserId isEqualToString:[JYUser currentUser].userId]) {
            xhMsg.bubbleMessageType = XHBubbleMessageTypeSending;
        } else {
            xhMsg.bubbleMessageType = XHBubbleMessageTypeReceiving;
        }
        [self addMessage:xhMsg];
    }
}

- (void)deleteMessageAtIndexPath:(NSIndexPath *)indexPath {
    JYMessageModel *messageModel = self.chatMessages[indexPath.row];
//    if ([messageModel.sendUserId isEqualToString:[JYUser currentUser].userId]) {
        [messageModel deleteObject];
        [self.chatMessages removeObjectAtIndex:indexPath.row];
        [self.messages removeObjectAtIndex:indexPath.row];
        
        [self.messageTableView beginUpdates];
        [self.messageTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.messageTableView endUpdates];
//    }
}

//向服务器发送消息
- (void)sendMessageToServerWithInfo:(JYMessageModel *)chatMessage {
    NSString *msg = nil;
    NSString *contentType = nil;
    if (chatMessage.messageType == JYMessageTypeText) {
        msg = chatMessage.messageContent;
        contentType = @"TEXT";
    } else if (chatMessage.messageType == JYMessageTypePhoto) {
        msg = [[SDImageCache sharedImageCache] defaultCachePathForKey:chatMessage.photokey];
        contentType = @"IMG";
    } else if (chatMessage.messageType == JYMessageTypeVioce) {
        msg = chatMessage.messageContent;
        contentType = @"VOICE";
    } else if (chatMessage.messageType == JYMessageTypeEmotion) {
        msg = chatMessage.messageContent;
        contentType = @"IMG";
    }
    
    [self.sendMessageModel fetchRebotReplyMessagesWithRobotId:self.user.userId
                                                          msg:msg
                                                  ContentType:contentType
                                                      msgType:JYUserCreateMessageTypeChat
                                            CompletionHandler:^(BOOL success, id obj)
     {
         if (success) {
             [[JYAutoContactManager manager] saveReplyRobots:obj];
         }
     }];
}

- (BOOL)isFirstMessageEveryDayWith:(JYMessageModel *)message {
    return [JYUserFirstMessage isFirstMessageWithUserId:message.receiveUserId msgTime:message.messageTime];
}

@end
