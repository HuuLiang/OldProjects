//
//  SAShareModel.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBDataResponse.h"

@interface SAShareColumnModel : NSObject
@property (nonatomic) NSString *columnId;
@property (nonatomic) NSString *name;
@end

@interface SAShareModel : QBDataResponse
@property (nonatomic) NSArray *columns;
@end
