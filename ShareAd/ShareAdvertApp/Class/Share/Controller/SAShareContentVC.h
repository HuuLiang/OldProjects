//
//  SAShareContentVC.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SABaseViewController.h"

@protocol SAShareContentDelegate <NSObject>

- (void)observerContentScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)observerContentScrollViewBeginDragging:(UIScrollView *)scrollView;

@end

@interface SAShareContentVC : SABaseViewController

- (instancetype)initWithColumnId:(NSString *)columnId;

@property (nonatomic,weak) id <SAShareContentDelegate> delegate;

- (void)refreshContent;

@property (nonatomic) SAAction endRefresh;

@end
