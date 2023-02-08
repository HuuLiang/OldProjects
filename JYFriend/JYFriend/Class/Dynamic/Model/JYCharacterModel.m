//
//  JYCharacterModel.m
//  JYFriend
//
//  Created by Liang on 2017/1/11.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYCharacterModel.h"

@implementation JYCharacter

- (BOOL)isSelected {
    return YES;
}

+ (NSArray *)transients {
    return @[@"isSelected",@"age"];
}

@end


@implementation JYCharacterResponse
- (Class)userListElementClass {
    return [JYCharacter class];
}
@end


@implementation JYCharacterModel

+ (Class)responseClass {
    return [JYCharacterResponse class];
}

-(QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (BOOL)fetchChararctersInfoWithRobotsCount:(NSInteger)count CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"userId":[JYUser currentUser].userId,
                             @"number":@(count)};
    
    BOOL success = [self requestURLPath:JY_CHARACTER_URL
                         standbyURLPath:[JYUtil getStandByUrlPathWithOriginalUrl:JY_CHARACTER_URL params:params]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        JYCharacterResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        
        if (handler) {
            QBSafelyCallBlock(handler,respStatus == QBURLResponseSuccess,resp.userList);
        }
    }];
    return success;
}

- (BOOL)fetchFiguresWithPage:(NSInteger)page pageSize:(NSInteger)pageSize completeHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"userId" : [JYUtil userId] ? : @"",
                             @"page" : @(page),
                             @"pageSize" : @(pageSize)};
    BOOL result = [self requestURLPath:JY_CHARACTER_FIGURE_URL
                        standbyURLPath:JY_CHARACTER_FIGURE_URL
                            withParams:params responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
         JYCharacterResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,resp.userList);
        }
        
    }];
    return result;
}

@end
