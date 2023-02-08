//
//  CMCRequestManager.m
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

#import "CMCRequestManager.h"
//#import "cmallcms-Swift.h"
/*
 ATS Test
 nscurl --ats-diagnostics --verbose https://service-app.ishaohuo.cn/
 
 nscurl --ats-diagnostics --verbose https://test-service-app.ishaohuo.cn/
 
 获取服务证书
 openssl s_client -connect service-app.ishaohuo.cn:443 /dev/null | openssl x509 -outform DER > https.cer
 
*/
//
//NSString * const AFAppDotNetAPIBaseURLString = @"https://test-cmall-b.ishaohuo.cn/";
//NSString * const CMallHTML5HostUrlString = @"http://test-cmall.ishaohuo.cn/";

//NSString * const AFAppDotNetAPIBaseURLString = @"https://pre-cmall-b.ishaohuo.cn/";
//NSString * const CMallHTML5HostUrlString = @"http://pre-cmall.ishaohuo.cn/";

NSString * const AFAppDotNetAPIBaseURLString = @"https://cmall-b.ishaohuo.cn/";
NSString * const CMallHTML5HostUrlString = @"http://cmall.ishaohuo.cn/";

@implementation CMCRequestManager

+ (instancetype)sharedClient {
    
    static CMCRequestManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CMCRequestManager alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
        
        if ([AFAppDotNetAPIBaseURLString hasPrefix:@"https://"]) {
            NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ishaohuo" ofType:@"cer"];
            NSData *certData = [NSData dataWithContentsOfFile:cerPath];
            // AFSSLPinningModeCertificate 使用证书验证模式
            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
            [securityPolicy setAllowInvalidCertificates:NO];
            NSSet *certDataSet = [[NSSet alloc] initWithObjects:certData, nil];
            [securityPolicy setPinnedCertificates:certDataSet];
            [securityPolicy setValidatesDomainName:YES];
            _sharedClient.securityPolicy = securityPolicy;
        }
        else {
            _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        }
        //[AFNetworkActivityIndicatorManager sharedManager].enabled = true;
    });
    
    return _sharedClient;
}


@end

@implementation NSMutableDictionary(RSA)
    
- (NSDictionary*)buildVersionParams {
    
    NSString *shortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [self setObject:shortVersion forKey:@"version"];
    NSTimeInterval timeInterval = [[[NSDate alloc] init] timeIntervalSince1970];
    NSString *timeIntervalString = [NSString stringWithFormat:@"%.0f",timeInterval];
    [self setObject:timeIntervalString forKey:@"time"];
    
    return self;
}


@end
