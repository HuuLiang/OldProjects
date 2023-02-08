//
//  SAConfiguration.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAConfiguration : NSObject

@property (nonatomic,readonly) NSString *channelNo;

+ (instancetype)sharedConfig;
+ (instancetype)sharedStandbyConfig;

@end
