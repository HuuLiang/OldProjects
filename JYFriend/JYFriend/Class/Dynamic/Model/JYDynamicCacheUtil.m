//
//  JYDynamicCacheUtil.m
//  JYFriend
//
//  Created by ylz on 2017/1/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYDynamicCacheUtil.h"

#import "JYUserImageCache.h"
#import "JYLocalVideoUtils.h"


@implementation JYDynamicCacheModel


@end


@implementation JYDynamicCacheUtil

+ (BOOL)saveUserDynamicWithUserState:(NSString *)userState imageUrls:(NSArray <UIImage *>*)imageUrls {
   
    NSMutableArray *imageMd5s = [NSMutableArray arrayWithCapacity:imageUrls.count];
    if (imageUrls.count >0) {
        [imageUrls enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [imageMd5s addObject:[JYUserImageCache writeToFileWithImage:obj needSaveImageName:NO]];
        }];
    }
    
     JYDynamicCacheModel *model = [JYDynamicCacheModel findAll].firstObject;
    if (!model) {
        model = [[JYDynamicCacheModel alloc] init];
    }
        model.userId = kCurrentUser.userId;
        model.nickName = kCurrentUser.nickName;
        model.text = userState;
        model.timeInterval = [[JYUtil currentDate] timeIntervalSince1970];
        model.images = imageMd5s.copy;
        model.videoImage = nil;
        model.videoPath = nil;
        return [model saveOrUpdate];
}

+ (JYDynamicCacheModel *)fetchCurrentUserDynamic {

    return [JYDynamicCacheModel findAll].firstObject;
}

+ (BOOL)saveUserVideoDyanmicWithUserState:(NSString *)userState videoUrl:(NSURL *)videoUrl {
    UIImage *videoImage = [JYLocalVideoUtils getImage:videoUrl];
   NSString *videoImageMd5 = [JYUserImageCache writeToFileWithImage:videoImage needSaveImageName:NO];//先保存图片
    NSString *videoPath = [JYLocalVideoUtils writeToFileWithVideoUrl:videoUrl needSaveVideoName:NO];//保存视频,返回视频路径
    
    JYDynamicCacheModel *model = [JYDynamicCacheModel findAll].firstObject;
    if (!model) {
        model = [[JYDynamicCacheModel alloc] init];
    }
        model.userId = kCurrentUser.userId;
        model.nickName = kCurrentUser.nickName;
        model.text = userState;
        model.timeInterval = [[JYUtil currentDate] timeIntervalSince1970];
        model.videoImage = videoImageMd5;
        model.videoPath = videoPath;
        model.images = nil;
        return [model saveOrUpdate];

}



@end
