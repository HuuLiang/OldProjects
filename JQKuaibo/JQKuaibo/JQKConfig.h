//
//  JQKConfig.h
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#ifndef JQKConfig_h
#define JQKConfig_h

#import "JQKConfiguration.h"

#define JQK_CHANNEL_NO           [JQKConfiguration sharedConfig].channelNo
#define JQK_REST_APP_ID          @"QUBA_2004"
#define JQK_REST_PV              @113
#define JQK_PAYMENT_PV           @203//@113//@"103"
#define JQK_PACKAGE_CERTIFICATE  @"iPhone Distribution: Beijing Huazhong Hengtai Network Technology Co., Ltd."
#define JQK_PAYMENT_RESERVE_DATA [NSString stringWithFormat:@"%@$%@", JQK_REST_APP_ID, JQK_CHANNEL_NO]

#define JQK_BASE_URL             @"http://spiv.jlswz.com"//@"http://120.24.252.114:8093"//
#define JQK_STANDBY_BASE_URL     @"http://sfs.dswtg.com"


#define JQK_HOME_VIDEO_URL              @"/iosvideo/homePage.htm"
#define JQK_HOME_CHANNEL_URL            @"/iosvideo/channelRanking.htm"
#define JQK_HOME_CHANNEL_PROGRAM_URL    @"/iosvideo/program.htm"
#define JQK_HOT_VIDEO_URL               @"/iosvideo/hotVideo.htm"
#define JQK_MOVIE_URL                   @"/iosvideo/hotFilm.htm"
#define JQK_TORRENT_URL                 @"/iosvideo/bt.htm"

#define JQK_ACTIVATE_URL                @"/iosvideo/activat.htm"
#define JQK_SYSTEM_CONFIG_URL           @"/iosvideo/systemConfig.htm"
#define JQK_USER_ACCESS_URL             @"/iosvideo/userAccess.htm"
#define JQK_AGREEMENT_NOTPAID_URL       @"/iosvideo/agreement.html"
#define JQK_AGREEMENT_PAID_URL          @"/iosvideo/agreement-paid.html"
#define JQK_VERSION_UPDATE_URL          @"/iosvideo/versionCheck.htm"//更新

#define JQK_APP_SPREAD_LIST_URL         @"/iosvideo/appSpreadList.htm"
#define JQK_STANDBY_APP_SPREAD_LIST_URL @"/static/iosvideo/appSpreadList.json"
#define JQK_APP_SPREAD_BANNER_URL       @"/iosvideo/appSpreadBanner.htm"
#define JQK_STANDBY_APP_SPREAD_BANNER_URL   @"/static/iosvideo/appSpreadBanner.json"

#define JQK_STATS_BASE_URL              @"http://stats.dswtg.com"//@"http://120.24.252.114"//
#define JQK_STATS_CPC_URL               @"/stats/cpcs.service"
#define JQK_STATS_TAB_URL               @"/stats/tabStat.service"
#define JQK_STATS_PAY_URL               @"/stats/payRes.service"

#define JQK_PAYMENT_COMMIT_URL          @"http://pay.zcqcmj.com/paycenter/qubaPr.json"//@"http://120.24.252.114:8084/paycenter/qubaPr.json"
#define JQK_PAYMENT_CONFIG_URL          @"http://pay.zcqcmj.com/paycenter/appPayConfig.json"//@"http://120.24.252.114:8084/paycenter/appPayConfig.json"
#define JQK_STANDBY_PAYMENT_CONFIG_URL  @"http://appcdn.mqu8.com/static/iosvideo/payConfig_%@.json"

#define JQK_SYSTEM_CONFIG_PAY_AMOUNT            @"PAY_AMOUNT"
#define JQK_SYSTEM_CONFIG_PAYMENT_TOP_IMAGE     @"CHANNEL_TOP_IMG"
#define JQK_SYSTEM_CONFIG_STARTUP_INSTALL       @"START_INSTALL"
#define JQK_SYSTEM_CONFIG_SPREAD_TOP_IMAGE      @"SPREAD_TOP_IMG"
#define JQK_SYSTEM_CONFIG_SPREAD_URL            @"SPREAD_URL"

#define JQK_SYSTEM_CONFIG_SPREAD_LEFT_IMAGE     @"SPREAD_LEFT_IMG"
#define JQK_SYSTEM_CONFIG_SPREAD_LEFT_URL       @"SPREAD_LEFT_URL"
#define JQK_SYSTEM_CONFIG_SPREAD_RIGHT_IMAGE    @"SPREAD_RIGHT_IMG"
#define JQK_SYSTEM_CONFIG_SPREAD_RIGHT_URL      @"SPREAD_RIGHT_URL"
#define JQK_SYSTEM_CONFIG_CONTACT               @"CONTACT"
#define JQK_SYSTEM_CONFIG_NOTIFICATION_LAUNCH_SEQ       @"NOTIFICATION_LAUNCH_SEQ"
#define JQK_SYSTEM_CONFIG_KTVIP_URL             @"VIP_IMG"
#define JQK_SYSTEM_CONFIG_VIP_URL               @"NO_VIP_IMG"
#define JQK_SYSTEM_CONFIG_CONTACT_SCHEME        @"CONTACT_SCHEME"
#define JQK_SYSTEM_CONFIG_CONTACT_NAME          @"CONTACT_NAME"
#define JQK_SYSTEM_CONFIG_IMAGE_TOKEN           @"IMG_REFERER"
#define JQK_SYSTEM_TIME_OUT                        @"TIME_OUT"
#define JQK_SYSTEM_VIDEO_SIGN_KEY               @"VIDEO_SIGN_KEY"
#define JQK_SYSTEM_VIDEO_EXPIRE_TIME            @"EXPIRE_TIME"



#define JQK_PAYMENT_ENCRYPTION_PASSWORD @"wdnxs&*@#!*qb)*&qiang"
#define JQK_PAYMENT_SIGN_KEY            @"qdge^%$#@(sdwHs^&"
#define JQK_ORDER_QUERY_URL             @"http://phas.ihuiyx.com/pd-has/successOrderIds.json"

#define JQK_UMENG_APP_ID         @"567d010667e58e2c8200223a"



#endif /* JQKConfig_h */
