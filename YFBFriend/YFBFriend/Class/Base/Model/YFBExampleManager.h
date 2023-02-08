//
//  YFBExampleManager.h
//  YFBFriend
//
//  Created by Liang on 2017/5/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBExampleResponse : QBURLResponse
@property (nonatomic) NSArray * diamondTplContList;
@property (nonatomic) NSArray * giftTplContList;
@property (nonatomic) NSArray * vipTplContList;
@end

@interface YFBExampleManager : QBEncryptedURLRequest
@property (nonatomic) NSArray *diamondExampleSource;
@property (nonatomic) NSArray *vipExampleSource;
@property (nonatomic) NSArray *giftExampleSource;
+ (instancetype)manager;
- (void)getExampleList;

@end
