//
//  YFBMyGiftModel.h
//  YFBFriend
//
//  Created by Liang on 2017/4/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBGift : NSObject
@property (nonatomic) NSString *giftUrl;
@property (nonatomic) NSString *giftId;
@property (nonatomic) NSNumber *diamondCount;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *recvOrSendTime;
@end

@interface YFBGiftListModel : NSObject
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *portraitUrl;
@property (nonatomic) NSArray <YFBGift *> *giftList;
@end


@interface YFBUserGift : QBURLResponse
@property (nonatomic,retain) NSArray <YFBGiftListModel *>*userGiftList;
@end

@interface YFBMyGiftModel : QBEncryptedURLRequest

- (void)fetchMyGiftModelWithType:(NSString *)typeString CompleteHandler:(QBCompletionHandler)handler;

@end
