//
//  JYRegisterUserModel.h
//  JYFriend
//
//  Created by Liang on 2017/1/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface JYRegisterUserResponse : QBURLResponse
@property (nonatomic) NSString *userId;
@end

@interface JYRegisterUserModel : QBEncryptedURLRequest

- (BOOL)registerUserWithUserInfo:(JYUser *)user completionHandler:(QBCompletionHandler)handler;

@end
