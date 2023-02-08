//
//  JYNextButton.h
//  JYFriend
//
//  Created by Liang on 2016/12/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYNextButton : UIButton

//- (instancetype)initWithTitle:(NSString *)title action:(QBAction)action;

- (instancetype)initWithTitle:(NSString *)title action:(void (^)(void))handler;

@end
