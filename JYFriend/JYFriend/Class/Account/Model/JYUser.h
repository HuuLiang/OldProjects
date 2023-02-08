//
//  JYUser.h
//  JYFriend
//
//  Created by Liang on 2016/12/23.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JKDBModel.h"

typedef NS_ENUM(NSUInteger,JYUserSex) {
    JYUserSexUnKnow = 0,
    JYUserSexMale, //男
    JYUserSexFemale, //女
    JYUserSexALL//所有人(附近的人)
};

#define JYUserSexStringGet  @[@"unknow",@"M",@"F",@"All"]

//#define JYUserSexStringGet (__JYUserSexArray == nil ? __JYUserSexArray = [[NSArray alloc] initWithObjects:@"unknow",@"M",@"F",@"All",nil] : __JYUserSexArray)
//#define JYUserSexToString(userSexType) ([JYUserSexStringGet objectAtIndex:userSexType])
//#define JYUserStringToSex(userSexString) ([JYUserSexStringGet indexOfObject:userSexString])

@interface JYUser : JKDBModel

+ (instancetype)currentUser;

//是否是人
@property (nonatomic) BOOL          isHuman;

//用户id
@property (nonatomic) NSString      *userId;
//头像
@property (nonatomic) NSString      *userImgKey;
//性别
@property (nonatomic) JYUserSex     userSex;
//昵称
@property (nonatomic) NSString      *nickName;
//账号
@property (nonatomic) NSString      *account;
//密码
@property (nonatomic) NSString      *password;
//生日
@property (nonatomic) NSString      *birthday;
//身高
@property (nonatomic) NSString      *height;
//家乡
@property (nonatomic) NSString      *homeTown;
//微信
@property (nonatomic) NSString      *wechat;
//QQ
@property (nonatomic) NSString      *QQ;
//手机
@property (nonatomic) NSString      *phoneNum;
//签名
@property (nonatomic) NSString      *signature;
//是否是VIP
@property (nonatomic) NSNumber *isVip;

//身高选择列表
+ (NSArray *)allUserHeights;
//家乡选择列表
+ (NSMutableDictionary *)allProvincesAndCities;
+ (NSArray *)defaultHometown;
+ (NSArray *)allCitiesWihtProvince:(NSString *)province;

@end
