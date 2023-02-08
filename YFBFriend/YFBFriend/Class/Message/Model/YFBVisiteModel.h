//
//  YFBVisiteModel.h
//  YFBFriend
//
//  Created by Liang on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>


@interface YFBVisiteRobotModel : NSObject
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *portraitUrl;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSInteger visitTime;
@end

@interface YFBVisiteResponse : QBURLResponse
@property (nonatomic) NSArray <YFBVisiteRobotModel *> *userList;
@end

@interface YFBVisiteModel : QBEncryptedURLRequest

+ (instancetype)manager;

- (BOOL)fetchVisitemeInfoWithCompletionHandler:(QBCompletionHandler)handler;
@end
