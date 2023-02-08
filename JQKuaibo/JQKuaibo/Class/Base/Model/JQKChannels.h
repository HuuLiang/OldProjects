//
//  Channel.h
//  JQKuaibo
//
//  Created by ylz on 16/6/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBURLResponse.h"

typedef NS_ENUM(NSUInteger, JQKChannelType) {
    JQKChannelTypeNone = 0,
    JQKChannelTypeVideo = 1,
    JQKChannelTypePicture = 2,
    JQKChannelTypeSpread = 3
};

@interface JQKChannels : QBURLResponse

@property (nonatomic) NSNumber *columnId;
@property (nonatomic) NSNumber *realColumnId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *columnDesc;
@property (nonatomic) NSString *columnImg;
@property (nonatomic) NSString *spreadUrl;
@property (nonatomic) NSNumber *type;// 1、视频 2、图片
@property (nonatomic) NSNumber *showNumber;
@property (nonatomic) NSNumber *items;
@property (nonatomic) NSNumber *page;
@property (nonatomic) NSNumber *pageSize;
@property (nonatomic,retain) NSArray<JQKProgram *> *programList;

@end
