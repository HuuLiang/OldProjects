//
//  JFDetailModel.m
//  JFVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFDetailModel.h"

@implementation JFDetailPhotoModel

@end


@implementation JFDetailProgramModel

@end


@implementation JFDetailCommentModel

@end


@implementation JFDetailModelResponse

- (Class)commentJsonElementClass {
    return [JFDetailCommentModel class];
}

- (Class)programUrlListElementClass {
    return [JFDetailPhotoModel class];
}

- (Class)programClass {
    return [JFDetailProgramModel class];
}

@end


@implementation JFDetailModel

RequestTimeOutInterval

+ (Class)responseClass {
    return [JFDetailModelResponse class];
}

- (BOOL)fetchProgramDetailWithColumnId:(NSInteger)columnId ProgramId:(NSInteger)programId CompletionHandler:(JFCompletionHandler)handler {
    NSDictionary *params = @{@"columnId":[NSString stringWithFormat:@"%ld",columnId],
                             @"programId":[NSString stringWithFormat:@"%ld",programId]};
    @weakify(self);
    BOOL success = [self requestURLPath:JF_DETAIL_URL
                         standbyURLPath:[JFUtil getStandByUrlPathWithOriginalUrl:JF_DETAIL_URL params:params]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        JFDetailModelResponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                        }
                        
                        if (handler) {
                            handler(respStatus==QBURLResponseSuccess, resp);
                        }
                    }];
    
    return success;
}

@end
