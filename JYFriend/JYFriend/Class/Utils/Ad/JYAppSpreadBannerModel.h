//
//  JYAppSpreadBannerModel.h
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBNetworking/QBEncryptedURLRequest.h>

@class JYAppSpread;

@interface JYAppResponse : QBURLResponse
@property(nonatomic)NSNumber *realColumnId;
@property (nonatomic)NSNumber *type;
@property (nonatomic) NSArray <JYAppSpread *> *programList;
@end

@interface JYAppSpreadBannerModel : QBEncryptedURLRequest
+ (instancetype)sharedModel;
@property (nonatomic,retain,readonly) NSMutableArray<JYAppSpread *> *fetchedSpreads;
- (BOOL)fetchAppSpreadWithCompletionHandler:(QBCompletionHandler)handler;
@property(nonatomic)NSNumber *realColumnId;
@property (nonatomic)NSNumber *type;
@end
