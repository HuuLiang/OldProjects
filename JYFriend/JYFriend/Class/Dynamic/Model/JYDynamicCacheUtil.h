//
//  JYDynamicCacheUtil.h
//  JYFriend
//
//  Created by ylz on 2017/1/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYDynamicCacheModel :JKDBModel

@property (nonatomic,retain) NSArray <NSString *> *images;
@property (nonatomic) NSString *videoImage;
@property (nonatomic) NSString *videoPath;
@property (nonatomic) NSString *text;
@property (nonatomic) NSInteger timeInterval;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *userId;
@end


@interface JYDynamicCacheUtil : NSObject

+ (BOOL)saveUserDynamicWithUserState:(NSString *)userState imageUrls:(NSArray <UIImage *>*)imageUrls;
+ (BOOL)saveUserVideoDyanmicWithUserState:(NSString *)userState videoUrl:(NSURL *)videoUrl;
+ (JYDynamicCacheModel *)fetchCurrentUserDynamic;


@end
