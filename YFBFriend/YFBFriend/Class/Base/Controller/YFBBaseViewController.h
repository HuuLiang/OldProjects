//
//  YFBBaseViewController.h
//  YFBFriend
//
//  Created by Liang on 2017/2/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBBaseViewController : UIViewController

@property (nonatomic) BOOL alwaysHideNavigationBar;

- (instancetype)initWithTitle:(NSString *)title;

- (void)pushIntoDetailVC:(NSString *)userID;

- (void)pushIntoMessageVCWithUserId:(NSString *)userId nickName:(NSString *)nickName avatarUrl:(NSString *)avatarUrl;

- (void)pushIntoPayVC;

@end
