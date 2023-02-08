//
//  JFHomeModel.m
//  JFVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFHomeModel.h"

@implementation JFHomeModelResponse

- (Class)columnListElementClass {
    return [JFHomeColumnModel class];
}
@end

@implementation JFHomeModel
RequestTimeOutInterval

+ (Class)responseClass {
    return [JFHomeModelResponse class];
}


- (BOOL)fetchHomeInfoWithPage:(NSInteger)page CompletionHandler:(JFCompletionHandler)handler {
    @weakify(self);
    NSDictionary *params = @{@"page":@(page)};
    BOOL success = [self requestURLPath:JF_HOME_URL
                         standbyURLPath:[JFUtil getStandByUrlPathWithOriginalUrl:JF_HOME_URL params:nil]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        NSArray *array = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            JFHomeModelResponse *resp = self.response;
                            array = resp.columnList;
                        }
                        
                        if (handler) {
                            handler(respStatus==QBURLResponseSuccess, array);
                        }
                    }];
    
    return success;
}

@end
