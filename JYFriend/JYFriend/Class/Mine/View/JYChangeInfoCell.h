//
//  JYChangeInfoCell.h
//  JYFriend
//
//  Created by ylz on 2017/1/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYChangeInfoCell;

@protocol JYChangeInfoCellDelegate <NSObject>

- (void)JYChageInfoCell:(JYChangeInfoCell *)cell DidCancleEditingWithTextFiled:(UITextField *)textField;

@end

@interface JYChangeInfoCell : UITableViewCell

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *userInfo;

@property (nonatomic,retain) UITextField *textField;
//@property (nonatomic) BOOL cancleEditing;

@property (nonatomic,weak)id<JYChangeInfoCellDelegate>delegate;

@end
