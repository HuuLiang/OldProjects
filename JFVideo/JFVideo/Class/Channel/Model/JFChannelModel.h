//
//  JFChannelModel.h
//  JFVideo
//
//  Created by Liang on 16/7/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBNetworking/QBEncryptedURLRequest.h>
#import "JFChannelColumnModel.h"

@interface JFChannelModelResponse : QBURLResponse
@property (nonatomic) NSArray <JFChannelColumnModel *> *columnList;
@end

@interface JFChannelModel : QBEncryptedURLRequest

- (BOOL)fetchChannelInfoWithPage:(NSInteger)page CompletionHandler:(JFCompletionHandler)handler;

@end
