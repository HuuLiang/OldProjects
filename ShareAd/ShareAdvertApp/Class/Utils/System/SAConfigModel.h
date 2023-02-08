//
//  SAConfigModel.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "QBDataResponse.h"

@interface SAConfigInfo : NSObject
@property (nonatomic) NSString *DRAW_CONFIG;
@property (nonatomic) NSString *AP_URL;
@property (nonatomic) NSString *AP_IMG;
@property (nonatomic) NSString *AP_TITLE;
@property (nonatomic) NSString *AP_SUBTITLE;
@property (nonatomic) NSString *SCROLLING;
@property (nonatomic) NSString *QQ;
@property (nonatomic) NSString *NOTICE;
@end

@interface SAConfigModel : QBDataResponse

+ (instancetype)defaultConfig;

@property (nonatomic) SAConfigInfo *config;

@end
