//
//  YFBAttentionListModel.h
//  YFBFriend
//
//  Created by Liang on 2017/4/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBAttentionInfo : NSObject
@property (nonatomic) NSInteger age;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *portraitUrl;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSInteger photoCount;
@end

@interface YFBAttentionListResponse : QBURLResponse
@property (nonatomic) NSArray <YFBAttentionInfo *> * userList;
@end

@interface YFBAttentionListModel : QBEncryptedURLRequest

- (BOOL)fetchAttentionListWithType:(NSString *)type CompletionHandler:(QBCompletionHandler)handler;

@end

extern NSString *const kYFBAttentionListConcernKeyName;
extern NSString *const kYFBAttentionListConcernedKeyName;
