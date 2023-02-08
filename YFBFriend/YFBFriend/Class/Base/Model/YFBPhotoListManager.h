//
//  YFBPhotoListManager.h
//  YFBFriend
//
//  Created by Liang on 2017/4/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

typedef NS_ENUM(NSInteger, YFBPhotoStatusType) {
    YFBPhotoStatusTypeUnknown = 0,
    YFBPhotoStatusTypeCheck,
    YFBPhotoStatusTypePost
};

@interface YFBPhoto : NSObject
@property (nonatomic) NSString *photoUrl;
@property (nonatomic) YFBPhotoStatusType sts;
@end

@interface YFBPhotoListResponse : QBURLResponse
@property (nonatomic) NSArray <YFBPhoto *> * userPhotoList;
@end

@interface YFBPhotoListManager : QBEncryptedURLRequest

+ (instancetype)manager;

- (BOOL)fetchPhotoListWithCompletionHandler:(QBCompletionHandler)handler;

- (BOOL)savePhotoWithUrl:(NSString *)url CompletionHandler:(QBCompletionHandler)handler;

@end
