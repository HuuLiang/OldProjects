//
//  JFChannelProgramModel.m
//  JFVideo
//
//  Created by Liang on 16/7/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFChannelProgramModel.h"

@implementation JFChannelProgram

@end

@implementation JFChannelProgramResponse

- (Class)programListElementClass {
    return [JFChannelProgram class];
}
@end

@implementation JFChannelProgramModel
RequestTimeOutInterval

+ (Class)responseClass {
    return [JFChannelProgramResponse class];
}

- (BOOL)fecthChannelProgramWithColumnId:(NSInteger)columnId Page:(NSInteger)page CompletionHandler:(JFCompletionHandler)handler {
    @weakify(self);
    NSDictionary *params = @{@"pageSize":[NSString stringWithFormat:@"%ld",page],
                             @"columnId":[NSString stringWithFormat:@"%ld",columnId]};
    BOOL success = [self requestURLPath:JF_PROGRAM_URL
                         standbyURLPath:[JFUtil getStandByUrlPathWithOriginalUrl:JF_PROGRAM_URL params:@[@(columnId),@(page)]]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        NSArray *array = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            JFChannelProgramResponse *resp = self.response;
                            array = resp.programList;
                        }
                        
                        if (handler) {
                            handler(respStatus==QBURLResponseSuccess, array);
                        }
                    }];
    
    return success;

}

@end
