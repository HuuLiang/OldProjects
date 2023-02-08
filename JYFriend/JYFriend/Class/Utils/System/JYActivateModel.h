//
//  JYActivateModel.h
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

typedef void (^JYActivateHandler)(BOOL success, NSString *uuid);

@interface JYActivate : QBURLResponse
@property (nonatomic) NSString *uuid;

@end

@interface JYActivateModel : QBEncryptedURLRequest

+ (instancetype)sharedModel;

- (BOOL)activateWithCompletionHandler:(JYActivateHandler)handler;

@end
