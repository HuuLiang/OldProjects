//
//  JFActivateModel.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBNetworking/QBEncryptedURLRequest.h>

typedef void (^JFActivateHandler)(BOOL success, NSString *userId);

@interface JFActivateModel : QBEncryptedURLRequest

+ (instancetype)sharedModel;

- (BOOL)activateWithCompletionHandler:(JFActivateHandler)handler;


@end
