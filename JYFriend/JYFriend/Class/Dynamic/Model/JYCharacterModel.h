//
//  JYCharacterModel.h
//  JYFriend
//
//  Created by Liang on 2017/1/11.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
#import "JKDBHelper.h"

@interface JYCharacter : JKDBModel
@property (nonatomic) NSString *logoUrl;
@property (nonatomic) NSNumber *age;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSInteger matchCount;
@property (nonatomic) BOOL isSelected;

@end

@interface JYCharacterResponse : QBURLResponse
@property (nonatomic) NSArray <JYCharacter *> *userList;
@end


@interface JYCharacterModel : QBEncryptedURLRequest
- (BOOL)fetchChararctersInfoWithRobotsCount:(NSInteger)count CompletionHandler:(QBCompletionHandler)handler;
- (BOOL)fetchFiguresWithPage:(NSInteger)page pageSize:(NSInteger)pageSize completeHandler:(QBCompletionHandler)handler;

@end
