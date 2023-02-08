//
//  JYSegmentViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYSegmentViewController.h"
#import "JYCharacterViewController.h"
#import "JYDynamicViewController.h"
#import "JYRecommendViewController.h"
#import "JYSendDynamicViewController.h"

static NSString *const kRecommendLastDayKeyName   = @"kRecommednLastDayKeyName";


@interface JYSegmentViewController () <UIPageViewControllerDelegate,UIPageViewControllerDataSource>
{
    UISegmentedControl *_segmentedControl;
    UIPageViewController *_pageViewController;
}
@property (nonatomic,retain) NSMutableArray <UIViewController *> *viewControllers;
@end

@implementation JYSegmentViewController

QBDefineLazyPropertyInitialization(NSMutableArray, viewControllers)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    JYCharacterViewController *characterVC = [[JYCharacterViewController alloc] init];
    [self.viewControllers addObject:characterVC];
    
    JYDynamicViewController *dynamicVC = [[JYDynamicViewController alloc] init];
    [self.viewControllers addObject:dynamicVC];
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    [_pageViewController setViewControllers:@[self.viewControllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
    
    NSArray *segmentItems = @[@"人 物",@"动 态"];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentItems];
    for (NSUInteger i = 0; i < segmentItems.count; ++i) {
        [_segmentedControl setWidth:66 forSegmentAtIndex:i];
    }
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addObserver:self
                        forKeyPath:NSStringFromSelector(@selector(selectedSegmentIndex))
                           options:NSKeyValueObservingOptionNew
                           context:nil];
    self.navigationItem.titleView = _segmentedControl;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"dynamic_create"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        //发表动态
        JYSendDynamicViewController *sendVC = [[JYSendDynamicViewController alloc] init];
        [self.navigationController pushViewController:sendVC animated:YES];
    }];
    
    
    if (![JYUtil isTodayWithKeyName:kRecommendLastDayKeyName]) {
        JYRecommendViewController *recommendVC = [[JYRecommendViewController alloc] init];
        [recommendVC showInViewController:self];
    }
}

- (NSUInteger)currentIndex {
    return _segmentedControl.selectedSegmentIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
