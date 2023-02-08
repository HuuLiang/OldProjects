//
//  YFBDiscoverViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDiscoverViewController.h"
#import "YFBGreetingVC.h"
#import "YFBRecommendVC.h"
#import "YFBNearVC.h"
#import "YFBRankVC.h"
#import "YFBLocalNotificationManager.h"

@interface YFBDiscoverViewController () <UIPageViewControllerDelegate,UIPageViewControllerDataSource>
{
    UISegmentedControl *_segmentedControl;
    UIPageViewController *_pageViewController;
}
@property (nonatomic,retain) NSMutableArray <UIViewController *> *viewControllers;

@end

@implementation YFBDiscoverViewController
QBDefineLazyPropertyInitialization(NSMutableArray, viewControllers)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    YFBRecommendVC *recommendVC = [[YFBRecommendVC alloc] init];
    [self.viewControllers addObject:recommendVC];
    
    YFBNearVC *nearVC = [[YFBNearVC alloc] init];
    [self.viewControllers addObject:nearVC];
    
    YFBRankVC *rankVC = [[YFBRankVC alloc] init];
    [self.viewControllers addObject:rankVC];
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    [_pageViewController setViewControllers:@[self.viewControllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
    
    NSArray *segmentItems = @[@"推荐",@"附近",@"风云榜"];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentItems];
    for (NSUInteger i = 0; i < segmentItems.count; ++i) {
        [_segmentedControl setWidth:66 forSegmentAtIndex:i];
    }
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.layer.borderColor = kColor(@"#ffffff").CGColor;
    _segmentedControl.layer.borderWidth = 1;
    _segmentedControl.tintColor = [UIColor whiteColor];
    _segmentedControl.backgroundColor = [UIColor clearColor];
    _segmentedControl.layer.cornerRadius = 15.0f;
    _segmentedControl.layer.masksToBounds = YES;
    [_segmentedControl addObserver:self
                        forKeyPath:NSStringFromSelector(@selector(selectedSegmentIndex))
                           options:NSKeyValueObservingOptionNew
                           context:nil];
    self.navigationItem.titleView = _segmentedControl;
    
    if ([UIApplication sharedApplication].scheduledLocalNotifications.count == 0) {
        YFBGreetingVC *greetingVC = [[YFBGreetingVC alloc] init];
        [greetingVC showInViewController:self];
    }
    [[YFBLocalNotificationManager manager] startAutoLocalNotification]; //开启本地通知轮循
}

- (NSUInteger)currentIndex {
    return _segmentedControl.selectedSegmentIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBShowChargeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBHideChargeNotification object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(selectedSegmentIndex))]) {
        NSNumber *oldValue = change[NSKeyValueChangeOldKey];
        NSNumber *newValue = change[NSKeyValueChangeNewKey];
        
        [_pageViewController setViewControllers:@[self.viewControllers[newValue.unsignedIntegerValue]]
                                      direction:newValue.unsignedIntegerValue>oldValue.unsignedIntegerValue?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse
                                       animated:YES completion:nil];
    }
}


#pragma mark - UIPageViewControllerDelegate,UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger viewControllerIndex = [self.viewControllers indexOfObject:viewController];
    if (viewControllerIndex != self.viewControllers.count-1) {
        return self.viewControllers[viewControllerIndex+1];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger viewControllerIndex = [self.viewControllers indexOfObject:viewController];
    if (viewControllerIndex != 0) {
        return self.viewControllers[viewControllerIndex-1];
    }
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if (completed) {
        _segmentedControl.selectedSegmentIndex = [self.viewControllers indexOfObject:pageViewController.viewControllers.firstObject];
    }
}


@end
