//
//  JYDynamicCell.h
//  JYFriend
//
//  Created by Liang on 2016/12/27.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^dynamicPhototBrowser)(BOOL isVideo,NSInteger index);

@interface JYDynamicCell : UICollectionViewCell

//- (void)updateCellContentWithInfo:(JYDynamic *)dynamic;

@property (nonatomic) NSString *logoUrl;
@property (nonatomic) NSString *nickName;
@property (nonatomic) JYUserSex userSex;
@property (nonatomic) NSString * age;
@property (nonatomic) BOOL isFocus;
@property (nonatomic) BOOL isGreet;
@property (nonatomic) NSInteger timeInterval;
@property (nonatomic) NSString *content; 

@property (nonatomic) JYDynamicType dynamicType;
@property (nonatomic) NSArray *moodUrl;

@property (nonatomic) QBAction buttonAction;

@property (nonatomic) QBAction userImgAction;

@property (nonatomic) dynamicPhototBrowser photoBrowser;

@end
