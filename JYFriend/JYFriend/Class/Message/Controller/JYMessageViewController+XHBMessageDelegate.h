//
//  JYMessageViewController+XHBMessageDelegate.h
//  JYFriend
//
//  Created by Liang on 2016/12/29.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMessageViewController.h"

@interface JYMessageViewController (XHBMessageDelegate)

- (void)configEmotions;

- (void)registerCustomCell;

- (void)setXHShareMenu;

- (void)setupPopMenuTitles;
@end
