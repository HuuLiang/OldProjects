//
//  JYMyPhotoBigImageView.m
//  JYFriend
//
//  Created by ylz on 2016/12/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMyPhotoBigImageView.h"
#import "SDCycleScrollView.h"

@interface JYMyPhotoBigImageView ()<SDCycleScrollViewDelegate>
{
    SDCycleScrollView *_bannerView;
}
@end

@implementation JYMyPhotoBigImageView

- (instancetype)initWithImageGroup:(NSArray *)imageGroup frame:(CGRect)frame isLocalImage:(BOOL)isLocalImage isNeedBlur:(BOOL)isNeedBlur userId:(NSString *)userId;
{
    self = [super initWithFrame:frame];
    if (self) {
        _shouldAutoScroll = YES;
        _shouldInfiniteScroll = YES;
        if (isLocalImage) {
            _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds shouldInfiniteLoop:NO imageNamesGroup:imageGroup];
        }else {
            _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds imageURLStringsGroup:imageGroup];
        }
        _bannerView.userId = userId;
        _bannerView.isNeedBlur = isNeedBlur;
        _bannerView.backgroundColor = self.backgroundColor;
//        _bannerView.infiniteLoop = NO;
        _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        _bannerView.backgroundColor = [UIColor blackColor];
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.autoScrollTimeInterval = 5;
        _bannerView.autoScroll = _shouldAutoScroll;
        _bannerView.infiniteLoop = _shouldInfiniteScroll;
        _bannerView.pageDotColor = [UIColor colorWithHexString:@"#D8D8D8"];
        _bannerView.currentPageDotColor = [UIColor colorWithHexString:@"#FF206F"];
        _bannerView.delegate = self;
          [self addSubview:_bannerView];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _bannerView.frame = frame;
}

- (void)setPageControlYAspect:(CGFloat)pageControlYAspect {
    _pageControlYAspect = pageControlYAspect;
    if (_pageControlYAspect == 0) {
        _bannerView.pageControlPositionY = nil;
    } else {
        _bannerView.pageControlPositionY = ^CGFloat(CGFloat superViewHeight) {
            return pageControlYAspect * superViewHeight;
        };
    }
}
- (void)setImageURLStrings:(NSArray *)imageURLStrings {
    BOOL hasChanged = [imageURLStrings bk_any:^BOOL(id obj) {
        return ![_imageURLStrings containsObject:obj];
    }];
    
    if (hasChanged) {
        _imageURLStrings = imageURLStrings;
        _bannerView.imageURLStringsGroup = imageURLStrings;
    }
}

- (void)setShouldAutoScroll:(BOOL)shouldAutoScroll {
    _shouldAutoScroll = shouldAutoScroll;
    _bannerView.autoScroll = shouldAutoScroll;
}

- (void)setShouldInfiniteScroll:(BOOL)shouldInfiniteScroll {
    _shouldInfiniteScroll = shouldInfiniteScroll;
    _bannerView.infiniteLoop = shouldInfiniteScroll;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    _bannerView.currentPage = currentIndex;
}

- (NSUInteger)currentIndex {
    return _bannerView.currentPage;
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.action) {
        self.action(self);
    }
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    if (self.scrollAction) {
        self.scrollAction(self,@(index));
    }
}

- (void)setImages:(NSArray<UIImage *> *)images {
    _images = images;
    _bannerView.localizationImageNamesGroup = images;

}

@end
