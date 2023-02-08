//
//  JFHomeColumnModel.m
//  JFVideo
//
//  Created by Liang on 16/7/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFHomeColumnModel.h"

@implementation JFHomeColumnModel
- (Class)programListElementClass {
    return [JFHomeProgramModel class];
}
@end
