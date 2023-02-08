//
//  SAShareContentCell.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAShareContentCell : UITableViewCell

@property (nonatomic) SAAction shareAction;

@property (nonatomic) NSString *imgUrl;
@property (nonatomic) NSString *specilTitle;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *price;
@property (nonatomic) NSString *read;

@end
