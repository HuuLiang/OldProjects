//
//  JFDetailViewController.h
//  JFVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFLayoutViewController.h"

@interface JFDetailViewController : JFLayoutViewController

@property (nonatomic,retain)JFBaseModel *baseModel;
- (instancetype)initWithColumnId:(NSInteger)columnId ProgramId:(NSInteger)programId;

@end
