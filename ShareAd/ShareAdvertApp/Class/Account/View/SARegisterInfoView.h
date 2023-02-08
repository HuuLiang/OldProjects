//
//  SARegisterInfoView.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SARegisterInfoView : UIView

@property (nonatomic,copy) SAAction _Nullable codeAction;

@property (nonatomic,readonly,nullable) NSString *phoneNumber;

@property (nonatomic,readonly,nullable) NSString *verifyCode;

@property (nonatomic,readonly,nullable) NSString *password;

@property (nonatomic,readonly,nullable) NSString *nickName;

@end
