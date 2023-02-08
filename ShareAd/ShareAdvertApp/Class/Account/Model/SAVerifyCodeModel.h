//
//  SAVerifyCodeModel.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "QBDataResponse.h"

@interface SAVerifyCodeModel : QBDataResponse

/** 验证码 */
- (void)fetchVerifyCodeWithPhoneNumber:(NSString *)phoneNumber class:(Class)modelClass handler:(SACompletionHandler)handler;


@end
