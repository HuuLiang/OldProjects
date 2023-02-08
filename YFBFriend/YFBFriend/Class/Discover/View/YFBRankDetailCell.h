//
//  YFBRankDetailCell.h
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBRankDetailCell : UITableViewCell
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) NSString *userImageUrl;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic) YFBUserSex userSex;
@property (nonatomic,copy) NSString *age;
@property (nonatomic,copy) NSString *distance;
@property (nonatomic) YFBRankType rankType;
@property (nonatomic) NSInteger giftCount;
@end
