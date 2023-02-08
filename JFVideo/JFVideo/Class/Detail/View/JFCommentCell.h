//
//  JFCommentCell.h
//  JFVideo
//
//  Created by Liang on 16/6/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFCommentCell : UITableViewCell

- (instancetype)initWithHeight:(CGFloat)height;

@property (nonatomic) NSString *userImgUrl;
@property (nonatomic) NSString *userNameStr;
@property (nonatomic) NSString *commentStr;
@property (nonatomic) NSString *timeStr;

@end
