//
//  JFStatsManager.m
//  JFuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFStatsManager.h"
#import "JFCPCStatsModel.h"
#import "JFTabStatsModel.h"
#import "JFPayStatsModel.h"
#import "MobClick.h"
#import <QBPayment/QBPaymentInfo.h>


static NSString *const kUmengCPCChannelEvent = @"CPC_CHANNEL";
static NSString *const kUmengCPCProgramEvent = @"CPC_PROGRAM";
static NSString *const kUmengTabEvent = @"TAB_STATS";
static NSString *const kUmengPayEvent = @"PAY_STATS";

@interface JFStatsManager ()
@property (nonatomic,retain) dispatch_queue_t queue;
@property (nonatomic,retain,readonly) JFCPCStatsModel *cpcStats;
@property (nonatomic,retain,readonly) JFTabStatsModel *tabStats;
@property (nonatomic,retain,readonly) JFPayStatsModel *payStats;
@property (nonatomic,retain,readonly) NSDate *statsDate;
@property (nonatomic)BOOL scheduling;
@end

@implementation JFStatsManager
@synthesize cpcStats = _cpcStats;
@synthesize tabStats = _tabStats;
@synthesize payStats = _payStats;

DefineLazyPropertyInitialization(JFCPCStatsModel, cpcStats)
DefineLazyPropertyInitialization(JFTabStatsModel, tabStats)
DefineLazyPropertyInitialization(JFPayStatsModel, payStats)

- (dispatch_queue_t)queue {
    if (_queue) {
        return _queue;
    }
    
    _queue = dispatch_queue_create("com.JFuaibo.app.statsq", nil);
    return _queue;
}

+ (instancetype)sharedManager {
    static JFStatsManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _statsDate = [NSDate date];
    }
    return self;
}

- (void)addStats:(JFStatsInfo *)statsInfo {
    dispatch_async(self.queue, ^{
        [statsInfo save];
    });
}

- (void)removeStats:(NSArray<JFStatsInfo *> *)statsInfos {
    dispatch_async(self.queue, ^{
        [JFStatsInfo removeStatsInfos:statsInfos];
    });
}

- (void)scheduleStatsUploadWithTimeInterval:(NSTimeInterval)timeInterval {
    if (self.scheduling) {
        return;
    }
    self.scheduling = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        while (1) {
            dispatch_async(self.queue, ^{
                [self uploadStatsInfos:[JFStatsInfo allStatsInfos]];
            });
            sleep(timeInterval);
        }
    });
}

- (void)uploadStatsInfos:(NSArray<JFStatsInfo *> *)statsInfos {
    if (statsInfos.count == 0) {
        return ;
    }
    
    NSArray<JFStatsInfo *> *cpcStats = [statsInfos bk_select:^BOOL(JFStatsInfo *statsInfo) {
        return statsInfo.statsType.unsignedIntegerValue == JFStatsTypeColumnCPC
        || statsInfo.statsType.unsignedIntegerValue == JFStatsTypeProgramCPC;
    }];
    
    NSArray<JFStatsInfo *> *tabStats = [statsInfos bk_select:^BOOL(JFStatsInfo *statsInfo) {
        return statsInfo.statsType.unsignedIntegerValue == JFStatsTypeTabCPC
        || statsInfo.statsType.unsignedIntegerValue == JFStatsTypeTabPanning
        || statsInfo.statsType.unsignedIntegerValue == JFStatsTypeTabStay
        || statsInfo.statsType.unsignedIntegerValue == JFStatsTypeBannerPanning;
    }];
    
    NSArray<JFStatsInfo *> *payStats = [statsInfos bk_select:^BOOL(JFStatsInfo *statsInfo) {
        return statsInfo.statsType.unsignedIntegerValue == JFStatsTypePay;
    }];
    
    if (cpcStats.count > 0) {
        DLog(@"Commit CPC stats...");
        [self.cpcStats statsCPCWithStatsInfos:cpcStats completionHandler:^(BOOL success, id obj) {
            if (success) {
                [JFStatsInfo removeStatsInfos:cpcStats];
                DLog(@"Commit CPC stats successfully!");
            } else {
                DLog(@"Commit CPC stats with failure: %@", obj);
            }
        }];
    }
    
    if (tabStats.count > 0) {
        DLog(@"Commit TAB stats...");
        [self.tabStats statsTabWithStatsInfos:tabStats completionHandler:^(BOOL success, id obj) {
            if (success) {
                [JFStatsInfo removeStatsInfos:tabStats];
                DLog(@"Commit TAB stats successfully");
            } else {
                DLog(@"Commint TAB stats with failure: %@", obj);
            }
        }];
    }
    
    if (payStats.count > 0) {
        DLog(@"Commit PAY stats...");
        [self.payStats statsPayWithStatsInfos:payStats completionHandler:^(BOOL success, id obj) {
            if (success) {
                [JFStatsInfo removeStatsInfos:payStats];
                DLog(@"Commit PAY stats successfully!");
            } else {
                DLog(@"Commit PAY stats with failure: %@", obj);
            }
        }];
    }
}

