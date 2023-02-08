//
//  YFBDiamondCell.h
//  YFBFriend
//
//  Created by Liang on 2017/3/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBDiamondCell : UITableViewCell
@property (nonatomic) NSString *desc;
@property (nonatomic) NSString *price;
@property (nonatomic) NSString *amount;
@property (nonatomic) YFBAction payAction;
@end
