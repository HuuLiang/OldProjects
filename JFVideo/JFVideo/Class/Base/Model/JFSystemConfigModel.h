//
//  JFSystemConfigModel.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBNetworking/QBEncryptedURLRequest.h>
#import "JFSystemConfig.h"

@interface JFSystemConfigResponse : QBURLResponse
@property (nonatomic,retain) NSArray<JFSystemConfig> *confis;
@end

typedef void (^JFFetchSystemConfigCompletionHandler)(BOOL success);

@interface JFSystemConfigModel : QBEncryptedURLRequest

@property (nonatomic) NSString *payImg;
@property (nonatomic) NSInteger payAmount;
@property (nonatomic) NSInteger payAmountPlus;
@property (nonatomic) NSInteger payAmountPlusPlus;
@property (nonatomic) NSString *contactScheme;
@property (nonatomic,copy)NSString *contactName;
@property (nonatomic) NSString *imageToken;
@property (nonatomic) NSUInteger statsTimeInterval;
@property (nonatomic,readonly) BOOL loaded;
@property (nonatomic) NSInteger timeOutInterval;
@property (nonatomic) NSString *videoSignKey;
@property (nonatomic) NSTimeInterval expireTime;

+ (instancetype)sharedModel;

- (BOOL)fetchSystemConfigWithCompletionHandler:(JFFetchSystemConfigCompletionHandler)handler;

@end
