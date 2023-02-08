//
//  YFBActivateModel.h
//  YFBFriend
//
//  Created by Liang on 2017/4/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBActivateResponse : QBURLResponse
@property (nonatomic) NSString *uuid;
@end


@interface YFBActivateModel : QBEncryptedURLRequest

+ (instancetype)manager;

- (void)activateWithCompletionHandler:(QBCompletionHandler)handler;

@end
