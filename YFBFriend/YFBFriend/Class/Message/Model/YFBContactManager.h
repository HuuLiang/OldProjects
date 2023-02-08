//
//  YFBContactManager.h
//  YFBFriend
//
//  Created by Liang on 2017/5/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFBContactModel : JKDBModel
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *portraitUrl;
@property (nonatomic) NSInteger messageTime;
@property (nonatomic) NSString *messageContent;
@property (nonatomic) NSInteger unreadMsgCount;
@property (nonatomic) YFBMessageType messageType;
@property (nonatomic) BOOL isOneline;
@end

@interface YFBContactManager : NSObject

+ (instancetype)manager;

- (NSArray <YFBContactModel *> *)loadAllContactInfo;

- (YFBContactModel *)findContactInfoWithUserId:(NSString *)userId;

- (void)deleteAllPreviouslyContactInfo;

- (NSInteger)allUnReadMessageCount;

@end
