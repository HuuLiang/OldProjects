//
//  JYContactCell.h
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell.h>

@interface JYContactCell : MGSwipeTableCell
@property (nonatomic) QBAction touchUserImgVAction;
@property (nonatomic) NSString *userImgStr;
@property (nonatomic) NSString *nickNameStr;
@property (nonatomic) NSString *recentTimeStr;
@property (nonatomic) NSString *recentMessage;
@property (nonatomic) NSUInteger unreadMessage;
@property (nonatomic) BOOL isStick;
@end
