//
//  JYDynamicModel.m
//  JYFriend
//
//  Created by Liang on 2016/12/27.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYDynamicModel.h"

@implementation JYDynamicUrl

@end

@implementation JYDynamic

- (Class)moodUrlElementClass {
    return [JYDynamicUrl class];
}

- (void)saveOneDynamic {
    NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
    [self.moodUrl enumerateObjectsUsingBlock:^(JYDynamicUrl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = @{@"type":obj.type,
                              @"url":obj.url,
                              @"thumbnail":obj.thumbnail};
        [mutableArr addObject:dic];
    }];
    NSData *moodUrlsData = [NSJSONSerialization dataWithJSONObject:mutableArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:moodUrlsData encoding:NSUTF8StringEncoding];
    self.moodUrls = jsonStr;
    
    [self saveOrUpdate];
}

+ (void)saveAllTheDynamics {
    
}

+ (NSArray <JYDynamic *>*)allDynamics {
    NSArray *allDynamics = [self findByCriteria:@"order by timeInterval desc"];
    [allDynamics enumerateObjectsUsingBlock:^(JYDynamic *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSData *jsonData = [obj.moodUrls dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *responseArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [responseArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JYDynamicUrl *dynamicUrl = [[JYDynamicUrl alloc] init];
            dynamicUrl.type = obj[@"type"];
            dynamicUrl.url =  obj[@"url"];
            dynamicUrl.thumbnail = obj[@"thumbnail"];
            [array addObject:dynamicUrl];
        }];
        obj.moodUrl = [NSArray arrayWithArray:array];
    }];
    return allDynamics;
}

+ (NSArray *)transients {
    return @[@"moodUrl"];
}

@end



@implementation JYDynamicResponse

- (Class)moodListElementClass {
    return [JYDynamic class];
}

@end


@implementation JYDynamicModel

+ (Class)responseClass {
    return [JYDynamicResponse class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (BOOL)fetchDynamicInfoWithOffset:(NSUInteger)offset limit:(NSUInteger)limit completionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"userId":[JYUser currentUser].userId,
                             @"offset":@(offset),
                             @"limit":@(limit)};
    @weakify(self);
    BOOL success = [self requestURLPath:JY_DYNAMIC_URL
                         standbyURLPath:[JYUtil getStandByUrlPathWithOriginalUrl:JY_DYNAMIC_URL params:params]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        JYDynamicResponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                        }
                        if (handler) {
                            QBSafelyCallBlock(handler,respStatus == QBURLResponseSuccess,resp.moodList);
                        }
                    }];
    return success;
}

@end
