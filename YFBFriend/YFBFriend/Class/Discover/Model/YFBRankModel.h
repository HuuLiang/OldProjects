//
//  YFBRankModel.h
//  YFBFriend
//
//  Created by Liang on 2017/4/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
@class YFBRobot;


@interface YFBRankFentYunListModel : NSObject
@property (nonatomic) NSInteger pageCount;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger recvGiftCount;
@property (nonatomic) NSInteger sendGiftCount;
@property (nonatomic) NSArray <YFBRobot *>*userList;
@end

@interface YFBRankResponse : QBURLResponse
@property (nonatomic) YFBRankFentYunListModel *fengYunListDto;
@end

@interface YFBRankModel : QBEncryptedURLRequest
- (BOOL)fetchRankListInfoWithType:(NSString *)type pageNum:(NSInteger)pageNum CompletionHandler:(QBCompletionHandler)handler;
@end

extern NSString *const kYFBFriendRankReceiveCountKeyName;
extern NSString *const kYFBFriendRankSendCountKeyName;
