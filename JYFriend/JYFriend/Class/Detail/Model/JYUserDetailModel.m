//
//  JYUserDetailModel.m
//  JYFriend
//
//  Created by ylz on 2017/1/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYUserDetailModel.h"

@implementation JYUserVideo

@end

@implementation JYUserPhoto

@end

@implementation JYUserDetail

-(Class)userPhotoElementClass {
    return [JYUserPhoto class];
}

-(Class)userVideoClass {
    return [JYUserVideo class];
}

-(Class)userClass {
    return [JYUserInfoModel class];
}

- (Class)moodClass {
    return [JYUserDetailMoodModel class];
}

@end

@implementation JYUserDetailModel

+ (Class)responseClass {
    return [JYUserDetail class];
}

- (BOOL)fetchUserDetailModelWithViewUserId:(NSString *)viewUserId CompleteHandler:(JYUserDetailCompleteHandler)handler {
    @weakify(self);
    NSDictionary *params = @{@"viewUserId" : viewUserId ? : @"",
                             @"userId" : [JYUser currentUser].userId ? : @""
                             };
    BOOL result = [self requestURLPath:JY_USER_DETAIL_URL standbyURLPath:nil withParams:params responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
        @strongify(self);
        if (respStatus == QBURLResponseSuccess) {
            JYUserDetail *detail = self.response;
            self.userPhoto = detail.userPhoto;
            self.userInfo = detail.user;
            self.userVideo = detail.userVideo;
            self.mood = detail.mood;
            self.greet = detail.greet;
            self.follow = detail.follow;
        }
        if (handler) {
            handler(respStatus == QBURLResponseSuccess , self.response);
        }
    }];
    return result;
}

@end
