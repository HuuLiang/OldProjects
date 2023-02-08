//
//  JQKVideo.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/6.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JQKVideoSpec) {
    JQKVideoSpecNone,
    JQKVideoSpecHot,
    JQKVideoSpecNew,
    JQKVideoSpecHD
};

@interface JQKVideo : NSObject

@property (nonatomic) NSNumber *programId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *specialDesc;
@property (nonatomic) NSString *videoUrl;
@property (nonatomic) NSString *coverImg;
@property (nonatomic) NSNumber *spec;

@property (nonatomic) NSDate *playedDate; // for history 

+ (NSArray<JQKVideo *> *)allPlayedVideos;
//- (void)didPlay;


@end

