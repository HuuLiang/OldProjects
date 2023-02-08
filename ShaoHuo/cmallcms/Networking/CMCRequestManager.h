//
//  CMCRequestManager.h
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


extern NSString * const AFAppDotNetAPIBaseURLString;
extern NSString * const CMallHTML5HostUrlString;

@interface CMCRequestManager : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end

@interface NSMutableDictionary(RSA)

- (NSDictionary*)buildVersionParams;


@end
