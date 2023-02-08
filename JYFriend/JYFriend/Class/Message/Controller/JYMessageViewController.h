//
//  JYMessageViewController.h
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "XHMessageTableViewController.h"

@class JYMessageModel;

@interface JYMessageViewController : XHMessageTableViewController

@property (nonatomic,retain,readonly) JYUser *user;
@property (nonatomic,retain) NSArray *emotionManagers;
@property (nonatomic, strong) XHMessageTableViewCell *currentSelectedCell;


+ (instancetype)showMessageWithUser:(JYUser *)user inViewController:(UIViewController *)viewController;

- (void)addTextMessage:(NSString *)message
            withSender:(NSString *)sender
              receiver:(NSString *)receiver
              dateTime:(NSString *)dateTime;

- (void)addPhotoMessage:(NSString *)imagekey
           thumbnailUrl:(NSString *)thumbnailUrl
         originPhotoUrl:(NSString *)originPhotoUrl
             withSender:(NSString *)sender
               receiver:(NSString *)receiver
               dateTime:(NSString *)dateTime;

- (void)addVoiceMessage:(NSString *)voicePath
          voiceDuration:(NSString *)voiceDuration
             withSender:(NSString *)sender
               receiver:(NSString *)receiver
               dateTime:(NSString *)dateTime;

- (void)addEmotionMessage:(NSString *)emotionPath
               WithSender:(NSString *)sender
                 receiver:(NSString *)receiver
                 dateTime:(NSString *)dateTime;

- (void)addChatMessage:(JYMessageModel *)chatMessage;

- (void)deleteMessageAtIndexPath:(NSIndexPath *)indexPath;

//extern NSString *const kJYFriendMessageNormalCellKeyName;
//extern NSString *const kJYFriendMessageVipCellKeyName;

@end
