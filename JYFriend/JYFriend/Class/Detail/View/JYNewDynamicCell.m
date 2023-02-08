//
//  JYNewDynamicCell.m
//  JYFriend
//
//  Created by ylz on 2016/12/27.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYNewDynamicCell.h"

@interface JYNewDynamicCell ()

@property (nonatomic,retain) NSMutableArray<UIImageView *> *imageViews;
@end

@implementation JYNewDynamicCell
QBDefineLazyPropertyInitialization(NSMutableArray, imageViews)

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setDetaiMoods:(NSArray<JYUserDetailMood *> *)detaiMoods {
    _detaiMoods = detaiMoods;
    if (detaiMoods.count >0) {
        [self.imageViews removeAllObjects];
        @weakify(self);
        [detaiMoods enumerateObjectsUsingBlock:^(JYUserDetailMood * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:obj.thumbnail]];
            [imageView bk_whenTouches:1 tapped:1 handler:^{
                if (self.action) {
                    self.action(idx);
                }
            }];
            [self addSubview:imageView];
            [self.imageViews addObject:imageView];

        }];
    }

}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.imageViews.count > 0) {
        [_imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectMake(kWidth(30) + (self.bounds.size.height + kWidth(4.))*idx, 0, self.bounds.size.height, self.bounds.size.height);
        }];
    }
}

@end
