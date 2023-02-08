//
//  JFSystemConfig.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JFSystemConfig <NSObject>

@end

@interface JFSystemConfig : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *value;
@property (nonatomic) NSString *memo;
@property (nonatomic) NSString *channelNo;
@property (nonatomic) NSString *status;


@end
