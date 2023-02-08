//
//  JYSystemConfigModel.m
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYSystemConfigModel.h"

static NSString *const kPPVideoSystemConfigPayMonthKeyName       = @"PP_SystemConfigPayAmount_KeyName";
static NSString *const kPPVideoSystemConfigPayQuarterKeyName     = @"PP_SystemConfigPayzsAmount_KeyName";
static NSString *const kPPVideoSystemConfigPayYearKeyName     = @"PP_SystemConfigPayhjAmount_KeyName";

@implementation JYSystemConfigResponse

- (Class)configsElementClass {
    return [JYSystemConfig class];
}

@end

@implementation JYSystemConfigModel

+ (instancetype)sharedModel {
    static JYSystemConfigModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[JYSystemConfigModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [JYSystemConfigResponse class];
}

- (QBURLRequestMethod)requestMethod {

    return QBURLPostRequest;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.vipPriceA = [[coder decodeObjectForKey:kPPVideoSystemConfigPayMonthKeyName] integerValue];
        self.vipPriceB = [[coder decodeObjectForKey:kPPVideoSystemConfigPayQuarterKeyName] integerValue];
        self.vipPriceC = [[coder decodeObjectForKey:kPPVideoSystemConfigPayYearKeyName] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:self.vipPriceA] forKey:kPPVideoSystemConfigPayMonthKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.vipPriceB] forKey:kPPVideoSystemConfigPayQuarterKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.vipPriceC] forKey:kPPVideoSystemConfigPayYearKeyName];
}

- (BOOL)fetchSystemConfigWithCompletionHandler:(JYFetchSystemConfigCompletionHandler)handler {
    
//    NSDictionary *params = @{@"type":@([JYUtil deviceType])};
    
    @weakify(self);
    BOOL success = [self requestURLPath:JY_SYSTEM_CONFIG_URL
                         standbyURLPath:[JYUtil getStandByUrlPathWithOriginalUrl:JY_SYSTEM_CONFIG_URL params:nil]
                             withParams:nil
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        if (respStatus == QBURLResponseSuccess) {
                            JYSystemConfigResponse *resp = self.response;
                            
                            [resp.configs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                JYSystemConfig *config = obj;
                                
                                if ([config.name isEqualToString:JY_SYSTEM_IMAGE_TOKEN]) {
                                    [JYSystemConfigModel sharedModel].imageToken = config.value;
                                } else if ([config.name isEqualToString:JY_SYSTEM_PAYPOINT_INFO]) {
                                    [[config.value componentsSeparatedByString:@"|"] enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                        NSArray *array = [obj componentsSeparatedByString:@":"];
                                        if (idx == 0) {
                                            [JYSystemConfigModel sharedModel].vipMonthA = [[array lastObject] integerValue];
                                            [JYSystemConfigModel sharedModel].vipPriceA = [[array firstObject] integerValue];
                                        } else if (idx == 1) {
                                            [JYSystemConfigModel sharedModel].vipMonthB = [[array lastObject] integerValue];
                                            [JYSystemConfigModel sharedModel].vipPriceB = [[array firstObject] integerValue];
                                        } else if (idx == 2) {
                                            [JYSystemConfigModel sharedModel].vipMonthC = [[array lastObject] integerValue];
                                            [JYSystemConfigModel sharedModel].vipPriceC = [[array firstObject] integerValue];
                                        }
                                    }];
                                }
                            
                                
//                                else if ([config.name isEqualToString:JY_SYSTEM_CONTACT_NAME_1]) {
//                                    [JYSystemConfigModel sharedModel].contactName1 = config.value;
//                                } else if ([config.name isEqualToString:JY_SYSTEM_CONTACT_NAME_2]) {
//                                    [JYSystemConfigModel sharedModel].contactName2 = config.value;
//                                } else if ([config.name isEqualToString:JY_SYSTEM_CONTACT_NAME_3]) {
//                                    [JYSystemConfigModel sharedModel].contactName3 = config.value;
//                                } else if ([config.name isEqualToString:JY_SYSTEM_CONTACT_SCHEME_1]) {
//                                    [JYSystemConfigModel sharedModel].contactScheme1 = config.value;
//                                } else if ([config.name isEqualToString:JY_SYSTEM_CONTACT_SCHEME_2]) {
//                                    [JYSystemConfigModel sharedModel].contactScheme2 = config.value;
//                                } else if ([config.name isEqualToString:JY_SYSTEM_CONTACT_SCHEME_3]) {
//                                    [JYSystemConfigModel sharedModel].contactScheme3 = config.value;
//                                } else if ([config.name isEqualToString:JY_SYSTEM_BAIDUYU_URL]) {
//                                    [JYSystemConfigModel sharedModel].baiduyuUrl = config.value;
//                                } else if ([config.name isEqualToString:JY_SYSTEM_BAIDUYU_CODE]) {
//                                    [JYSystemConfigModel sharedModel].baiduyuCode = config.value;
//                                }
                                
                                //刷新价格缓存
//                                [PPCacheModel updateSystemConfigModelWithSystemConfigModel:[PPSystemConfigModel sharedModel]];
                            }];
                            _loaded = YES;
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess);
                        }
                    }];
    return success;
}


@end
