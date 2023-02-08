//
//  SAMineUserInfoCell.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAUserField : UITextField

@end

@interface SAMineUserInfoCell : UITableViewCell

@property (nonatomic,nullable) SAAction action;

@property (nonatomic,nonnull) NSString * title;

@property (nonatomic) BOOL textFieldResponder;

@property (nonatomic,nullable) NSString *content;

@end
