//
//  YFBPhotoBrowse.m
//  YFBFriend
//
//  Created by Liang on 2017/4/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBPhotoBrowse.h"
#import "SDCycleScrollView.h"

@interface YFBPhotoBrowse () <SDCycleScrollViewDelegate>
@property (nonatomic,strong) SDCycleScrollView *photoScrollView;
@end

@implementation YFBPhotoBrowse

+ (instancetype)browse {
    static YFBPhotoBrowse *_browse;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _browse = [[YFBPhotoBrowse alloc] init];
    });
    return _browse;
}

- (void)showPhotoBrowseWithImageUrl:(NSArray *)imageUrls onSuperView:(UIView *)superView {
    [self showPhotoBrowseWithImageUrl:imageUrls atIndex:0 onSuperView:superView];
}

- (void)showPhotoBrowseWithImageUrl:(NSArray *)imageUrls atIndex:(NSInteger)currentIndex onSuperView:(UIView *)superView {
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    [superView.window addSubview:self];
    
    self.photoScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds imageURLStringsGroup:imageUrls];
    _photoScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    _photoScrollView.backgroundColor = [UIColor blackColor];
    _photoScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _photoScrollView.autoScrollTimeInterval = 5;
    _photoScrollView.autoScroll = NO;
    _photoScrollView.infiniteLoop = NO;
    _photoScrollView.pageDotColor = [UIColor colorWithHexString:@"#D8D8D8"];
    _photoScrollView.currentPageDotColor = [UIColor colorWithHexString:@"#FF206F"];
    _photoScrollView.delegate = self;
    
    if (imageUrls[currentIndex]) {
        _photoScrollView.currentPage = currentIndex;
    }
    
    [self addSubview:_photoScrollView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
}

- (void)closeBrowse {
    if (self.closeAction) {
        self.closeAction(self);
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [_photoScrollView removeFromSuperview];
        _photoScrollView = nil;
    }];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    [self closeBrowse];
}

@end
