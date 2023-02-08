//
//  JFHomeColumnModel.h
//  JFVideo
//
//  Created by Liang on 16/7/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBNetworking/QBEncryptedURLRequest.h>
#import "JFHomeProgramModel.h"

@interface JFHomeColumnModel : QBEncryptedURLRequest
@property (nonatomic) NSInteger columnId;
@property (nonatomic) NSInteger payPointType;
@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger realColumnId;
@property (nonatomic) NSInteger showNumber;
@property (nonatomic) NSString *spreadUrl;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSArray <JFHomeProgramModel *> *programList;
@end
