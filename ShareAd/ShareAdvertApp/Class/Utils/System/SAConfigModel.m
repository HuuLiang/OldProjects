//
//  SAConfigModel.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAConfigModel.h"

@implementation SAConfigInfo

@end

@implementation SAConfigModel

+ (instancetype)defaultConfig {
    static SAConfigModel *_configModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _configModel = [[SAConfigModel alloc] init];
    });
    return _configModel;
}

- (Class)configClass {
    return [SAConfigInfo class];
}

@end
