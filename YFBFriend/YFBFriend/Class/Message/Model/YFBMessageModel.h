//
//  YFBMessageModel.h
//  YFBFriend
//
//  Created by Liang on 2017/4/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFBMessageModel : JKDBModel
@property (nonatomic) NSString *fileUrl;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *sendUserId;
@property (nonatomic) NSString *receiveUserId;
@property (nonatomic) NSInteger messageTime;
@property (nonatomic) NSString *nickName;
@property (nonatomic) YFBMessageType messageType;
@property (nonatomic) BOOL readDone;

+ (NSArray <YFBMessageModel *>*)allMessagesWithUserId:(NSString *)userId;
+ (void)deleteAllPreviouslyMessages;
@end
