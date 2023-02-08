//
//  JFVideoPlayerController.h
//  JFVideo
//
//  Created by Liang on 16/6/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFBaseViewController.h"

@interface JFVideoPlayerController : JFBaseViewController

@property (nonatomic) NSString *videoUrl;

- (instancetype)initWithVideo:(NSString *)videoUrl;

@property (nonatomic,retain)JFBaseModel *baseModel;

@end
