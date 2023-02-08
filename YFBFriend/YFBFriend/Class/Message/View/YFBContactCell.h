//
//  YFBContactCell.h
//  YFBFriend
//
//  Created by Liang on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBContactCell : UITableViewCell
@property (nonatomic) NSString *userImgUrl;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSInteger recentTime;
@property (nonatomic) NSInteger msgType;
@property (nonatomic) NSString *content;
@property (nonatomic) NSInteger unreadMsg;
@property (nonatomic) BOOL isOneline;
@end
