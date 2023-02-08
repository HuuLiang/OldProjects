//
//  JYSystemConfigModel.h
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
#import "JYSystemConfig.h"

@interface JYSystemConfigResponse : QBURLResponse
@property (nonatomic,retain) NSArray<JYSystemConfig *> *configs;
@end

typedef void (^JYFetchSystemConfigCompletionHandler)(BOOL success);

@interface JYSystemConfigModel : QBEncryptedURLRequest

//@property (nonatomic) NSInteger payAmount;
//@property (nonatomic) NSInteger payzsAmount;
//@property (nonatomic) NSInteger payhjAmount;
//
//@property (nonatomic) NSString *mineImgUrl;
//@property (nonatomic) NSString *vipImg;
//@property (nonatomic) NSString *sVipImg;
//
//@property (nonatomic) NSString *contactName1;
//@property (nonatomic) NSString *contactName2;
//@property (nonatomic) NSString *contactName3;
//
//@property (nonatomic) NSString *contactScheme1;
//@property (nonatomic) NSString *contactScheme2;
//@property (nonatomic) NSString *contactScheme3;
//
//@property (nonatomic) NSString *baiduyuUrl;
//@property (nonatomic) NSString *baiduyuCode;

@property (nonatomic) NSInteger vipPriceA;
@property (nonatomic) NSInteger vipPriceB;
@property (nonatomic) NSInteger vipPriceC;

@property (nonatomic) NSInteger vipMonthA;
@property (nonatomic) NSInteger vipMonthB;
@property (nonatomic) NSInteger vipMonthC;

@property (nonatomic) NSString *imageToken;
@property (nonatomic,readonly) BOOL loaded;

+ (instancetype)sharedModel;

- (BOOL)fetchSystemConfigWithCompletionHandler:(JYFetchSystemConfigCompletionHandler)handler;

@end
