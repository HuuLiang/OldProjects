//
//  SAConfig.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#ifndef SAConfig_h
#define SAConfig_h

//baseInfo
#define SA_CHANNEL_NO               [SAConfiguration sharedConfig].channelNo
#define SA_REST_APPID               @"QUBA_3001"
//#define SA_REST_PV                  @"100"
//#define SA_PAYMENT_PV               @"100"
#define SA_CONTENT_VERSION          @"1.0"
#define SA_PACKAGE_CERTIFICATE      @"iPhone Distribution: Neijiang Fenghuang Enterprise (Group) Co., Ltd."

#define SA_REST_APP_VERSION         ((NSString *)([NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]))
#define SA_BUNDLE_IDENTIFIER        ((NSString *)([NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"]))
#define SA_PAYMENT_RESERVE_DATA     [NSString stringWithFormat:@"%@$%@", SA_REST_APPID, SA_CHANNEL_NO]
#define SA_PAYMENT_ORDERID          [NSString stringWithFormat:@"%@_%@", [SA_CHANNEL_NO substringFromIndex:SA_CHANNEL_NO.length-14], [[NSUUID UUID].UUIDString.md5 substringWithRange:NSMakeRange(8, 16)]]



//URL
#define SA_BASE_URL                    @"http://120.24.252.114:8095"
#define SA_STANDBY_BASE_URL            @""
#define SA_ACTIVATE_URL                @"/share/activat.htm"
#define SA_REGISTER_URL                @"/share/register.htm"
#define SA_RESET_URL                   @"/share/reset.htm"
#define SA_CONFIG_URL                  @"/share/config.htm"
#define SA_LOGIN_URL                   @"/share/login.htm"
#define SA_USERINFO_URL                @"/share/user.htm"
#define SA_UPDATEUSER_URL              @"/share/updateUser.htm"
#define SA_SHARECOLUMN_URL             @"/share/column.htm"
#define SA_SHARELIST_URL               @"/share/shareList.htm"
#define SA_QUERYWITHDRAW_URL           @"/share/queryWithdraw.htm"
#define SA_QUERYACCOUNT_URL            @"/share/queryAccounting.htm"
#define SA_RANKING_URL                 @"/share/ranking.htm"
#define SA_ACCOUNT_URL                 @"/share/account.htm"
#define SA_SHAREBOUNTY_URL             @"/share/shareBounty.htm"
#define SA_SIGN_URL                    @"/share/sign.htm"
#define SA_WITHDRAW_URL                @"/share/withdraw.htm"
#define SA_ABOUNTUS_URL                @"/share/aboutus.html"
#define SA_QUERYAPPRENTICE_URL         @"/share/queryApprentice.htm"
#define SA_APPRENTICEMM_URL            @"/share/apprenticemm.html"
#define SA_RULE_URL                    @"/share/rule.html"
#define SA_SHAREMM_URL                 @"/share/sharemm.html"
#define SA_VERIFYCODE_URL              @"http://120.24.252.114/verifycode/sendvc.do"

//secret
#define SA_ENCRYPT_PASSWORD            @"qb%Fr@2016_&"

//友盟
#define SA_UMENG_APP_ID                @"596c6a7e8f4a9d155d000a94"

//微信
#define SA_WEXIN_APP_ID                @"wx077ffc9a06be35f4"
#define SA_WECHAT_TOKEN                @"https://api.weixin.qq.com/sns/oauth2/access_token?"
#define SA_WECHAT_SECRET               @"bd21431991f8725c6befca233fca8cd3"
#define SA_WECHAT_USERINFO             @"https://api.weixin.qq.com/sns/userinfo?"

//七牛图片
#define SA_UPLOAD_SCOPE                @"mfw-image"
#define SA_UPLOAD_SECRET_KEY           @"9mmo2Dd9oca-2SJ5Uou9qQ1d2XjNIoX9EdrPQ6Xj"
#define SA_UPLOAD_ACCESS_KEY           @"JIWlLAM3_bGrfTyU16XKjluzYKcsHOB--yDFB4zt"

#endif /* SAConfig_h */
