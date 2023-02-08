//
//  JYNearPersonCell.h
//  JYFriend
//
//  Created by ylz on 2016/12/22.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYNearPersonCell : UITableViewCell

@property (nonatomic) NSString *headerImageUrl;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *age;
@property (nonatomic,assign) JYUserSex sex;
//@property (nonatomic,assign) NSInteger distance;
@property (nonatomic,assign) NSInteger height;
@property (nonatomic,assign,getter=isVip) BOOL vip;
@property (nonatomic) NSString *detaiTitle;
@property (nonatomic) NSString *distance;
@end
