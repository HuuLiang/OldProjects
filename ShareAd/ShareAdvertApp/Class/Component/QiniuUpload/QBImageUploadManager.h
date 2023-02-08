//
//  QBImageUploadManager.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBImageUploadManager : NSObject

+ (void)registerWithSecretKey:(NSString *)secretKey accessKey:(NSString *)accessKey scope:(NSString *)scope;
+ (BOOL)uploadImage:(UIImage *)image
           withName:(NSString *)name
  completionHandler:(QBCompletionHandler)handler;

@end
