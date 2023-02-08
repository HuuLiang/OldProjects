//
//  SAShareContentModel.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "QBDataResponse.h"

@interface SAShareContentProgramModel : NSObject
@property (nonatomic) NSString *columnId;
@property (nonatomic) NSString *coverImg;
@property (nonatomic) NSString *shareId;
@property (nonatomic) NSString *readNumber;
@property (nonatomic) NSInteger shAmount;
@property (nonatomic) NSString *shUrl;
@property (nonatomic) NSString *title;

@end

@interface SAShareContentResponse : QBDataResponse
@property (nonatomic) NSArray <SAShareContentProgramModel *> *shares;
@end
