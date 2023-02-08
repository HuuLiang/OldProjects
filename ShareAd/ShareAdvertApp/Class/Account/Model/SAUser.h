//
//  SAUser.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SAUser : JKDBModel

+ (instancetype _Nonnull)user;

- (void)setValueWithObj:(SAUser * _Nullable)responseUser;

@property (nonatomic,nullable) NSString *userId;

@property (nonatomic,nullable) NSString *phone;

@property (nonatomic,nullable) NSString *password;

@property (nonatomic,nullable) NSString *portraitUrl;

@property (nonatomic,nullable) NSString *nickName;

@property (nonatomic,nullable) NSString *weixin;

@property (nonatomic,nullable) NSString *aliPay;

@property (nonatomic,nullable) NSString *name;

@property (nonatomic,nullable) NSString *sex;

@property (nonatomic,nullable) NSString *province;

@property (nonatomic,nullable) NSString *city;

@property (nonatomic,nullable) NSString *openId;

@property (nonatomic) NSInteger masterId;

@property (nonatomic) NSInteger amount;

@property (nonatomic,nullable) NSString *verifyCode;

@end
