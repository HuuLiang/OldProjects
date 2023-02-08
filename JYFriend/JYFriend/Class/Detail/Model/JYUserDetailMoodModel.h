//
//  JYUserDetailMoodModel.h
//  JYFriend
//
//  Created by ylz on 2017/1/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYUserDetailMood : NSObject
@property (nonatomic) NSNumber *type;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *thumbnail;

@end

@interface JYUserDetailMoodModel : NSObject

@property (nonatomic,retain) NSArray <JYUserDetailMood *> *moodUrl;
@property (nonatomic) NSString *text;

@end
