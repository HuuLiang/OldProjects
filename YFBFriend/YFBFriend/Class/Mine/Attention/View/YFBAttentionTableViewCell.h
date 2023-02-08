//
//  YFBAttentionTableViewCell.h
//  YFBFriend
//
//  Created by Liang on 2017/3/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBAttentionTableViewCell : UITableViewCell

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *headerUrl;
@property (nonatomic) NSInteger age;
@property (nonatomic) NSInteger photoCount;

@property (nonatomic,copy) YFBAction attentionAction;

@end
