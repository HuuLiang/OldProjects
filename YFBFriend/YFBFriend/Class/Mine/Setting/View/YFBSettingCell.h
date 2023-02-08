//
//  YFBSettingCell.h
//  YFBFriend
//
//  Created by Liang on 2017/3/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,YFBSettingCellType) {
    YFBSettingCellTypeNone = 0,
    YFBSettingCellTypeSwitch,
    YFBSettingCellTypeNotice
};

@interface YFBSettingCell : UITableViewCell

@property (nonatomic,copy) NSString *title;

@property (nonatomic,assign) YFBSettingCellType settingType;

@property (nonatomic,assign) BOOL functionOpen;

@end
