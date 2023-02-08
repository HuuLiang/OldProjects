//
//  JQKHomeCollectionViewLayout.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKHomeCollectionViewLayout.h"

typedef NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> LayoutAttributesDictionary;
static const CGFloat kTopImageScale = 1184./595.;
static const CGFloat kBigImageScale = 568./807.;
static const CGFloat kSmallImageScale = 563./382.;

@interface JQKHomeCollectionViewLayout ()
@property (nonatomic,retain) LayoutAttributesDictionary *layoutAttributes;

@property (nonatomic,readonly) CGSize topSize;
@property (nonatomic,readonly) CGSize bigSize;
@property (nonatomic,readonly) CGSize smallSize;
@property (nonatomic,readonly) CGSize adBannerSize;

@property (nonatomic) CGSize collectionViewContentSize;
@end

@implementation JQKHomeCollectionViewLayout

DefineLazyPropertyInitialization(LayoutAttributesDictionary, layoutAttributes)

- (CGSize)bigSize {
    const CGFloat cvW = CGRectGetWidth(self.collectionView.bounds);
    const CGFloat bigH = (2*(cvW-_interItemSpacing)+_interItemSpacing*kSmallImageScale) / (2*kBigImageScale+kSmallImageScale);
    const CGFloat bigW = (cvW-_interItemSpacing)/2; //bigH * kBigImageScale;
    return CGSizeMake(bigW, bigH);
}

- (CGSize)smallSize {
      const CGFloat cvW = CGRectGetWidth(self.collectionView.bounds);
    const CGFloat smallH = (self.bigSize.height-_interItemSpacing) / 2;
    const CGFloat smallW = (cvW-_interItemSpacing)/2; //smallH * kSmallImageScale;
    return CGSizeMake(smallW, smallH);
}

- (CGSize)halfSize {
    const CGFloat cvW = CGRectGetWidth(self.collectionView.bounds);
    const CGSize smallSize = [self smallSize];
    const CGFloat width = (cvW-_interItemSpacing)/2;
    
    if (smallSize.width == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(width, width * smallSize.height / smallSize.width);
}

- (CGSize)topSize {
    const CGFloat cvW = CGRectGetWidth(self.collectionView.bounds);
    return CGSizeMake(cvW, kWidth(188.));//cvW/kTopImageScale
    
}

- (CGSize)headerViewSize {

    return CGSizeMake(kScreenWidth, kWidth(50.));
}
//广告条的布局
- (CGSize)adBannerSize {
//    const CGFloat cvW = CGRectGetWidth(self.collectionView.bounds);
//    return CGSizeMake(cvW, cvW/5);
    return CGSizeMake(0, 0);
}

- (BOOL)hasAdBannerForItem:(NSUInteger)item {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:hasAdBannerForItem:)]) {
        return [self.delegate collectionView:self.collectionView layout:self hasAdBannerForItem:item];
    }
    return NO;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    [self.layoutAttributes removeAllObjects];
    NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    if (numberOfItems == 0) {
        return ;
    }
    
    const CGSize bigSize = self.bigSize;
    const CGSize smallSize = self.smallSize;
    const CGSize topSize = self.topSize;
    const CGSize halfSize = self.halfSize;
    const CGSize adBannerSize = self.adBannerSize;
    
    const CGFloat bigH = bigSize.height;
    const CGFloat bigW = bigSize.width;
    const CGFloat smallH = smallSize.height;
    const CGFloat smallW = smallSize.width;
    const CGFloat topWidth = topSize.width;
    const CGFloat topHeight = topSize.height;
    const CGFloat halfH = halfSize.height;
    const CGFloat halfW = halfSize.width;
    
    const CGFloat headerWidth = [self headerViewSize].width;
    const CGFloat headerHeight = [self headerViewSize].height;
    
    CGRect lastLayerFrame;
    NSUInteger picIndex = 0;
    for (NSUInteger i = 0;  i < numberOfItems; ++i) {
        UICollectionViewLayoutAttributes *layoutAttribs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        if ([self hasAdBannerForItem:i]) {
            layoutAttribs.frame = CGRectMake(0, CGRectGetMaxY(lastLayerFrame)+_interItemSpacing, adBannerSize.width, adBannerSize.height);
        } else if (picIndex == 0) {
            layoutAttribs.frame = CGRectMake(0, 0, topWidth, topHeight);
            ++picIndex;
        }else if (picIndex == 1){
            layoutAttribs.frame = CGRectMake(0,topHeight, headerWidth, headerHeight);
            ++picIndex;
        
        } else if (picIndex == 2 ||picIndex ==3 ||picIndex ==4 ||picIndex == 5){//试播
        layoutAttribs.frame = CGRectMake((picIndex-2)%2*(smallW+_interItemSpacing),topHeight+headerHeight + (picIndex-2)/2*(smallH+_interItemSpacing), smallW, smallH);
            ++picIndex ;
        }else if (picIndex == 6){
            layoutAttribs.frame = CGRectMake(0,topHeight+headerHeight+smallH*2+_interItemSpacing, headerWidth, headerHeight);//
            ++picIndex;
        }
//        else if (picIndex == 3 || picIndex == 2) {
//            layoutAttribs.frame = CGRectMake(picIndex==1?0:halfW+_interItemSpacing, topHeight+_interItemSpacing+headerHeight, halfW, halfH);
//            ++picIndex;
//        }
        else {
            NSUInteger subIndex = (picIndex-2)%5;
            
            CGFloat x = 0, y = 0;
            switch (subIndex) {
                case 1:
                case 4:
                case 6:
                    x = CGRectGetMaxX(lastLayerFrame)+_interItemSpacing;
                    break;
                case 2:
                    x = lastLayerFrame.origin.x;
                default:
                    break;
            }
            switch (subIndex) {
                case 0:
                case 2:
                case 3:
                case 5:
                    y = CGRectGetMaxY(lastLayerFrame)+_interItemSpacing;
                    break;
                    
                default:
                    y = lastLayerFrame.origin.y;
                    break;
            }
            
            if (subIndex == 0) {
              BOOL lastIndex = picIndex > (numberOfItems -2)/5 *5;//判断剩余的item是否满5个
                CGFloat weight = lastIndex ? smallW : bigW;
                CGFloat height = lastIndex ? smallH : bigH;
                CGFloat offsetY = (picIndex == 7) ? (y - _interItemSpacing) : y;
                layoutAttribs.frame = CGRectMake(x, offsetY, weight, height);
            } else if (subIndex < 3) {
                layoutAttribs.frame = CGRectMake(x, y, smallW, smallH);
            } else {
                layoutAttribs.frame = CGRectMake(x, y, halfW, halfH);
            }
            
            ++picIndex;
        }
        
        if (!CGRectEqualToRect(layoutAttribs.frame, CGRectZero)) {
            lastLayerFrame = layoutAttribs.frame;
            [self.layoutAttributes setObject:layoutAttribs forKey:layoutAttribs.indexPath];
        }
    }
    
    self.collectionViewContentSize = CGSizeMake(self.collectionView.bounds.size.width, CGRectGetMaxY(lastLayerFrame));
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.layoutAttributes.allValues bk_select:^BOOL(id obj) {
        UICollectionViewLayoutAttributes *attributes = obj;
        return CGRectIntersectsRect(rect, attributes.frame);
    }];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttributes[indexPath];
}
@end
