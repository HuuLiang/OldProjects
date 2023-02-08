//
//  YFBGiftManager.h
//  YFBFriend
//
//  Created by Liang on 2017/4/19.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBGiftInfo : NSObject
@property (nonatomic) NSInteger diamondCount;
@property (nonatomic) NSString * giftId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *giftUrl;
@end

@interface YFBGiftResponse : QBURLResponse
@property (nonatomic) NSArray <YFBGiftInfo *> * giftList;
@end

@interface YFBGiftManager : QBEncryptedURLRequest

+ (instancetype)manager;

@property (nonatomic,readonly) NSArray <YFBGiftInfo *> *giftList;

- (void)getGiftListCache;

- (BOOL)fetchGiftListWithCompletionHandler:(QBCompletionHandler)handler;

//- (BOOL)sendGiftToUserId:(NSString *)userId giftId:(NSInteger)giftId handler:(QBCompletionHandler)handler;

@end
