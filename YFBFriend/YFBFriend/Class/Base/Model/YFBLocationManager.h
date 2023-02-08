//
//  YFBLocationManager.h
//  YFBFriend
//
//  Created by Liang on 2017/5/24.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFBLocationModel : JKDBModel
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *locationName;
@property (nonatomic) NSInteger locationTime;
@end

@interface YFBLocationManager : NSObject

+ (instancetype)manager;

- (BOOL)checkLocationIsEnable;

- (void)loadLocationManager;

- (void)getUserLacationNameWithUserId:(NSString *)userId locationName:(void(^)(BOOL success,NSString *locationName))handler;

@end
