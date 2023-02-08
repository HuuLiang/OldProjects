//
//  JYSetAvatarView.h
//  JYFriend
//
//  Created by Liang on 2016/12/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYSetAvatarView : UIView

- (instancetype)initWithFrame:(CGRect)frame action:(void (^)(void))handler;

@property (nonatomic) UIImage *userImg;

@end
