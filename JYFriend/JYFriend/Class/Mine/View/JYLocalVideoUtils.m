//
//  JYLocalVideoUtils.m
//  JYFriend
//
//  Created by ylz on 2017/1/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYLocalVideoUtils.h"
#import "JYUserImageCache.h"


// static NSString *const kUserLocalVideoFiles = @"JYUserVideo.";
 static NSString *const kUserLocalVideoType = @"uer_localvideo_type_key";
 static NSString *const kTimeFormat = @"yyyy-MM-dd HH:mm:ss";

@implementation JYLocalVideoUrlPathModel


@end


@implementation JYLocalVideoUtils

+ (NSString *)currentTime {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kTimeFormat];
    return  [dateFormatter stringFromDate:currentDate];
    
}

+ (NSInteger)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:kTimeFormat];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    return value;
}

+ (NSString *)fetchTimeIntervalToCurrentTimeWithStartTime:(NSString *)startTime{
    if (!startTime) {
        return nil;
    }
    startTime = [JYUtil timeStringFromDate:[JYUtil dateFromString:startTime WithDateFormat:@"yyyy年MM月dd日 HH:mm:ss"] WithDateFormat:kTimeFormat];
    NSString *currentTime = [self currentTime];
    
   NSInteger timeInterVal = [self dateTimeDifferenceWithStartTime:startTime endTime:currentTime];
    NSInteger month = timeInterVal / (D_DAY*30);
    NSInteger week = timeInterVal / D_WEEK;
    NSInteger day = timeInterVal / D_DAY;
    NSInteger hour = timeInterVal / D_HOUR;
    NSInteger minute = timeInterVal / D_MINUTE;
    
    if (month > 0) {
        return [NSString stringWithFormat:@"%zd月前",month];
    }else if (week > 0) {
        return [NSString stringWithFormat:@"%zd周前",week];
    }else if (day > 0) {
        return [NSString stringWithFormat:@"%zd天前",day];
    }else if (hour > 0) {
        return [NSString stringWithFormat:@"%zd小时前",hour];
    }else if (minute > 0) {
        return [NSString stringWithFormat:@"%zd分前",minute];
    }else if (timeInterVal > 0){
        return [NSString stringWithFormat:@"%zd秒前",timeInterVal];
    }
    return nil;
}

+ (UIImage *)getImage:(NSURL*)videoURL

{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
    
}


+ (CGFloat)getVideoLengthWithVideoUrl:(NSURL *)videoUrl {
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:videoUrl options:nil];
    
    CMTime audioDuration = audioAsset.duration;
    
    float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
    
    return audioDurationSeconds;
}

+ (NSData *)videoDataWithVideo:(NSURL *)videoUrl {
    
    return [[NSData alloc] initWithContentsOfURL:videoUrl];
}

+ (NSString *)writeToFileWithVideoUrl:(NSURL *)videoUrl needSaveVideoName:(BOOL)needSaveVideoName{
    
    NSData *data = [self videoDataWithVideo:videoUrl];
    
    NSString *boxFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *type = [videoUrl.absoluteString componentsSeparatedByString:@"."].lastObject;
    NSString *videoPath = [boxFile stringByAppendingPathComponent:[JYUserImageCache writeToFileWithImage:[self getImage:videoUrl] needSaveImageName:NO]];
    NSString *newVideoPath =  [videoPath stringByAppendingFormat:@".%@",type];
//    [[NSUserDefaults standardUserDefaults] setObject:type forKey:kUserLocalVideoType];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    if (needSaveVideoName) {
       JYLocalVideoUrlPathModel *model = [JYLocalVideoUrlPathModel findAll].firstObject;
        if (!model) {
      
            model = [[JYLocalVideoUrlPathModel alloc] init];
        }
            model.videoPath = newVideoPath;
            [model saveOrUpdate];
    }
    
    [data writeToFile:newVideoPath atomically:YES];
    return newVideoPath;
}

//+ (NSData *)getUserLocalVideoData {
//    NSString *boxFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//    NSString *videoPath = [boxFile stringByAppendingPathComponent:kUserLocalVideoFiles];
//    NSData *videoData = [NSData dataWithContentsOfFile:videoPath];
//    return videoData;
//}

+ (NSString *)getJYLocalVideoPathModelUserLocalVideoPath{
//    NSString *boxFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//    NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:kUserLocalVideoType];
//    NSString *videoPath = [boxFile stringByAppendingPathComponent:kUserLocalVideoFiles];
//    NSString *newVideoPath =  [videoPath stringByAppendingString:type];
//    
//    return currentVideoPath;
    JYLocalVideoUrlPathModel *model = [JYLocalVideoUrlPathModel findAll].firstObject;
    return model.videoPath;
    
}


@end
