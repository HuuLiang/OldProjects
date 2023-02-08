//
//  JYChangeSignatureCell.h
//  JYFriend
//
//  Created by ylz on 2017/1/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYChangeSignatureCell : UITableViewCell

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *signature;
@property (nonatomic,copy)QBAction action;
@property (nonatomic,retain) UITextView *signatureView;;
@end
