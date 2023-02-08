//
//  JQKChannelModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKChannelModel.h"

@implementation JQKChannelResponse

- (Class)columnListElementClass {
    return [JQKChannels class];
}

@end

@implementation JQKChannelModel

RequestTimeOutInterval

+ (Class)responseClass {
    return [JQKChannelResponse class];
}

+ (BOOL)shouldPersistURLResponse {
    return YES;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        JQKChannelResponse *resp = self.response;
        _fetchedChannels = resp.columnList;
    }
    return self;
}

- (BOOL)fetchChannelsWithCompletionHandler:(JQKFetchChannelsCompletionHandler)handler {
    @weakify(self);
   BOOL success = [self requestURLPath:JQK_HOME_CHANNEL_URL
                        standbyURLPath:[JQKUtil getStandByUrlPathWithOriginalUrl:JQK_HOME_CHANNEL_URL params:nil]
                        withParams:nil
                       responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
        @strongify(self);
        if (respStatus == QBURLResponseSuccess) {
            JQKChannelResponse *channelResp = (JQKChannelResponse *)self.response;
            self->_fetchedChannels = channelResp.columnList;
            
            if (handler) {
                handler(YES, self->_fetchedChannels);
            }
        } else {
            if (handler) {
                handler(NO, nil);
            }
        }

    }];
       return success;
}

@end
