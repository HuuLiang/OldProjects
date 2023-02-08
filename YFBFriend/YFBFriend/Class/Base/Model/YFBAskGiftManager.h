//
//  YFBAskGiftManager.h
//  YFBFriend
//
//  Created by Liang on 2017/4/21.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFBAskGiftManager : NSObject

+ (instancetype)manager;

- (void)startAutoBlagActionInViewController:(UIViewController *)viewController;

@end
