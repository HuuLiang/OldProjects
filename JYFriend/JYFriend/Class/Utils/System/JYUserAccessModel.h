//
//  JYUserAccessModel.h
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

typedef void (^JYUserAccessCompletionHandler)(BOOL success);

@interface JYUserAccessModel : QBEncryptedURLRequest

+ (instancetype)sharedModel;

- (BOOL)requestUserAccess;

@end
