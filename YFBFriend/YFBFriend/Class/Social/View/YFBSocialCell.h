//
//  YFBSocialCell.h
//  YFBFriend
//
//  Created by ZF on 2017/6/6.
//  Copyright © 2017年 ZF. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFBCommentModel;

@interface YFBSocialCell : UITableViewCell
@property (nonatomic) YFBAction detailAction;
@property (nonatomic) YFBAction descAction;
@property (nonatomic) YFBAction wxAction;
@property (nonatomic) YFBAction payAction;
@property (nonatomic) YFBAction commentAction;

@property (nonatomic) NSString *userImgUrl;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSInteger serverCount;
@property (nonatomic) NSInteger serverRate;
@property (nonatomic) NSString *descStr;
@property (nonatomic) NSString *imgUrlA;
@property (nonatomic) NSString *imgUrlB;
@property (nonatomic) NSString *imgUrlC;
@property (nonatomic) YFBCommentModel *firstCommentModel;
@property (nonatomic) YFBCommentModel *secondCommentModel;
@property (nonatomic) BOOL needShowButton;
@property (nonatomic) BOOL showAllDesc;
@property (nonatomic) BOOL alreadyPay;
@property (nonatomic) QBAction clickImgAction;
@end