- (void)statsCPCWithBeseModel:(JFBaseModel *)beseModel inTabIndex:(NSUInteger)tabIndex {
    JFStatsInfo *statsInfo = [[JFStatsInfo alloc] init];
    statsInfo.tabpageId = @(tabIndex+1);
    statsInfo.columnId = beseModel.realColumnId.integerValue == 0 ? nil : beseModel.realColumnId;
    statsInfo.columnType = beseModel.channelType.integerValue == 0 ? nil : beseModel.channelType;
    statsInfo.statsType = @(JFStatsTypeColumnCPC);
    [self addStats:statsInfo];
    
    [MobClick event:kUmengCPCChannelEvent attributes:[statsInfo umengAttributes]];
}

- (void)statsCPCWithBeseModel:(JFBaseModel *)beseModel
              programLocation:(NSUInteger)programLocation
                  andTabIndex:(NSUInteger)tabIndex
                  subTabIndex:(NSUInteger)subTabIndex
{
    JFStatsInfo *statsInfo = [[JFStatsInfo alloc] init];
    if (beseModel) {
        statsInfo.columnId = beseModel.realColumnId.integerValue == 0 ? nil : beseModel.realColumnId;
        statsInfo.columnType = beseModel.channelType.integerValue == 0 ? nil : beseModel.channelType;
    }
    statsInfo.tabpageId = @(tabIndex+1);
    if (subTabIndex != NSNotFound) {
        statsInfo.subTabpageId = @(subTabIndex+1);
    }
    
    statsInfo.programId = beseModel.programId.integerValue == 0 ? nil : beseModel.programId;
    statsInfo.programType = beseModel.programType.integerValue == 0 ? nil : beseModel.programType;
    statsInfo.programLocation = @(beseModel.programLocation+1);
    statsInfo.statsType = @(JFStatsTypeProgramCPC);
    [self addStats:statsInfo];
    
    [MobClick event:kUmengCPCProgramEvent attributes:statsInfo.umengAttributes];
}

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forClickCount:(NSUInteger)clickCount {
    dispatch_async(self.queue, ^{
        NSArray<JFStatsInfo *> *statsInfos = [JFStatsInfo statsInfosWithStatsType:JFStatsTypeTabCPC tabIndex:tabIndex subTabIndex:subTabIndex];
        JFStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[JFStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
            statsInfo.statsType = @(JFStatsTypeTabCPC);
        }
        
        statsInfo.clickCount = @(statsInfo.clickCount.unsignedIntegerValue + clickCount);
        [statsInfo save];
        
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forSlideCount:(NSUInteger)slideCount {
    dispatch_async(self.queue, ^{
        NSArray<JFStatsInfo *> *statsInfos = [JFStatsInfo statsInfosWithStatsType:JFStatsTypeTabPanning tabIndex:tabIndex subTabIndex:subTabIndex];
        JFStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[JFStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
            statsInfo.statsType = @(JFStatsTypeTabPanning);
        }
        
        statsInfo.slideCount = @(statsInfo.slideCount.unsignedIntegerValue + slideCount);
        [statsInfo save];
        
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsStopDurationAtTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex {
    dispatch_async(self.queue, ^{
        NSArray<JFStatsInfo *> *statsInfos = [JFStatsInfo statsInfosWithStatsType:JFStatsTypeTabStay tabIndex:tabIndex subTabIndex:subTabIndex];
        JFStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[JFStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
            statsInfo.statsType = @(JFStatsTypeTabStay);
        }
        
        NSUInteger durationSinceStats = [[NSDate date] timeIntervalSinceDate:self.statsDate];
        statsInfo.stopDuration = @(statsInfo.stopDuration.unsignedIntegerValue + durationSinceStats);
        [statsInfo save];
        
        [self resetStatsDate];
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forBanner:(NSNumber *)bannerColumnId withSlideCount:(NSUInteger)slideCount {
    dispatch_async(self.queue, ^{
        NSArray<JFStatsInfo *> *statsInfos = [JFStatsInfo statsInfosWithStatsType:JFStatsTypeBannerPanning tabIndex:tabIndex subTabIndex:subTabIndex];
        JFStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[JFStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            statsInfo.statsType = @(JFStatsTypeBannerPanning);
            statsInfo.columnId = bannerColumnId.integerValue == 0 ? nil : bannerColumnId;
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
        }
        
        statsInfo.slideCount = @(statsInfo.slideCount.unsignedIntegerValue + slideCount);
        [statsInfo save];
        
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)resetStatsDate {
    _statsDate = [NSDate date];
}

- (void)statsPayWithOrderNo:(NSString *)orderNo
                  payAction:(JFStatsPayAction)payAction
                  payResult:(QBPayResult)payResult
               forBaseModel:(JFBaseModel *)beseModel
            programLocation:(NSUInteger)programLocation
                andTabIndex:(NSUInteger)tabIndex
                subTabIndex:(NSUInteger)subTabIndex
{
    dispatch_async(self.queue, ^{
        JFStatsInfo *statsInfo = [[JFStatsInfo alloc] init];
        statsInfo.tabpageId = @(tabIndex+1);
        if (subTabIndex != NSNotFound) {
            statsInfo.subTabpageId = @(subTabIndex+1);
        }
        statsInfo.columnId = beseModel.realColumnId.integerValue == 0 ? nil : beseModel.realColumnId;
        statsInfo.columnType = beseModel.channelType.integerValue == 0 ? nil : beseModel.channelType;
        statsInfo.programId = beseModel.programId.integerValue == 0 ? nil : beseModel.programId;
        statsInfo.programType = beseModel.programType.integerValue == 0 ? nil : beseModel.programType;
        statsInfo.programLocation = @(beseModel.programLocation+1);
        statsInfo.isPayPopup = @(1);
        statsInfo.orderNo = orderNo;
        if (payAction == JFStatsPayActionClose) {
            statsInfo.isPayPopupClose = @(1);
        } else if (payAction == JFStatsPayActionGoToPay) {
            statsInfo.isPayConfirm = @(1);
        } else if (payAction == JFStatsPayActionPayBack) {
            NSDictionary *payStautsMapping = @{@(QBPayResultSuccess):@(1), @(QBPayResultFailure):@(2), @(QBPayResultCancelled):@(3)};
            NSNumber *payStatus = payStautsMapping[@(payResult)];
            statsInfo.payStatus = payStatus;
        } else {
            return ;
        }
        
        statsInfo.paySeq = @([JFUtil launchSeq]);
        statsInfo.statsType = @(JFStatsTypePay);
        statsInfo.network = @([QBNetworkInfo sharedInfo].networkStatus);
        [statsInfo save];
        
        [MobClick event:kUmengPayEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsPayWithPaymentInfo:(QBPaymentInfo *)paymentInfo
                   forPayAction:(JFStatsPayAction)payAction
                    andTabIndex:(NSUInteger)tabIndex
                    subTabIndex:(NSUInteger)subTabIndex
{
    dispatch_async(self.queue, ^{
        JFStatsInfo *statsInfo = [[JFStatsInfo alloc] init];
        statsInfo.tabpageId = @(tabIndex+1);
        if (subTabIndex != NSNotFound) {
            statsInfo.subTabpageId = @(subTabIndex+1);
        }
        statsInfo.columnId = paymentInfo.columnId.integerValue == 0 ? nil : paymentInfo.columnId;
        statsInfo.columnType = paymentInfo.columnType.integerValue == 0 ? nil : paymentInfo.columnType;
        statsInfo.programId = paymentInfo.contentId.integerValue == 0 ? nil : paymentInfo.contentId;
        statsInfo.programType = paymentInfo.contentType.integerValue == 0 ? nil : paymentInfo.contentType;
        statsInfo.programLocation = paymentInfo.contentLocation;
        statsInfo.isPayPopup = @(1);
        statsInfo.orderNo = paymentInfo.orderId;
        if (payAction == JFStatsPayActionClose) {
            statsInfo.isPayPopupClose = @(1);
        } else if (payAction == JFStatsPayActionGoToPay) {
            statsInfo.isPayConfirm = @(1);
        } else if (payAction == JFStatsPayActionPayBack) {
            NSDictionary *payStautsMapping = @{@(QBPayResultSuccess):@(1), @(QBPayResultFailure):@(2), @(QBPayResultCancelled):@(3)};
//            NSNumber *payStatus = payStautsMapping[paymentInfo.paymentResult];
            NSNumber *payStatus = payStautsMapping[@(paymentInfo.paymentResult)];
            statsInfo.payStatus = payStatus;
        } else {
            return ;
        }
    
        statsInfo.paySeq = @([JFUtil launchSeq]);
        statsInfo.statsType = @(JFStatsTypePay);
        statsInfo.network = @([QBNetworkInfo sharedInfo].networkStatus);
        [statsInfo save];
        
        [MobClick event:kUmengPayEvent attributes:statsInfo.umengAttributes];
    });
}

@end
