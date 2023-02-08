//
//  JYInteractiveModel.h
//  JYFriend
//
//  Created by Liang on 2017/1/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>



@interface JYInteractiveUser : NSObject
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *logoUrl;
@end

@interface JYInteractiveResponse : QBURLResponse
@property (nonatomic) NSArray <JYInteractiveUser *> *userList;
@end

@interface JYInteractiveModel : QBEncryptedURLRequest

- (BOOL)fetchInteractiveInfoWithType:(JYMineUsersType)type CompletionHandler:(QBCompletionHandler)handler;

@end
