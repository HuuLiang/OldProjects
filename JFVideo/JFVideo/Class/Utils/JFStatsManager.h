//
//  JFStatsManager.h
//  JFuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JFStatsPayAction) {
    JFStatsPayActionUnknown,
    JFStatsPayActionClose,
    JFStatsPayActionGoToPay,
    JFStatsPayActionPayBack
};

@class JFStatsInfo;
@class JFBaseModel;
@interface JFStatsManager : NSObject

+ (instancetype)sharedManager;

- (void)addStats:(JFStatsInfo *)statsInfo;
- (void)removeStats:(NSArray<JFStatsInfo *> *)statsInfos;
- (void)scheduleStatsUploadWithTimeInterval:(NSTimeInterval)timeInterval;

// Helper Methods
- (void)statsCPCWithBeseModel:(JFBaseModel *)beseModel inTabIndex:(NSUInteger)tabIndex;
- (void)statsCPCWithBeseModel:(JFBaseModel *)beseModel
            programLocation:(NSUInteger)programLocation
                andTabIndex:(NSUInteger)tabIndex
                subTabIndex:(NSUInteger)subTabIndex;

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forClickCount:(NSUInteger)clickCount;
- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forSlideCount:(NSUInteger)slideCount;
- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forBanner:(NSNumber *)bannerColumnId withSlideCount:(NSUInteger)slideCount;
- (void)statsStopDurationAtTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex;

- (void)statsPayWithOrderNo:(NSString *)orderNo
                  payAction:(JFStatsPayAction)payAction
                  payResult:(QBPayResult)payResult
                 forBaseModel:(JFBaseModel *)beseModel
            programLocation:(NSUInteger)programLocation
                andTabIndex:(NSUInteger)tabIndex
                subTabIndex:(NSUInteger)subTabIndex;

- (void)statsPayWithPaymentInfo:(QBPaymentInfo *)paymentInfo
                   forPayAction:(JFStatsPayAction)payAction
                    andTabIndex:(NSUInteger)tabIndex
                    subTabIndex:(NSUInteger)subTabIndex;

@end
