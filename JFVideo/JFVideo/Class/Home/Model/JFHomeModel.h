//
//  JFHomeModel.h
//  JFVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBNetworking/QBEncryptedURLRequest.h>
#import "JFHomeColumnModel.h"

@interface JFHomeModelResponse : QBURLResponse
@property (nonatomic) NSArray <JFHomeColumnModel *> *columnList;
@end

@interface JFHomeModel : QBEncryptedURLRequest

- (BOOL)fetchHomeInfoWithPage:(NSInteger)page CompletionHandler:(JFCompletionHandler)handler;

@end
