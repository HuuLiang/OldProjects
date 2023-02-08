//
//  YFBRecommendCell.h
//  YFBFriend
//
//  Created by Liang on 2017/3/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBRecommendCell : UITableViewCell

@property (nonatomic,copy)   NSString *userImgUrl;
@property (nonatomic,copy)   NSString *userNameStr;
@property (nonatomic,assign) YFBUserSex   userSex;
@property (nonatomic,copy)   NSString * userAge;
@property (nonatomic)   NSInteger  userHeight;
@property (nonatomic,copy)   NSString *cityStr;
@property (nonatomic,assign) BOOL greeted;
@property (nonatomic) NSString *userId;
@property (nonatomic)   CGFloat distance;

@property (nonatomic,copy) QBAction greeting;

@end
