//
//  JFChannelModel.m
//  JFVideo
//
//  Created by Liang on 16/7/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFChannelModel.h"

@implementation JFChannelModelResponse

- (Class)columnListElementClass {
    return [JFChannelColumnModel class];
}

@end

@implementation JFChannelModel

RequestTimeOutInterval

+ (Class)responseClass {
    return [JFChannelModelResponse class];
}

- (BOOL)fetchChannelInfoWithPage:(NSInteger)page CompletionHandler:(JFCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:JF_CHANNELRANKING_URL
                         standbyURLPath:[JFUtil getStandByUrlPathWithOriginalUrl:JF_CHANNELRANKING_URL params:nil]
                             withParams:nil
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        NSArray *array = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            JFChannelModelResponse *resp = self.response;
                            array = resp.columnList;
                        }
                        
                        if (handler) {
                            handler(respStatus==QBURLResponseSuccess, array);
                        }
                    }];
    
    return success;
}

@end
