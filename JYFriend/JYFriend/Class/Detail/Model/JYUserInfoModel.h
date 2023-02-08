//
//  JYUserInfoModel.h
//  JYFriend
//
//  Created by ylz on 2017/1/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBURLResponse.h>

@interface JYUserInfoModel : QBURLResponse

@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *nickName;//昵称
@property (nonatomic) NSString *logoUrl;//头像
@property (nonatomic) NSString *sex;
@property (nonatomic) NSNumber *age;
@property (nonatomic) NSString *note;//签名
@property (nonatomic) NSNumber *isVip;
@property (nonatomic) NSNumber *height;
@property (nonatomic) NSString *province;//省
@property (nonatomic) NSString *city;
@property (nonatomic) NSNumber *qq;
@property (nonatomic) NSString *weixinNum;
@property (nonatomic) NSString *starSign;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *km;

@end
