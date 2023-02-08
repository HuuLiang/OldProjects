//
//  YFBGreetingInfoModel.h
//  YFBFriend
//
//  Created by Liang on 2017/4/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
@class YFBRobot;

@interface YFBGreetingInfoResponse : QBURLResponse
@property (nonatomic) NSArray <YFBRobot *>*userList;
@end


@interface YFBGreetingInfoModel : QBEncryptedURLRequest

- (BOOL)fetchGreetingInfoWithCompletionHandler:(QBCompletionHandler)handler;

@end
