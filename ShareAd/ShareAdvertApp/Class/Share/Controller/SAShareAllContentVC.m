//
//  SAShareAllContentVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAShareAllContentVC.h"
#import "SAShareAllContentCell.h"
#import "SAShareModel.h"

static NSString *const kSAShareAllContentCellReusableIdentifier = @"kSAShareAllContentCellReusableIdentifier";

@interface SAShareAllContentVC () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic) UICollectionView *collectionView;
@end

@implementation SAShareAllContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kWidth(40);
    layout.minimumInteritemSpacing = kWidth(20);
    layout.sectionInset = UIEdgeInsetsMake(kWidth(30), kWidth(30), kWidth(48), kWidth(30));
    CGFloat width = ceilf((kScreenWidth - kWidth(140))/5)-1;
    CGFloat height = ceilf(width*7/15);
    layout.itemSize = CGSizeMake(width, height);
    
    NSInteger lineCount = self.dataSource.count % 5 == 0 ? (self.dataSource.count / 5) : (self.dataSource.count / 5 + 1);
    CGFloat allHeight = kWidth(60) + lineCount * height + (lineCount - 1) * kWidth(40);
    if (allHeight < kWidth(328)) {
        allHeight = kWidth(328);
    }
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = kColor(@"#ffffff");
    [_collectionView registerClass:[SAShareAllContentCell class] forCellWithReuseIdentifier:kSAShareAllContentCellReusableIdentifier];
    [self.view addSubview:_collectionView];
    
    {
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(64);
            make.height.mas_equalTo(ceilf(allHeight));
        }];
    }
    
    [_collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self hide];
}

+ (void)showAllContentVCWithDataSource:(NSArray *)dataSource height:(CGFloat)height InCurrentVC:(UIViewController *)currentVC {
    SAShareAllContentVC *allContentVC = [[SAShareAllContentVC alloc] init];
    allContentVC.dataSource = dataSource;
    allContentVC.height = height;
    [allContentVC showAllContentVCInCurrentVC:currentVC];
}

- (void)showAllContentVCInCurrentVC:(UIViewController *)currentVC {
    
    BOOL anySpreadBanner = [currentVC.childViewControllers bk_any:^BOOL(id obj) {
        if ([obj isKindOfClass:[self class]]) {
            return YES;
        }
        return NO;
    }];
    
    if (anySpreadBanner) {
        [self hide];
        return ;
    }
    
    if ([currentVC.view.subviews containsObject:self.view]) {
        return ;
    }
    
    [currentVC addChildViewController:self];
    self.view.backgroundColor = [kColor(@"#000000") colorWithAlphaComponent:0.3];
    self.view.frame = currentVC.view.bounds;
    self.view.alpha = 0;
    [currentVC.view addSubview:self.view];
    [self didMoveToParentViewController:currentVC];
    
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
    }];
}


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SAShareAllContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSAShareAllContentCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < self.dataSource.count) {
        SAShareColumnModel *columnModel = self.dataSource[indexPath.row];
        cell.title = columnModel.name;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataSource.count) {
        SAShareColumnModel *columnModel = self.dataSource[indexPath.row];
        [self hide];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kSAPushShareContentVCNotification object:columnModel];
        });
    }
}

@end
