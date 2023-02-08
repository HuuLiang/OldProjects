//
//  JYCommonDef.h
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#ifndef JYCommonDef_h
#define JYCommonDef_h

typedef NS_ENUM(NSUInteger, JYDeviceType) {
    JYDeviceTypeUnknown,
    JYDeviceType_iPhone4,
    JYDeviceType_iPhone4S,
    JYDeviceType_iPhone5,
    JYDeviceType_iPhone5C,
    JYDeviceType_iPhone5S,
    JYDeviceType_iPhone6,
    JYDeviceType_iPhone6P,
    JYDeviceType_iPhone6S,
    JYDeviceType_iPhone6SP,
    JYDeviceType_iPhoneSE,
    JYDeviceType_iPhone7,
    JYDeviceType_iPhone7P,
    JYDeviceType_iPad = 100
};

typedef NS_ENUM(NSUInteger, JYDynamicType) {
    JYDynamicTypeOnePhoto = 0,  //1张照片
    JYDynamicTypeTwoPhotos,     //2张照片
    JYDynamicTypeThreePhotos,   //3张照片
    JYDynamicTypeVideo,         //视频
    JYDynamicTypeCount
};

typedef NS_ENUM(NSUInteger, JYMineUsersType) {
    JYMineUsersTypeFollow,//关注
    JYMineUsersTypeFans, //粉丝
    JYMineUsersTypeVisitor, //访客
    JYMineUsersTypeHeader,//头像
    JYMineUsersTypeCount
};

typedef NS_ENUM(NSUInteger, JYUserCreateMessageType) {
    JYUserCreateMessageTypeGreet,//打招呼
    JYUserCreateMessageTypeFollow, //关注
    JYUserCreateMessageTypeChat, //聊天
    JYUserCreateMessageTypeCount
};
//会员等级
typedef NS_ENUM(NSUInteger,JYVipType) {
    JYVipTypeYear = 0,
    JYVipTypeQuarter = 1,
    JYVipTypeMonth = 2,
    JYVipTypePacket =3 //发红包
};

#define tableViewCellheight  MAX(kScreenHeight*0.06,44)

#define kPaidNotificationName                   @"JYFriendPaidNotification"
#define kUserLoginNotificationName              @"JYFriendUserLoginNotification"
#define KUserChangeInfoNotificationName         @"JYFriendUserChangeInfoNotificationName"
#define KUpdateContactUnReadMessageNotification @"JYUpdateContactUnReadMessageNotification"

#define kDateFormatShort                  @"yyyy-MM-dd"
#define kDateFormatChina                  @"yyyy年MM月dd日"
#define KDateFormatLong                   @"yyyyMMddHHmmss"
#define kBirthDayMinDate                  @"1942-01-01"
#define kBirthDayMaxDate                  @"2017-02-01"
#define KBirthDaySeletedDate              @"2000-01-01"

#define kWidth(width)                     kScreenWidth  * width  / 750
#define kHeight(height)                   kScreenHeight * height / 1334.
#define kColor(hexString)                 [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",hexString]]
#define kCurrentUser                      [JYUser currentUser]

//#define JY_SYSTEM_CONTACT_NAME_1          @"CONTACT_NAME_1"
//#define JY_SYSTEM_CONTACT_NAME_2          @"CONTACT_NAME_2"
//#define JY_SYSTEM_CONTACT_NAME_3          @"CONTACT_NAME_3"
//#define JY_SYSTEM_CONTACT_SCHEME_1        @"CONTACT_SCHEME_1"
//#define JY_SYSTEM_CONTACT_SCHEME_2        @"CONTACT_SCHEME_2"
//#define JY_SYSTEM_CONTACT_SCHEME_3        @"CONTACT_SCHEME_3"
#define JY_SYSTEM_IMAGE_TOKEN             @"IMG_REFERER"
#define JY_SYSTEM_PAYPOINT_INFO           @"VIP_PAY_POINT_INFO_100"
//#define JY_SYSTEM_PAY_HJ_AMOUNT           @"PAY_MONTH_AMOUNT"
//#define JY_SYSTEM_PAY_ZS_AMOUNT           @"PAY_ZS_AMOUNT"
//#define JY_SYSTEM_PAY_AMOUNT              @"PAY_AMOUNT"
//#define JY_SYSTEM_BAIDUYU_CODE            @"BAIDUYU_CODE"
//#define JY_SYSTEM_BAIDUYU_URL             @"BAIDUYU_URL"

#endif /* JYCommonDef_h */
