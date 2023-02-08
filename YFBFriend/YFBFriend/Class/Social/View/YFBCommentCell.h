//
//  YFBCommentCell.h
//  YFBFriend
//
//  Created by ZF on 2017/6/6.
//  Copyright © 2017年 ZF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBCommentView : UIView
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *timeStr;
@property (nonatomic) NSString *serverOption;
@property (nonatomic) NSString *commentStr;
@end

@interface YFBCommentCell : UITableViewCell
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *timeStr;
@property (nonatomic) NSString *serverOption;
@property (nonatomic) NSString *commentStr;
@end
