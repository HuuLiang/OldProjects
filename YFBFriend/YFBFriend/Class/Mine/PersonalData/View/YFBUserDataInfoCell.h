//
//  YFBUserDataInfoCell.h
//  YFBFriend
//
//  Created by Liang on 2017/3/21.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBUserDataInfoCell : UITableViewCell

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subTitle;

- (void)setDescTitle:(NSString *)descTitle font:(UIFont *)font;

@end
