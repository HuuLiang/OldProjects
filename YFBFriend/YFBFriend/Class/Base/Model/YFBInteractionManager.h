//
//  YFBInteractionManager.h
//  YFBFriend
//
//  Created by Liang on 2017/4/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
@class YFBRobot;
@class YFBMessageModel;

@interface YFBInteractionResponse : QBURLResponse
@property (nonatomic) NSString *contact;
@end

@interface YFBInteractionManager : QBEncryptedURLRequest

+ (instancetype)manager;

- (void)greetWithUserInfoList:(NSArray <YFBRobot *> *)userList toAllUsers:(BOOL)toAll handler:(void(^)(BOOL success))handler;

- (void)concernUserWithUserId:(NSString *)userId handler:(void(^)(BOOL success))handler;

- (void)cancleConcernUserWithUserId:(NSString *)userId handler:(void(^)(BOOL success))handler;

- (void)sendAdviceWithContent:(NSString *)content Contact:(NSString *)contact handler:(void(^)(BOOL success))handler;

//- (void)sendMessageInfoToUserId:(NSString *)userId content:(NSString *)content type:(NSInteger)messageType handler:(void(^)(BOOL success))handler;
- (void)sendMessageInfoToUserId:(NSString *)userId content:(NSString *)content type:(NSInteger)messageType deductDiamonds:(NSInteger)deductDiamonds handler:(void(^)(BOOL success))handler;

- (void)referUserContactWithType:(NSString *)type toUserId:(NSString *)userId handler:(void(^)(BOOL success,NSString *contact))handler;

extern NSString *const kYFBFriendReferContactQQKeyName;
extern NSString *const kYFBFriendReferContactWXKeyName;
extern NSString *const kYFBFriendReferContactPhoneKeyName;

@end
