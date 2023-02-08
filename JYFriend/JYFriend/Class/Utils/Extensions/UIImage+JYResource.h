//
//  UIImage+QBResource.h
//  Pods
//
//  Created by Sean Yue on 16/7/1.
//
//

#import <Foundation/Foundation.h>

@interface UIImage (JYResource)

+ (instancetype)JY_imageWithResourcePath:(NSString *)imagePath; // ofType = @"png"
+ (instancetype)JY_imageWithResourcePath:(NSString *)imagePath ofType:(NSString *)type;

@end
