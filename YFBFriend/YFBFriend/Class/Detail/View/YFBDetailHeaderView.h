//
//  YFBDetailHeaderView.h
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBDetailHeaderView : UIView

@property (nonatomic,copy) NSString *userImageUrl;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *userLocation;
@property (nonatomic,copy) NSString *distance;
@property (nonatomic) NSInteger albumCount;
@property (nonatomic) NSInteger followCount;

@property (nonatomic) YFBAction clickAction;

@end
