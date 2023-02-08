//
//  YFBPayConfigManager.h
//  YFBFriend
//
//  Created by Liang on 2017/5/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBPayConfigInfo : NSObject
@property (nonatomic) NSString *amountPrice;
@property (nonatomic) NSString *imgUrl;
@property (nonatomic) NSString *typeCode;
@end


@interface YFBPayConfigReponse : QBURLResponse
@property (nonatomic) NSArray <YFBPayConfigInfo *> *pciList;
@end



@interface YFBPayConfigDetailInfo : NSObject
@property (nonatomic) NSInteger amount;
@property (nonatomic) NSInteger price;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *popDesc;
@property (nonatomic) NSString *vipDesc;
@end


@interface YFBPayVipInfo : NSObject
@property (nonatomic) YFBPayConfigDetailInfo *firstInfo;
@property (nonatomic) YFBPayConfigDetailInfo *secondInfo;
@end


@interface YFBPayDiamondInfo : NSObject
@property (nonatomic) YFBPayConfigDetailInfo *firstInfo;
@property (nonatomic) YFBPayConfigDetailInfo *secondInfo;
@end


@interface YFBPayConfigManager : QBEncryptedURLRequest
@property (nonatomic) YFBPayVipInfo *vipInfo;
@property (nonatomic) YFBPayDiamondInfo *diamondInfo;
+ (instancetype)manager;
- (void)getPayConfig;


@end
