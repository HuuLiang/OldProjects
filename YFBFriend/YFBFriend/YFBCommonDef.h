//
//  YFBCommonDef.h
//  YFBFriend
//
//  Created by Liang on 2017/2/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#ifndef YFBCommonDef_h
#define YFBCommonDef_h

typedef NS_ENUM(NSUInteger, YFBDeviceType) {
    YFBDeviceTypeUnknown,
    YFBDeviceType_iPhone4,
    YFBDeviceType_iPhone4S,
    YFBDeviceType_iPhone5,
    YFBDeviceType_iPhone5C,
    YFBDeviceType_iPhone5S,
    YFBDeviceType_iPhone6,
    YFBDeviceType_iPhone6P,
    YFBDeviceType_iPhone6S,
    YFBDeviceType_iPhone6SP,
    YFBDeviceType_iPhoneSE,
    YFBDeviceType_iPhone7,
    YFBDeviceType_iPhone7P,
    YFBDeviceType_iPad = 100
};

typedef NS_ENUM(NSInteger,YFBRankType) {
    YFBRankTypeSend = 0 ,//土豪榜
    YFBRankTypereceived //魅力榜
};

typedef NS_ENUM(NSInteger,YFBPayType) {
    YFBPayTypeWeiXin = 0, //微信
    YFBPayTypeAliPay //支付宝
};

typedef NS_ENUM(NSInteger,YFBGiftPopViewType) {
    YFBGiftPopViewTypeBlag = 0, //索要礼物
    YFBGiftPopViewTypeList      //赠送礼物
};

typedef NS_ENUM(NSInteger,YFBSocialType) {
    YFBSocialTypeAll = 0,
    YFBSocialTypeChat,
    YFBSocialTypeGame,
    YFBSocialTypeGF
};

typedef NS_ENUM(NSInteger, YFBMessagePopViewType) {
    YFBMessagePopViewTypeVip, // 开通vip界面
    YFBMessagePopViewTypeDiamond, //充值钻石列表界面
    YFBMessagePopViewTypeBuyDiamond //充值钻石界面
};

typedef NS_ENUM(NSInteger, YFBUserInfoOpenType) {
    YFBUserInfoOpenTypeClose = 0,//对vip用户开放
    YFBUserInfoOpenTypeVip //保密
};

typedef NS_ENUM(NSUInteger, YFBMessageType) {
    YFBMessageTypeText = 1,         //文字消息
    YFBMessageTypePhoto = 2,        //图片消息
    YFBMessageTypeGift = 3,         //礼物
    YFBMessageTypeVoice = 4,        //声音
    YFBMessageTypeVideo = 5,        //视频
    YFBMessageTypeFaceTime = 6,     //视频聊天邀请
    YFBMessageTypeCount
};

typedef NS_ENUM(NSInteger, YFBPayResult) {
    YFBPayResultUnknow = 0,     //未知状态
    YFBPayResultSuccess = 1,    //成功
    YFBPayResultCancle = 2,     //取消
    YFBPayResultFailed = 3      //失败
};

typedef void (^YFBAction)(void);


static NSString *const kYFBFriendCurrentUserKeyName         = @"kYFBFriendCurrentUserKeyName";

#define tableViewCellheight  MAX(kScreenHeight*0.06,44)

#define kPaidNotificationName                           @"YFBFriendPaidNotification"
#define kUserLoginNotificationName                      @"YFBFriendUserLoginNotification"
#define KUserChangeInfoNotificationName                 @"YFBFriendUserChangeInfoNotificationName"
#define KUpdateContactUnReadMessageNotification         @"YFBUpdateContactUnReadMessageNotification"
#define kYFBFriendShowMessageNotification               @"kYFBFriendShowMessageNotification"
//#define kYFBUpdateMessageDiamondCountNotification       @"kYFBUpdateMessageDiamondCountNotification"
#define kYFBUpdateGiftDiamondCountNotification          @"kYFBUpdateGiftDiamondCountNotification"
#define kYFBUpdateMessageViewControllerNotification     @"kYFBUpdateMessageViewControllerNotification"
#define kYFBFriendGetRobotMsgTimeIntervalKeyName        @"kYFBFriendGetRobotMsgTimeIntervalKeyName"
#define kYFBSocialPaySuccessNotification                @"kYFBSocialPaySuccessNotification"
#define kYFBShowChargeNotification                      @"kYFBShowChargeNotification"
#define kYFBHideChargeNotification                      @"kYFBHideChargeNotification"

#define kYFBFriendAliPaySchemeUrl                       @"comyuefenbaappalipayschemeurl"
#define kYFBFriendWXPaySchemeUrl                        @"wx2b2846687e296e95"

#define kYFBAutoNotificationTypeKeyName                 @"type"
#define kYFBAutoNotificationContentKeyName              @"AutoNotification"

#define KDateFormatShortest               @"yyyyMMdd"
#define kDateFormatShort                  @"yyyy-MM-dd"
#define kDateFormatChina                  @"yyyy年MM月dd日"
#define KDateFormatLong                   @"yyyyMMddHHmmss"
#define kDateFormateLongest               @"yyyy-MM-dd HH:mm:ss"
#define kBirthDayMinDate                  @"1942-01-01"
#define kBirthDayMaxDate                  @"2017-02-01"
#define KBirthDaySeletedDate              @"2000-01-01"

#define kWidth(width)                     kScreenWidth  * width  / 750.
#define kHeight(height)                   kScreenHeight * height / 1334.
#define kColor(hexString)                 [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",hexString]]
#define kCurrentUser                      [YFBUser currentUser]
#define kFont(font)                       [UIFont systemFontOfSize:kWidth(font*2)]
//#define YFB_SYSTEM_CONTACT_NAME_1          @"CONTACT_NAME_1"
//#define YFB_SYSTEM_CONTACT_NAME_2          @"CONTACT_NAME_2"
//#define YFB_SYSTEM_CONTACT_NAME_3          @"CONTACT_NAME_3"
//#define YFB_SYSTEM_CONTACT_SCHEME_1        @"CONTACT_SCHEME_1"
//#define YFB_SYSTEM_CONTACT_SCHEME_2        @"CONTACT_SCHEME_2"
//#define YFB_SYSTEM_CONTACT_SCHEME_3        @"CONTACT_SCHEME_3"
#define YFB_SYSTEM_IMAGE_TOKEN             @"IMG_REFERER"
#define YFB_SYSTEM_PAYPOINT_INFO           @"VIP_PAY_POINT_INFO_100"
//#define YFB_SYSTEM_PAY_HJ_AMOUNT           @"PAY_MONTH_AMOUNT"
//#define YFB_SYSTEM_PAY_ZS_AMOUNT           @"PAY_ZS_AMOUNT"
//#define YFB_SYSTEM_PAY_AMOUNT              @"PAY_AMOUNT"
//#define YFB_SYSTEM_BAIDUYU_CODE            @"BAIDUYU_CODE"
//#define YFB_SYSTEM_BAIDUYU_URL             @"BAIDUYU_URL"


#endif /* YFBCommonDef_h */
