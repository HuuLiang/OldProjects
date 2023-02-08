//
//  YFBDiscoverModel.h
//  YFBFriend
//
//  Created by Liang on 2017/4/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>
@class YFBRobot;

@interface YFBRmdNearByDtoModel : NSObject
@property (nonatomic) NSInteger pageCount;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSArray <YFBRobot *>*userList;
@end

@interface YFBDiscoverResponse : QBURLResponse
@property (nonatomic) NSArray <YFBRobot * >*realEvalUserList;
@property (nonatomic) YFBRmdNearByDtoModel *rmdNearbyDto;
@end

@interface YFBDiscoverModel : QBEncryptedURLRequest
- (BOOL)fetchUserInfoWithType:(NSString *)type pageNum:(NSInteger)pageNum CompletionHandler:(void(^)(BOOL success , NSArray <YFBRobot *> *realEvalUserList, YFBRmdNearByDtoModel *rmdNearbyDto))handler;
@end


extern NSString *const kYFBFriendDiscoverRecommendKeyName;
extern NSString *const kYFBFriendDiscoverNearbyKeyName;
