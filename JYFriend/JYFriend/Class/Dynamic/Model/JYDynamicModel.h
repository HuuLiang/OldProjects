//
//  JYDynamicModel.h
//  JYFriend
//
//  Created by Liang on 2016/12/27.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>



@interface JYDynamicUrl : JKDBModel
@property (nonatomic) NSNumber *type;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *thumbnail;
@end

@interface JYDynamic : JKDBModel
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *logoUrl;
@property (nonatomic) NSString *sex;
@property (nonatomic) NSString *age;
@property (nonatomic) NSString *text;
@property (nonatomic) BOOL greet;
@property (nonatomic) BOOL follow;

@property (nonatomic) NSString *moodUrls;
@property (nonatomic) NSArray <JYDynamicUrl *> *moodUrl;
@property (nonatomic) NSInteger timeInterval;
@property (nonatomic) CGFloat  contentHeight;
@property (nonatomic) JYDynamicType dynamicType;


- (void)saveOneDynamic;
+ (void)saveAllTheDynamics;
+ (NSArray <JYDynamic *>*)allDynamics;


@end

@interface JYDynamicResponse : QBURLResponse
@property (nonatomic) NSArray <JYDynamic *> *moodList;
@end

@interface JYDynamicModel : QBEncryptedURLRequest

- (BOOL)fetchDynamicInfoWithOffset:(NSUInteger)offset limit:(NSUInteger)limit completionHandler:(QBCompletionHandler)handler;

@end
