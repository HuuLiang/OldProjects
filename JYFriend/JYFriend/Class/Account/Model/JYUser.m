//
//  JYUser.m
//  JYFriend
//
//  Created by Liang on 2016/12/23.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYUser.h"

static JYUser *_currentUser;

@implementation JYUser

+ (instancetype)currentUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentUser = [self findFirstByCriteria:[NSString stringWithFormat:@"WHERE isHuman=%d",YES]];
        if (!_currentUser) {
            _currentUser = [[self alloc] init];
            _currentUser.isHuman = YES;
            [_currentUser saveOrUpdate];
        }
    });
    return _currentUser;
}

+ (NSArray *)allUserHeights {
    NSMutableArray *allHeights = [NSMutableArray array];
    for (NSInteger height = 150; height <= 200; height++) {
        NSString *str = [NSString stringWithFormat:@"%ldcm",(long)height];
        [allHeights addObject:str];
    }
    return allHeights;
}

+ (NSMutableDictionary *)allProvincesAndCities {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"provinces" ofType:@"plist"];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    return dataDic;
}

+ (NSArray *)defaultHometown {
    NSMutableArray *hometown = [NSMutableArray array];
    NSDictionary *allProvincesAndCities = [self allProvincesAndCities];
    [hometown addObject:allProvincesAndCities.allKeys];
    [hometown addObject:[allProvincesAndCities objectForKey:[allProvincesAndCities.allKeys firstObject]][@"city"]];
    return hometown;
}

+ (NSArray *)allCitiesWihtProvince:(NSString *)province {
    NSArray *allCities = [self allProvincesAndCities][province][@"city"];
    return allCities;
}
@end
