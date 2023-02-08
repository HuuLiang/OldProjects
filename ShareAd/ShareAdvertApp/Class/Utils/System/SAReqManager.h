//
//  SAReqManager.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAReqManager : NSObject

+ (instancetype)manager;

/** 获取栏目列表 */
- (void)fetchColumnContentWithClass:(Class)modelClass CompletionHandler:(SACompletionHandler)handler;

/** 根据栏目id获取节目列表 */
- (void)fetchShareListWithColumnId:(NSString *)columnId class:(Class)modelClass handler:(SACompletionHandler)handler;

/** 激活 */
- (void)fetchActivateInfoWithClass:(Class)modelClass Handler:(SACompletionHandler)handler;

/** 注册 */
- (void)registerUserWithInfo:(SAUser *)userInfo class:(Class)modelClass handler:(SACompletionHandler)handler;

/** 修改密码 */
- (void)changePasswordWithInfo:(SAUser *)userInfo class:(Class)modelClass handler:(SACompletionHandler)handler;

/** 登录 */
- (void)loginWithPhontNumber:(NSString *)phone password:(NSString *)password class:(Class)modelClass handler:(SACompletionHandler)handler;

/** 配置 */
- (void)fetchConfigInfoClass:(Class)modelClass handler:(SACompletionHandler)handler;

/** 个人资料 */
- (void)fetchUserInfoWithUserId:(NSString *)userId class:(Class)modelClass handler:(SACompletionHandler)handler;

/** 更新个人资料 */
- (void)updateUserInfoWithInfo:(NSDictionary *)userInfo class:(Class)modelClass handler:(SACompletionHandler)handler;

/** 提现记录 */
- (void)fetchDrawMoenyStatusWithStatus:(NSString *)status Page:(NSInteger)page class:(Class)modelClass handler:(SACompletionHandler)handler;

/** 账户明细 */
- (void)fetchAccountDetailWithPage:(NSInteger)page class:(Class)modelClass handler:(SACompletionHandler)handler;

/** 排行榜 */
- (void)fetchRankingListWithType:(NSInteger)type class:(Class)modelClass handler:(SACompletionHandler)handler;

/** 账户金额信息 */
- (void)fetchUserAccountInfoWithClass:(Class)modelClass handler:(SACompletionHandler)handler;

/** 分享收益上传 */
- (void)updateShareBountyWithPrice:(NSInteger)amount shareId:(NSString *)shareId class:(Class)modelClass handler:(SACompletionHandler)handler;

/** 签到 */
- (void)signWithClass:(Class)modelClass handler:(SACompletionHandler)handler;

/** 提现 */
- (void)drwaMoneyWithAmount:(NSInteger)amount class:(Class)modelClass handler:(SACompletionHandler)handler;

/** 查询收徒信息 */
- (void)fetchRecruitInfoWithClass:(Class)modelClass hanler:(SACompletionHandler)handler;

@end
