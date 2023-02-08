//
//  JYMD5Utils.h
//  JYFriend
//
//  Created by ylz on 2016/12/29.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYMD5Utils : NSObject

////计算NSData 的MD5值
//+(NSString*)getMD5WithData:(NSData*)data;

//计算字符串的MD5值，
+(NSString*)getmd5WithString:(NSString*)string;

//计算大文件的MD5值
+(NSString*)getFileMD5WithPath:(NSString*)path;


+(NSString *)md5Data:(NSData *)sourceData;//md5data加密

@end
