//
//  JFChannelColumnModel.h
//  JFVideo
//
//  Created by Liang on 16/7/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "JFChannelProgramModel.h"

@interface JFChannelColumnModel : NSObject
@property (nonatomic) NSInteger columnId;
@property (nonatomic) NSString *columnImg;
//@property (nonatomic) NSInteger payPointType;
@property (nonatomic) NSString *columnDesc;
@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger realColumnId;
@property (nonatomic) NSInteger showNumber;
@property (nonatomic) NSString *spreadUrl;
@property (nonatomic) NSInteger type;
//@property (nonatomic) NSArray <JFChannelProgramModel *> *programList;
@end
