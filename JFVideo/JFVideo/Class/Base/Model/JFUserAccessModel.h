//
//  JFUserAccessModel.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBNetworking/QBEncryptedURLRequest.h>

typedef void (^JFUserAccessCompletionHandler)(BOOL success);

@interface JFUserAccessModel : QBEncryptedURLRequest

+ (instancetype)sharedModel;

- (BOOL)requestUserAccess;

@end
