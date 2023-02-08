//
//  YFBMessageAdView.h
//  YFBFriend
//
//  Created by Liang on 2017/4/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBMessageAdView : UIView

@property (nonatomic) NSArray *recordsArr;
@property (nonatomic) BOOL scrollStart;

@end


@interface YFBMessageAdCell : UITableViewCell

@property (nonatomic) NSString *title;


@end
