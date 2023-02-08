//
//  YFBBlagGiftView.h
//  YFBFriend
//
//  Created by Liang on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBBlagGiftView : UIView
@property (nonatomic) NSString *headerImageUrl;
@property (nonatomic) NSString *sendTitle;
@property (nonatomic) NSString *sendSubTitle;
@property (nonatomic,copy) QBAction closeAction;

- (void)startSelectedDefaultIndexPath;

@property (nonatomic) NSInteger diamondCount;
@property (nonatomic,copy) YFBAction payAction;
@property (nonatomic,copy) QBAction sendGiftAction;

@end
