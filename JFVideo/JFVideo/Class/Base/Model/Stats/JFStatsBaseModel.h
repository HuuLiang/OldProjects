//
//  JFStatsBaseModel.h
//  JFuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBNetworking/QBEncryptedURLRequest.h>

typedef NS_ENUM(NSUInteger, JFStatsType) {
    JFStatsTypeUnknown,
    JFStatsTypeColumnCPC,
    JFStatsTypeProgramCPC,
    JFStatsTypeTabCPC,
    JFStatsTypeTabPanning,
    JFStatsTypeTabStay,
    JFStatsTypeBannerPanning,
    JFStatsTypePay = 1000
};

typedef NS_ENUM(NSInteger, JFStatsNetwork) {
    JFStatsNetworkUnknown = 0,
    JFStatsNetworkWifi = 1,
    JFStatsNetwork2G = 2,
    JFStatsNetwork3G = 3,
    JFStatsNetwork4G = 4,
    JFStatsNetworkOther = -1
};

typedef NS_ENUM(NSUInteger, JFStatsCPCAction) {
    JFStatsCPCActionUnknown,
    JFStatsCPCActionProgramDetail,
    JFStatsCPCActionProgramPlaying
};

@interface JFStatsInfo : DBPersistence

// Unique ID
@property (nonatomic) NSNumber *statsId;

// System Info
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *pv;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *osv;

// Tab/Column/Program
@property (nonatomic) NSNumber *tabpageId;
@property (nonatomic) NSNumber *subTabpageId;
@property (nonatomic) NSNumber *columnId;
@property (nonatomic) NSNumber *columnType;
@property (nonatomic) NSNumber *programId;
@property (nonatomic) NSNumber *programType;
@property (nonatomic) NSNumber *programLocation;
@property (nonatomic) NSNumber *action;
@property (nonatomic) NSNumber *statsType; //JFStatsType

// Accumalation stats
@property (nonatomic) NSNumber *clickCount;
@property (nonatomic) NSNumber *slideCount;
@property (nonatomic) NSNumber *stopDuration;

// Payment
@property (nonatomic) NSNumber *isPayPopup;
@property (nonatomic) NSNumber *isPayPopupClose;
@property (nonatomic) NSNumber *isPayConfirm;
@property (nonatomic) NSNumber *payStatus;
@property (nonatomic) NSNumber *paySeq;
@property (nonatomic) NSString *orderNo;
@property (nonatomic) NSNumber *network; //JFStatsNetwork
//
+ (NSArray<JFStatsInfo *> *)allStatsInfos;
+ (NSArray<JFStatsInfo *> *)statsInfosWithStatsType:(JFStatsType)statsType;
+ (NSArray<JFStatsInfo *> *)statsInfosWithStatsType:(JFStatsType)statsType tabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex;
+ (void)removeStatsInfos:(NSArray<JFStatsInfo *> *)statsInfos;

- (BOOL)save;
- (BOOL)removeFromDB;
- (NSDictionary *)RESTData;
- (NSDictionary *)umengAttributes;

@end

@interface JFStatsResponse : QBURLResponse
@property (nonatomic) NSNumber *errCode;
@end

@interface JFStatsBaseModel : QBEncryptedURLRequest

- (NSArray<NSDictionary *> *)validateParamsWithStatsInfos:(NSArray<JFStatsInfo *> *)statsInfos;
- (NSArray<NSDictionary *> *)validateParamsWithStatsInfos:(NSArray<JFStatsInfo *> *)statsInfos shouldIncludeStatsType:(BOOL)includeStatsType;

@end
