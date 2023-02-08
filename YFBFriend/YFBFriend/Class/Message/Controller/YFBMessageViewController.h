//
//  YFBMessageViewController.h
//  YFBFriend
//
//  Created by Liang on 2017/4/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "XHMessageTableViewController.h"
@class YFBMessageModel;
@class YFBContactUserModel;
@class AVPlayer;
@interface YFBMessageViewController : XHMessageTableViewController

//@property (nonatomic,retain,readonly) YFBContactUserModel *user;
@property (nonatomic,copy,readonly) NSString *userId;
@property (nonatomic,copy,readonly) NSString *nickName;
@property (nonatomic,copy,readonly) NSString *avatarUrl;
@property (nonatomic, strong) XHMessageTableViewCell *currentSelectedCell;
@property (nonatomic) AVPlayer *player;

//+ (instancetype)showMessageWithUser:(YFBContactUserModel *)user inViewController:(UIViewController *)viewController;

+ (instancetype)showMessageWithUserId:(NSString *)userId nickName:(NSString *)nickName avatarUrl:(NSString *)avatarUrl inViewController:(UIViewController *)viewController;

+ (instancetype)presentMessageWithUserId:(NSString *)userId
                                nickName:(NSString *)nickName
                               avatarUrl:(NSString *)avatarUrl
                        inViewController:(UIViewController *)viewController;

- (void)addTextMessage:(NSString *)message
            withSender:(NSString *)sender
              receiver:(NSString *)receiver
              dateTime:(NSInteger)dateTime;

- (void)addVoiceMessage:(NSString *)voicePath
          voiceDuration:(NSString *)voiceDuration
             withSender:(NSString *)sender
               receiver:(NSString *)receiver
               dateTime:(NSInteger)dateTime;

- (void)addChatMessage:(YFBMessageModel *)chatMessage;


@end
