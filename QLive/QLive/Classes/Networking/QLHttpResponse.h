//
//  QLHttpResponse.h
//  QLive
//
//  Created by Sean Yue on 2017/3/6.
//  Copyright © 2017年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLHttpResponse : NSObject

@property (nonatomic) NSNumber *code;

- (BOOL)success;

@end