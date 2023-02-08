//
//  JFSystemConfigModel.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFSystemConfigModel.h"

@implementation JFSystemConfigResponse

- (Class)confisElementClass {
    return [JFSystemConfig class];
}

@end

@implementation JFSystemConfigModel

+ (instancetype)sharedModel {
    static JFSystemConfigModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[JFSystemConfigModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [JFSystemConfigResponse class];
}

- (BOOL)fetchSystemConfigWithCompletionHandler:(JFFetchSystemConfigCompletionHandler)handler {
    @weakify(self);

    BOOL success = [self requestURLPath:JF_SYSTEM_CONFIG_URL
                    standbyURLPath:[JFUtil getStandByUrlPathWithOriginalUrl:JF_SYSTEM_CONFIG_URL params:@{@"type":@([JFUtil deviceType])}]
                             withParams:@{@"type":@([JFUtil deviceType])}
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        DLog("%ld %@",respStatus,errorMessage);
                        
                        if (respStatus == QBURLResponseSuccess) {
                            JFSystemConfigResponse *resp = self.response;
                            
                            [resp.confis enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                JFSystemConfig *config = obj;
                                
                                if ([config.name isEqualToString:JF_SYSTEM_PAY_AMOUNT]) {
                                    [JFSystemConfigModel sharedModel].payAmount = [config.value integerValue];
                                } else if ([config.name isEqualToString:JF_SYSTEM_SVIP_PAY_AMOUNT]) {
                                    [JFSystemConfigModel sharedModel].payAmountPlus = [config.value integerValue];
                                } else if ([config.name isEqualToString:JF_SYSTEM_CONFIG_CONTACT_SCHEME]){
                                    [JFSystemConfigModel sharedModel].contactScheme = config.value;
                                } else if ([config.name isEqualToString:JF_SYSTEM_CONFIG_CONTACT_NAME]){
                                    [JFSystemConfigModel sharedModel].contactName = config.value;
                                } else if ([config.name isEqualToString:JF_SYSTEM_PAY_IMG]) {
                                    [JFSystemConfigModel sharedModel].payImg = config.value;
                                } else if ([config.name isEqualToString:JF_SYSTEM_IMAGE_TOKEN]) {
                                    [JFSystemConfigModel sharedModel].imageToken = config.value;
                                } else if ([config.name isEqualToString:JF_SYSTEM_STATS_TIME_INTERVAL]) {
                                    [JFSystemConfigModel sharedModel].statsTimeInterval = config.value.integerValue;
                                }else if ([config.name isEqualToString:JF_SYSTEM_TIME_OUT]){
                                    self.timeOutInterval = config.value.integerValue;
                                }else if ([config.name isEqualToString:JF_SYSTEM_VIDEO_SIGN_KEY]){
                                    self.videoSignKey = config.value;
                                }else if ([config.name isEqualToString:JF_SYSTEM_VIDEO_EXPIRE_TIME]){
                                    self.expireTime = config.value.doubleValue;
                                }
                            }];
                            _loaded = YES;
                        }else {
                            [JFSystemConfigModel sharedModel].payAmount = 3800;
                            [JFSystemConfigModel sharedModel].payAmountPlus = 5800;
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess);
                        }
                        
                    }];
    return success;
    
}


@end
