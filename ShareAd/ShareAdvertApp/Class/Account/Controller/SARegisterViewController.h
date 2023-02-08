//
//  SARegisterViewController.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SABaseViewController.h"

typedef NS_ENUM(NSInteger,SARegisterType) {
    SARegisterTypeRegister,
    SARegisterTypeForgot
};

@interface SARegisterViewController : SABaseViewController

@property (nonatomic) SARegisterType type;

@end
