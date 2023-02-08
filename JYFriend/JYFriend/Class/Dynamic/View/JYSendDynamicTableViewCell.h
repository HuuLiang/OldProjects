//
//  JYSendDynamicTableViewCell.h
//  JYFriend
//
//  Created by ylz on 2017/1/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYTextView.h"

typedef void(^JYCollectionAction)(UIImage *image , NSIndexPath *indexPath,BOOL isAddPhoto);

typedef NS_ENUM(NSUInteger, JYSendModelType) {
    JYSendModelTypeVideo = 1,
    JYSendModelTypePicture = 2
    
};

@interface JYSendDynamaicModel : NSObject //
@property (nonatomic) UIImage *image;
@property (nonatomic) JYSendModelType type;
@property (nonatomic) NSURL *videoUrl;
@end

@interface JYSendDynamicTableViewCell : UITableViewCell

@property (nonatomic,retain) UIViewController *curentVC;
@property (nonatomic,copy)QBAction collectAction;
@property (nonatomic,retain) UITabBar *tabBar;
@property (nonatomic,retain) JYTextView *textView;
@end
