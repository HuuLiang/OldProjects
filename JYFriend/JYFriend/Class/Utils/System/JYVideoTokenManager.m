//
//  JYVideoTokenManager.m
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYVideoTokenManager.h"
#import <AFNetworking.h>
#import <NSDate+Utilities.h>
#import "JYActivateModel.h"

static NSString *const kTokenURL = @"http://token.iqu8.cn/token";//@"http://bbs.qu8cc.com/token";
static NSString *const kTokenDataEncryptionPassword = @"fdl_2016$@Ask^we";

@interface JYVideoTokenManager ()
@property (nonatomic) NSString *token;
@property (nonatomic,retain) NSDate *expireTime;
@property (nonatomic) NSString *userId;
@end

@implementation JYVideoTokenManager

+ (instancetype)sharedManager {
    static JYVideoTokenManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)requestTokenWithCompletionHandler:(JYVideoTokenCompletionHandler)completionHandler {
    
    if (self.token && self.expireTime && self.userId) {
        if ([self.expireTime isLaterThanDate:[NSDate date]]) {
            QBSafelyCallBlock(completionHandler, YES, self.token, self.userId);
            return ;
        }
    }
    
    if (![JYUtil userId]) {
        @weakify(self);
        [[JYActivateModel sharedModel] activateWithCompletionHandler:^(BOOL success, NSString *userId) {
            @strongify(self);
            if (success) {
                [self httpRequestTokenWithUserId:userId completionHandler:completionHandler];
            } else {
                QBSafelyCallBlock(completionHandler, NO, nil, nil);
            }
        }];
    } else {
        [self httpRequestTokenWithUserId:[JYUtil userId] completionHandler:completionHandler];
    }
    
}

- (void)httpRequestTokenWithUserId:(NSString *)userId completionHandler:(JYVideoTokenCompletionHandler)completionHandler {
    if (userId == nil) {
        QBSafelyCallBlock(completionHandler, NO, nil, nil);
        return ;
    }
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *dataString = [NSString stringWithFormat:@"uid=%@&channelNo=%@&appId=%@", userId, JY_CHANNEL_NO, JY_REST_APPID];
    NSDictionary *params = @{@"data":[dataString encryptedStringWithPassword:kTokenDataEncryptionPassword]};
    
    @weakify(self);
    [sessionManager POST:kTokenURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *encryptedData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *dataString = [encryptedData decryptedStringWithPassword:kTokenDataEncryptionPassword];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        QBLog(@"Token request response: %@", dic);
        
        NSString *token = dic[@"token"];
        NSNumber *expireTime = dic[@"expireTime"];
        
        if (!token || !expireTime) {
            QBSafelyCallBlock(completionHandler, NO, nil, nil);
            return ;
        }
        
        @strongify(self);
        self.userId = userId;
        self.token = token;
        self.expireTime = [NSDate dateWithTimeIntervalSinceNow:expireTime.integerValue/2];
        QBSafelyCallBlock(completionHandler, YES, token, userId);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QBLog(@"Token request error: %@", error.localizedDescription);
        QBSafelyCallBlock(completionHandler, NO, nil, nil);
    }];
}

- (NSString *)videoLinkWithOriginalLink:(NSString *)originalLink {
    if (!self.token || !self.userId) {
        return originalLink;
    }
    
    NSString *videoLink = [NSString stringWithFormat:@"%@?uid=%@&token=%@&verCode=%@", originalLink, self.userId, self.token, @"20160923"];
    return videoLink;
}


@end
