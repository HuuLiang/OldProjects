//
//  JYNearPesonModel.h
//  JYFriend
//
//  Created by ylz on 2017/1/9.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
#import "JYUserInfoModel.h"
@class JYNearPerson;

typedef void(^JYNearPersonCompleteHander)(BOOL success , JYNearPerson * nearPersons);

@interface JYNearPerson : QBURLResponse

@property (nonatomic,retain) NSArray <JYUserInfoModel *>*programList;
@property (nonatomic) NSNumber *items;

@end


@interface JYNearPesonModel : QBEncryptedURLRequest

- (BOOL)fetchNearPersonModelWithPage:(NSInteger)page pageSize:(NSInteger)pageSize completeHandler:(JYNearPersonCompleteHander)handler;


@end
