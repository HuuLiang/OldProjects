//
//  JYLocalVideoUtils.h
//  JYFriend
//
//  Created by ylz on 2017/1/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYLocalVideoUrlPathModel : JKDBModel

@property (nonatomic) NSString *videoPath;

@end

@interface JYLocalVideoUtils : NSObject

+ (NSString *)currentTime;
+ (NSInteger)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
+ (NSString *)fetchTimeIntervalToCurrentTimeWithStartTime:(NSString *)startTime;

+ (UIImage *)getImage:(NSURL*)videoURL;//视频的第一帧图片
+ (CGFloat)getVideoLengthWithVideoUrl:(NSURL *)videoUrl ;
//+ (BOOL)writeToFileWithVideoUrl:(NSURL *)videoUrl;
+ (NSString *)writeToFileWithVideoUrl:(NSURL *)videoUrl needSaveVideoName:(BOOL)needSaveVideoName;
//+ (NSData *)getUserLocalVideoData;
//+ (NSString *)getUserLocalVideoPath;
+ (NSString *)getJYLocalVideoPathModelUserLocalVideoPath;
@end
