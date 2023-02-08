//
//  SAVerifyCodeModel.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAVerifyCodeModel.h"
#import "QBDataManager.h"
#import "NSString+dataEncrypt.h"

@interface SAVerifyCodeModel () <QBEncryptionDelegate>

@end

@implementation SAVerifyCodeModel

- (void)fetchVerifyCodeWithPhoneNumber:(NSString *)phoneNumber class:(Class)modelClass handler:(SACompletionHandler)handler {
    [QBDataManager manager].delegate = self;

    NSDictionary *params = @{@"appId":SA_REST_APPID,
                             @"mobile":phoneNumber};
    
    [[QBDataManager manager] requestUrl:SA_VERIFYCODE_URL
                             withParams:params
                                  class:modelClass
                                handler:^(QBDataResponse * obj, NSError *error)
     {
         [QBDataManager manager].delegate = nil;
         handler([obj.code integerValue] == 200 ,nil);
     }];
}

#pragma mark - QBEncryptionDelegate

- (NSDictionary *)encryptedWithParams:(id)params {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    if (!jsonData) {
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *encryptedKey = [jsonString dataEncryptedWithPassword:[@"vc^verIfyC_2017&".md5 substringToIndex:16]];
    return @{@"data":encryptedKey};
}

- (id)decryptedWithResponseObject:(id)responseObject {
    NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}



@end
