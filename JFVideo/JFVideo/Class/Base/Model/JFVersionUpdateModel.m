//
//  JFVersionUpdateModel.m
//  JFuaibo
//
//  Created by ylz on 2016/12/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFVersionUpdateModel.h"

@implementation JFVersionUpdateInfo

@end

@implementation JFVersionUpdateModel

+ (instancetype)sharedModel {
    static JFVersionUpdateModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

+ (Class)responseClass {
    return [JFVersionUpdateInfo class];
}

//- (NSURL *)baseURL {
//    return nil;
//}

- (BOOL)fetchLatestVersionWithCompletionHandler:(JFCompletionHandler)completionHandler {
    @weakify(self);
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    BOOL rect = [self requestURLPath:JF_VERSION_UPDATE_URL withParams:@{@"versionNo":currentVersion, @"packageId":bundleId} responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        JFVersionUpdateInfo *versionInfo;
        if (respStatus == QBURLResponseSuccess) {
            versionInfo = self.response;
            self->_fetchedVersionInfo = versionInfo;
        }
        
        QBSafelyCallBlock(completionHandler, respStatus==QBURLResponseSuccess, versionInfo);
    }];
    return rect;
}

@end
