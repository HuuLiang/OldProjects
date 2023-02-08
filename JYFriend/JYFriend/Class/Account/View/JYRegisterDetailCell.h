//
//  JYRegisterDetailCell.h
//  JYFriend
//
//  Created by Liang on 2016/12/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JYDetailCellType) {
    JYDetailCellTypeContent,
    JYDetailCellTypeSelect
};

@interface JYRegisterDetailCell : UITableViewCell
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *content;

@property (nonatomic) JYDetailCellType cellType;
@property (nonatomic) QBAction sexSelected;
@end
