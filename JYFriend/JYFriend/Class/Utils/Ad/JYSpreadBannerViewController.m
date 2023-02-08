//
//  JYSpreadBannerViewController.m
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYSpreadBannerViewController.h"
#import "JYAppSpread.h"
#import "SDCycleScrollView.h"

@interface JYSpreadBannerViewController () <SDCycleScrollViewDelegate>
{
    SDCycleScrollView *_contentView;
}
@property (nonatomic,readonly) NSUInteger currentIndex;
@end

@implementation JYSpreadBannerViewController

- (instancetype)initWithSpreads:(NSArray<JYAppSpread *> *)spreads {
    self = [super init];
    if (self) {
        _spreads = spreads;
    }
    return self;
}

- (BOOL)shouldDisplayBackgroundImage {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    @weakify(self);
    _contentView = [[SDCycleScrollView alloc] init];
    _contentView.delegate = self;
    _contentView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _contentView.autoScrollTimeInterval = 5;
    [self.view addSubview:_contentView];
    {
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.equalTo(self.view).multipliedBy(0.8);
            make.height.equalTo(_contentView.mas_width).multipliedBy(3./5.);
        }];
    }
    
    UIButton *closeButton = [[UIButton alloc] init];
    closeButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [closeButton setImage:[UIImage imageNamed:@"video_close"] forState:UIControlStateNormal];
    [closeButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self hide];
    } forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:closeButton];
    {
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(_contentView);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    
    NSMutableArray *imageUrlStrings = [NSMutableArray array];
    [_spreads enumerateObjectsUsingBlock:^(JYAppSpread * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         [imageUrlStrings addObject:obj.coverImg ?: @""];
     }];
    _contentView.imageURLStringsGroup = imageUrlStrings;
    
}

- (void)showInViewController:(UIViewController *)viewController {
    BOOL anySpreadBanner = [viewController.childViewControllers bk_any:^BOOL(id obj) {
        if ([obj isKindOfClass:[self class]]) {
            return YES;
        }
        return NO;
    }];
    
    if (anySpreadBanner) {
        return ;
    }
    
    if ([viewController.view.subviews containsObject:self.view]) {
        return ;
    }
    
    _currentIndex = 0;
    [viewController addChildViewController:self];
    self.view.frame = viewController.view.bounds;
    self.view.alpha = 0;
    [viewController.view addSubview:self.view];
    [self didMoveToParentViewController:viewController];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1;
    }];
}

- (void)hide {
    if (!self.view.superview) {
        return ;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
        [self cycleScrollView:_contentView didSelectItemAtIndex:_currentIndex];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (index < _spreads.count) {
        JYAppSpread *spread = _spreads[index];
        if (spread.videoUrl.length > 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:spread.videoUrl]];
        }
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    _currentIndex = index;
}

@end
