//
//  JYConfig.h
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#ifndef JYConfig_h
#define JYConfig_h

#define JY_CHANNEL_NO               [JYConfiguration sharedConfig].channelNo
#define JY_REST_APPID               @"QUBA_2027"
#define JY_REST_PV                  @"100"
#define JY_PAYMENT_PV               @"100"
#define JY_PACKAGE_CERTIFICATE      @"iPhone Distribution: Neijiang Fenghuang Enterprise (Group) Co., Ltd."

#define JY_REST_APP_VERSION         ((NSString *)([NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]))
//#define JY_PAYMENT_RESERVE_DATA     [NSString stringWithFormat:@"%@$%@", JY_REST_APPID, JY_CHANNEL_NO]

#define JY_BASE_URL                    @"http://mcps.dswtg.com"//@"http://iv.zcqcmj.com"
#define JY_STANDBY_BASE_URL            @"http://sfs.dswtg.com"

#define JY_ACTIVATION_URL              @"/mfwcps/jihuo.htm"                     //激活
#define JY_ACCESS_URL                  @"/mfwcps/userAccess.htm"                //登录次数
#define JY_SYSTEM_CONFIG_URL           @"/mfwcps/systemConfig.htm"              //系统配置
#define JY_USERCREATE_URL              @"/mfwcps/userCreate.htm"                //注册
#define JY_CHARACTER_URL               @"/mfwcps/recommend.htm"                 //推荐
#define JY_CHARACTER_FIGURE_URL        @"/mfwcps/recommendPage.htm"              //人物
#define JY_DYNAMIC_URL                 @"/mfwcps/moodSection.htm"               //动态
#define JY_NEAR_PERSON_URL             @"/mfwcps/peopleNearby.htm"              //附近
#define JY_USER_DETAIL_URL             @"/mfwcps/userDetails.htm"               //详情
#define JY_INTERACTIVE_URL             @"/mfwcps/interactive.htm"               //交互  关注  粉丝  访问我的
#define JY_BATCHGREET_URL              @"/mfwcps/batchGreetCreate.htm"          //批量打招呼
#define JY_MESSAGECREATE_URL           @"/mfwcps/messageCreate.htm"             //消息新增
#define JY_VIPUPDATE_URL               @"/mfwcps/updateUserVip.htm"             //升级VIP

//#define JY_TRAIL_URL                   @"/iosvideo/homePage.htm"
//#define JY_VIPA_URL                    @"/iosvideo/vipVideo.htm"
//#define JY_VIPB_URL                    @"/iosvideo/zsVipVideo.htm"
//#define JY_VIPC_URL                    @"/iosvideo/hjVipVideo.htm"
//#define JY_SEX_URL                     @"/iosvideo/channelRanking.htm"
//#define JY_HOT_URL                     @"/iosvideo/hotTag.htm"
//#define JY_SEARCH_URL                  @"/iosvideo/search.htm"
//#define JY_DETAIL_URL                  @"/iosvideo/detailsg.htm"

#define PP_APP_URL                     @"/iosvideo/appSpreadList.htm"
#define JY_APP_SPREAD_BANNER_URL       @"/iosvideo/appSpreadBanner.htm"

#define JY_UMENG_APP_ID                @"587ad129ae1bf845be000294"

#endif /* JYConfig_h */
