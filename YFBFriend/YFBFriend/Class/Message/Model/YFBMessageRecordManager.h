//
//  YFBMessageRecordManager.h
//  YFBFriend
//
//  Created by Liang on 2017/5/2.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YFBMessageModel;

typedef NS_ENUM(NSInteger,YFBMessageRecordType)  {
    YFBMessageRecordTypeUnknow = 0,//未知消息记录类型
    YFBMessageRecordTypeAllowFree = 1,//允许免费发送消息
    YFBMessageRecordTypeAllowDiamond = 2,//允许钻石发送
    YFBMessageRecordTypeAllowVip = 3,//允许vip发送
    YFBMessageRecordTypeBuyDiamond = 4,//提示购买钻石套餐
    YFBMessageRecordTypeBuyVip = 5 //提示购买VIP套餐
};

@interface YFBMessageRecordModel : JKDBModel
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *messageTime;
@property (nonatomic) YFBMessageRecordType type;
@end

@interface YFBMessageRecordManager : NSObject

+ (instancetype)manager;

- (void)deleteYesterdayRecordMessages;

- (YFBMessageRecordType)checkMessageRecordWithChatMessages:(NSArray <YFBMessageModel *>*)chatMessages thisMessage:(YFBMessageModel *)messageModel;

@end
