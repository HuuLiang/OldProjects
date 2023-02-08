//
//  JYContactModel.h
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JKDBModel.h"

//@class JYUserGreetModel;
//@class JYReplyRobot;
@class JYCharacter;

typedef NS_ENUM(NSUInteger, JYContactUserType) {
    JYContactUserTypeNormal,//普通用户
    JYContactUserTypeSystem, //系统消息
    JYContactUserTypeCount
};

@interface JYContactModel : JKDBModel
//用户id
@property (nonatomic) NSString *userId;
//用户头像
@property (nonatomic) NSString *logoUrl;
//用户昵称
@property (nonatomic) NSString *nickName;
//用户类型
@property (nonatomic) JYContactUserType userType;
//最新消息内容
@property (nonatomic) NSString *recentMessage;
//最新消息时间
@property (nonatomic) NSInteger recentTime;
//未读消息条数
@property (nonatomic) NSInteger unreadMessages;
//是否置顶
@property (nonatomic) BOOL isStick;
//是否已经打过招呼
@property (nonatomic) BOOL alreadyGreet;

//获取缓存消息
+ (NSArray<JYContactModel *> *)allContacts;
//根据userId查询最近的一条消息记录
+ (JYContactModel *)findContactInfoWithUserId:(NSString *)userId;

//清空所有数据
+ (void)deleteAllContacts;
//插入一组用户主动打招呼的数据
+ (void)insertGreetContact:(NSArray <JYCharacter *>*)usersList;

//删除某一条数据
//+ (void)deleteOneContactWith:(JYContactModel *)contact;

//+ (instancetype)contactWithUser:(YPBUser *)user;
//+ (instancetype)contactWithPushedMessage:(YPBPushedMessage *)message;
//+ (instancetype)existingContactWithUserId:(NSString *)userId;
//+ (BOOL)refreshContactRecentTimeWithUser:(YPBUser *)user;

@end
