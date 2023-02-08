//
//  YFBUser.h
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YFBUserSex) {
    YFBUsersexUnkown = 0,
    YFBUserSexMale,  //男性
    YFBUserSexFemale,    //女性
};

typedef NS_ENUM(NSInteger, YFBLoginType) {
    YFBLoginTypeDefine = 1, //自定义
    YFBLoginTypeQQ,  //qq
    YFBLoginTypeWX   //微信
};

typedef NS_ENUM(NSInteger,YFBUserMarriageStatus) {
    YFBUserfiance = 0, //未婚
    YFBUserMarried     //已婚
};

@interface YFBUser : JKDBModel <NSCoding>

+ (instancetype)currentUser;

//用户ID

@property (nonatomic,copy) NSString *userId;

@property (nonatomic,copy) NSString *token;

@property (nonatomic,copy) NSString *password;

@property (nonatomic,copy) NSString *loginName;

@property (nonatomic,copy) NSString *userImage;

//@property (nonatomic,copy) NSString *userPhotos;

@property (nonatomic,copy) NSString *signature;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic) YFBUserSex userSex;

@property (nonatomic) YFBLoginType loginType;

@property (nonatomic) NSInteger age;

@property (nonatomic,copy) NSString *liveCity;

@property (nonatomic) NSInteger height;

@property (nonatomic,copy) NSString *income;

@property (nonatomic) YFBUserMarriageStatus marriageStatus;

@property (nonatomic,copy) NSString *QQNumber;

@property (nonatomic,copy) NSString *WXNumber;

@property (nonatomic,copy) NSString *phoneNumber;

@property (nonatomic,copy) NSString *education;

@property (nonatomic,copy) NSString *job;

@property (nonatomic,copy) NSString *birthday;

@property (nonatomic,copy) NSString *weight;

@property (nonatomic,copy) NSString *star;

@property (nonatomic) NSInteger diamondCount;

@property (nonatomic) NSString *expireTime;

- (BOOL)saveOrUpdateUserInfo;

#pragma mark - 注册信息

+ (NSArray *)allUserSex;
+ (NSArray *)allUserAge;
+ (NSArray *)allUserWeight;
+ (NSArray *)allUserStars;

//职业
+ (NSArray *)allUserJob;
//学历
+ (NSArray *)allUserEdu;
//收入
+ (NSArray *)allUserIncome;
//身高
+ (NSArray *)allUserHeight;
//婚姻状况
+ (NSArray *)allUserMarr;

+ (NSMutableDictionary *)allProvincesAndCities;
+ (NSArray *)defaultHometown;
+ (NSArray *)allCitiesWihtProvince:(NSString *)province;

@end
