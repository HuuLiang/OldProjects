//
//  YFBSetAvatarView.h
//  YFBFriend
//
//  Created by Liang on 2017/3/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBSetAvatarView : UIView

- (instancetype)initWithFrame:(CGRect)frame action:(void (^)(void))handler;

@property (nonatomic,strong) UIImage *userImg;

@property (nonatomic,copy) NSString *imageUrl;
@end
