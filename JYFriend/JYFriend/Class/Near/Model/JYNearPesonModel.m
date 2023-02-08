//
//  JYNearPesonModel.m
//  JYFriend
//
//  Created by ylz on 2017/1/9.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYNearPesonModel.h"

@implementation JYNearPerson

- (Class)programListElementClass {
    return [JYUserInfoModel class];
}

@end


@implementation JYNearPesonModel

+ (Class)responseClass {
    return [JYNearPerson class];
}

- (QBURLRequestMethod)requestMethod {

    return QBURLPostRequest;
}

- (BOOL)fetchNearPersonModelWithPage:(NSInteger)page pageSize:(NSInteger)pageSize completeHandler:(JYNearPersonCompleteHander)handler{
    NSDictionary *params = @{@"page" : @(page),
                             @"pageSize" : @(pageSize)
                             };
    BOOL result = [self requestURLPath:JY_NEAR_PERSON_URL standbyURLPath:nil withParams:params responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
        
        JYNearPerson *persons;
        if (respStatus == QBURLResponseSuccess) {
            persons = self.response;
        }
        
        if (handler) {
            handler(respStatus == QBURLResponseSuccess , persons);
        }
    }];
    
    return result;
}

@end
