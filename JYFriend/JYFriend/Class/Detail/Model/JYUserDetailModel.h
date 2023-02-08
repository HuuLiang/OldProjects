//
//  JYUserDetailModel.h
//  JYFriend
//
//  Created by ylz on 2017/1/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
#import "JYUserInfoModel.h"
#import "JYUserDetailMoodModel.h"
@class JYUserDetail;

typedef void(^JYUserDetailCompleteHandler)(BOOL success , JYUserDetail *useDetai);

@interface JYUserPhoto : NSObject
@property (nonatomic) NSString *smallPhoto;//缩略图
@property (nonatomic) NSString *bigPhoto;

@end

@interface JYUserVideo : NSObject
@property (nonatomic) NSString *imgCover;
@property (nonatomic) NSString *videoUrl;
@end


@interface JYUserDetail : QBURLResponse

@property (nonatomic,retain) NSArray <JYUserPhoto *> *userPhoto;
@property (nonatomic,retain) JYUserVideo *userVideo;
@property (nonatomic,retain) JYUserInfoModel *user;
@property (nonatomic,retain) JYUserDetailMoodModel *mood;
@property (nonatomic) BOOL greet; //是否打招呼
@property (nonatomic) BOOL follow; //是否关注

@end

@interface JYUserDetailModel : QBEncryptedURLRequest

//@property (nonatomic,retain) JYUserDetail *userDetail;
@property (nonatomic,retain) NSArray <JYUserPhoto *> *userPhoto;
@property (nonatomic,retain) JYUserVideo *userVideo;
@property (nonatomic,retain) JYUserInfoModel *userInfo;
@property (nonatomic,retain) JYUserDetailMoodModel *mood;
@property (nonatomic) BOOL greet; //是否打招呼
@property (nonatomic) BOOL follow; //是否关注

- (BOOL)fetchUserDetailModelWithViewUserId:(NSString *)viewUserId CompleteHandler:(JYUserDetailCompleteHandler)handler;

@end
