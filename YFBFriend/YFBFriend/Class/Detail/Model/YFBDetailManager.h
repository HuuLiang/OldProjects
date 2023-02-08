//
//  YFBDetailManager.h
//  YFBFriend
//
//  Created by Liang on 2017/4/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBUserBaseInfoModel : NSObject
@property (nonatomic) NSInteger age;
@property (nonatomic) NSString *birthday;
@property (nonatomic) NSString *city;
@property (nonatomic) NSInteger concernNum;
@property (nonatomic) NSString *constellation;
@property (nonatomic) NSString *datePlace;
@property (nonatomic) NSString *education;
@property (nonatomic) NSString *firstMeetHope;
@property (nonatomic) NSString *friendDestination;
@property (nonatomic) NSString *gender;
@property (nonatomic) NSInteger height;
@property (nonatomic) NSString *loveConcept;
@property (nonatomic) NSString *marriageStatus;
@property (nonatomic) NSString *mobilePhone;
@property (nonatomic) NSString *monthlyIncome;
@property (nonatomic) NSString *qq;
@property (nonatomic) NSString *vocation;
@property (nonatomic) NSInteger weight;
@property (nonatomic) NSString *weixin;
@property (nonatomic) NSString *personalizedSignature;
@property (nonatomic) NSInteger myDiamonds;
@property (nonatomic) NSString *vipExpireDate;
@end


@interface YFBUserLoginModel : NSObject
@property (nonatomic) NSString *distance;
@property (nonatomic) NSString *lastLoginTime;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *portraitUrl;
@property (nonatomic) NSString *userId;
@property (nonatomic) YFBUserBaseInfoModel *userBaseInfo;
@end

@interface YFBDetailResponse : QBURLResponse
@property (nonatomic) YFBUserLoginModel *userLoginInfo;
@end

@interface YFBDetailManager : QBEncryptedURLRequest

+ (instancetype)manager;

- (BOOL)fetchDetailInfoWithUserId:(NSString *)userId CompletionHandler:(QBCompletionHandler)handler;
@end
