//
//  YFBPayConfigManager.m
//  YFBFriend
//
//  Created by Liang on 2017/5/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBPayConfigManager.h"

static NSString *const kYFBPayConfigTypeVipKeyName          = @"OPEN_VIP_2";
static NSString *const kYFBPayConfigTypeDiamondKeyName      = @"PURCHASE_DIAMOND_2";

@implementation YFBPayConfigInfo
@end


@implementation YFBPayConfigReponse
- (Class)pciListElementClass {
    return [YFBPayConfigInfo class];
}
@end


@implementation YFBPayConfigDetailInfo
@end


@implementation YFBPayVipInfo
@end


@implementation YFBPayDiamondInfo
@end


@implementation YFBPayConfigManager
+ (Class)responseClass {
    return [YFBPayConfigReponse class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (instancetype)manager {
    static YFBPayConfigManager *_payConfigManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _payConfigManager = [[YFBPayConfigManager alloc] init];
    });
    return _payConfigManager;
}

- (void)getPayConfig {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token};
    [self requestURLPath:YFB_PAYCONFIG_URL
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBPayConfigReponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
            [resp.pciList enumerateObjectsUsingBlock:^(YFBPayConfigInfo * _Nonnull payConfigInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([payConfigInfo.typeCode isEqualToString:kYFBPayConfigTypeVipKeyName]) {
                    __block YFBPayVipInfo *vipInfo = [[YFBPayVipInfo alloc] init];
                    [[payConfigInfo.amountPrice componentsSeparatedByString:@";"] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (idx == 0) {
                            vipInfo.firstInfo = [self getDetailInfo:obj];
                        } else if (idx == 1) {
                            vipInfo.secondInfo = [self getDetailInfo:obj];
                        }
                    }];
                    self.vipInfo = vipInfo;
                } else if ([payConfigInfo.typeCode isEqualToString:kYFBPayConfigTypeDiamondKeyName]) {
                    __block YFBPayDiamondInfo *diamondInfo = [[YFBPayDiamondInfo alloc] init];
                    [[payConfigInfo.amountPrice componentsSeparatedByString:@";"] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (idx == 0) {
                            diamondInfo.firstInfo = [self getDetailInfo:obj];
                        } else if (idx == 1) {
                            diamondInfo.secondInfo = [self getDetailInfo:obj];
                        }
                    }];
                    self.diamondInfo = diamondInfo;
                }
            }];
            
        } else {
            [self performSelector:@selector(getPayConfig) withObject:nil afterDelay:60];
        }
    }];
}

- (YFBPayConfigDetailInfo *)getDetailInfo:(id)object {
    __block YFBPayConfigDetailInfo *info = [[YFBPayConfigDetailInfo alloc] init];
    [[object componentsSeparatedByString:@":"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            info.amount = [obj integerValue];
        } else if (idx == 1) {
            info.price = [obj integerValue];
        } else if (idx == 2) {
            info.title = obj;
        } else if (idx == 3) {
            info.popDesc = obj;
        } else if (idx == 4) {
            info.vipDesc = obj;
        }
    }];
    return info;
}

@end
