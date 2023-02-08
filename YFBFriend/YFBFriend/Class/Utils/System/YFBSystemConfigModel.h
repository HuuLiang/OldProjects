//
//  YFBSystemConfigModel.h
//  YFBFriend
//
//  Created by Liang on 2017/4/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBSystemConfigInfo : NSObject

@property (nonatomic) NSString *CONTACT_SCHEME;

@property (nonatomic) NSString *CONTACT_NAME;

@end

@interface YFBSystemConfigReponse : QBURLResponse
@property (nonatomic) YFBSystemConfigInfo *config;
@end


@interface YFBSystemConfigModel : QBEncryptedURLRequest

+ (instancetype)defaultConfig;

- (void)fetchSystemConfigInfoWithCompletionHandler:(QBCompletionHandler)handler;

@property (nonatomic) YFBSystemConfigInfo *config;

@end
