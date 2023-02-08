//
//  YFBRobot.h
//  YFBFriend
//
//  Created by Liang on 2017/3/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface YFBRobot : JKDBModel
@property (nonatomic) NSString *userId;
@property (nonatomic) NSInteger age;
@property (nonatomic) NSString *city;
@property (nonatomic) CGFloat distance;
@property (nonatomic) NSInteger height;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *portraitUrl;
@property (nonatomic) NSString *onKeyGreetImgUrl;
@property (nonatomic) NSString *gender;
@property (nonatomic) NSInteger recvGiftCount;
@property (nonatomic) NSInteger sendGiftCount;
@property (nonatomic) BOOL greeted; //打招呼
@property (nonatomic) BOOL concernMe; //关注我
@property (nonatomic) BOOL concerned; //是否关注

+ (BOOL)checkUserIsGreetedWithUserId:(NSString *)userId;

@end
