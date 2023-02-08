//
//  JFHotViewController.m
//  JFVideo
//
//  Created by Liang on 16/7/15.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFHotViewController.h"

#import "JFChannelModel.h"
#import "JFChannelColumnModel.h"
#import "JFTitleLabelCell.h"

#import "JFChannelProgramModel.h"
#import "JFChannelProgramCell.h"

#import "JFDetailViewController.h"

#define LINESPACING kScreenWidth * 10 / 375.
#define INTERITEMSPACING kScreenWidth * 23 / 750.
#define EDGINSETS UIEdgeInsetsMake(kScreenWidth * 25 / 750., kScreenWidth * 30 / 750. , kScreenWidth * 25 / 750., kScreenWidth * 30 / 750.)
#define titleCellHeight 2* kScreenWidth * 48/750. + LINESPACING + EDGINSETS.top + EDGINSETS.bottom + kScreenWidth * 48 / 750.


static NSString *const kHotTitleCellReusableIdentifier = @"hottitleCellReusableIdentifier";
static NSString *const kChannelProgramCellReusableIdentifier = @"ChannelProgramCellReusableIdentifier";


@interface JFHotViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSUInteger _columnId;
    NSIndexPath *_selectecIndexPath;
    NSIndexPath *_lastSelectedIndexPath;
    BOOL _isRefresh;
    
    UITableViewCell *_titleCell;
    UICollectionView *_layoutTitleCollectionView;
    
    UITableViewCell *_headerCell;
    UILabel *_label;
    
    UITableViewCell *_detailCell;
    UICollectionView *_layoutDetailCollectionView;
}
@property (nonatomic) JFChannelModel *channelModel;
@property (nonatomic) NSMutableArray *titleArray;
@property (nonatomic) NSMutableArray *titleWidthArray;
@property (nonatomic) NSMutableArray *detailArray;
@property (nonatomic) JFChannelProgramModel *programModel;
@end

@implementation JFHotViewController
DefineLazyPropertyInitialization(JFChannelModel, channelModel)
DefineLazyPropertyInitialization(NSMutableArray, titleArray)
DefineLazyPropertyInitialization(NSMutableArray, titleWidthArray)
DefineLazyPropertyInitialization(NSMutableArray, detailArray)
DefineLazyPropertyInitialization(JFChannelProgramModel,programModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectecIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    _isRefresh = NO;
    
    self.layoutTableView.hasRowSeparator = NO;
    self.layoutTableView.hasSectionBorder = NO;
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#303030"];
    [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    @weakify(self);
    [self.layoutTableView JF_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadTitleData];
    }];
    [self.layoutTableView JF_triggerPullToRefresh];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.titleArray.count == 0) {
            [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
                @strongify(self);
                  [self.layoutTableView JF_triggerPullToRefresh];
            }];
        }
    });;
    
}

- (void)loadTitleData{
    @weakify(self);
    [self.channelModel fetchChannelInfoWithPage:100 CompletionHandler:^(BOOL success, NSArray * obj) {
        @strongify(self);
        [self.layoutTableView JF_endPullToRefresh];
        if (success) {
            [self removeCurrentRefreshBtn];
            _isRefresh = YES;
            [self.titleArray removeAllObjects];
            [self.titleWidthArray removeAllObjects];
            [self titleItemWidth:obj];
            [self.titleArray addObjectsFromArray:obj];
            [self reloadUI];
        }
//        else {
//            if (self.titleArray.count == 0) {
//                [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
//                    @strongify(self);
//                    [self.layoutTableView JF_triggerPullToRefresh];
//                }];
//            }
//            
//        }
    }];
}

- (void)loadProgramsWithColumnInfo:(JFChannelColumnModel *)column {
    if (_lastSelectedIndexPath == _selectecIndexPath && !_isRefresh) {
        return;
    }
    _isRefresh = YES;
    
    @weakify(self);
    [self.programModel fecthChannelProgramWithColumnId:column.columnId Page:100 CompletionHandler:^(BOOL success, NSArray * obj) {
        @strongify(self);
        if (success) {
            [self.detailArray removeAllObjects];
            [self.detailArray addObjectsFromArray:obj];
            [self initHeaderCell:1 column:column];
            [self initDetailCell:2 column:column];
            
        }
        if (!success || obj.count == 0) {
            [[CRKHudManager manager] showHudWithText:@"数据加载失败,请稍后再试"];
            
        }
        _isRefresh = NO;
        
    }];
    _lastSelectedIndexPath = _selectecIndexPath;
}

- (void)titleItemWidth:(NSArray *)array {
    CGFloat fullwidth = kScreenWidth - EDGINSETS.left - EDGINSETS.right;
    NSInteger count = 0;
    CGFloat currentWidth = 0;
    CGFloat nextWidth = 0;
    CGFloat rowWidth = fullwidth;
    for (NSInteger i = 0; i < array.count ; i++) {
        JFChannelColumnModel *columnModel = array[i];
        if (i == 0) {
            currentWidth = [columnModel.name sizeWithFont:[UIFont systemFontOfSize:kScreenWidth*26/750.] maxSize:CGSizeMake(MAXFLOAT, kScreenWidth * 48 / 750.)].width + 30.;
        } else {
            currentWidth = nextWidth;
        }
        
        if (i + 1 < array.count) {
            columnModel = array[i + 1];
            nextWidth = [columnModel.name sizeWithFont:[UIFont systemFontOfSize:kScreenWidth*26/750.] maxSize:CGSizeMake(MAXFLOAT, kScreenWidth * 48 / 750.)].width + 30.;
            if (rowWidth - currentWidth - INTERITEMSPACING >= nextWidth && count < 3) {
                count++;
                rowWidth = rowWidth - currentWidth - INTERITEMSPACING;
                [self.titleWidthArray addObject:@((long)currentWidth)];
            } else {
                count = 0;
                currentWidth = rowWidth;
                [self.titleWidthArray addObject:@((long)currentWidth)];
                rowWidth = kScreenWidth - EDGINSETS.left - EDGINSETS.right;
            }
        } else {
            if (count <= 3 && rowWidth > currentWidth) {
                currentWidth = rowWidth;
                [self.titleWidthArray addObject:@((long)currentWidth)];
            } else {
                [self.titleWidthArray addObject:@((long)currentWidth)];
            }
        }
    }
}

- (void)reloadUI {
    [self removeAllLayoutCells];
    [self initTitleCell:0];
    [self.layoutTableView reloadData];
    [self collectionView:_layoutTitleCollectionView didSelectItemAtIndexPath:_selectecIndexPath];
}

- (void)initTitleCell:(NSUInteger)section {
    _titleCell = [[UITableViewCell alloc] init];
    _titleCell.backgroundColor = [UIColor colorWithHexString:@"#303030"];
    _titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = LINESPACING;
    layout.minimumInteritemSpacing = INTERITEMSPACING;
    
    _layoutTitleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutTitleCollectionView.backgroundColor = [UIColor clearColor];
    _layoutTitleCollectionView.delegate = self;
    _layoutTitleCollectionView.dataSource = self;
    _layoutTitleCollectionView.showsVerticalScrollIndicator = NO;
    _layoutTitleCollectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _layoutTitleCollectionView.scrollEnabled = NO;
    [_layoutTitleCollectionView registerClass:[JFTitleLabelCell class] forCellWithReuseIdentifier:kHotTitleCellReusableIdentifier];
    [_titleCell addSubview:_layoutTitleCollectionView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:kScreenWidth * 30 / 750.];
    [btn setTitle:@"更多" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"hot_more_icon"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 25/375.*kScreenWidth)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 40/375.*kScreenWidth, 5,5)];
    [_titleCell addSubview:btn];
    
    
    [btn bk_addEventHandler:^(id sender) {
        if ([btn.titleLabel.text isEqualToString:@"更多"]) {
            [btn setTitle:@"收起" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"hot_less_icon"] forState:UIControlStateNormal];
            _layoutTitleCollectionView.scrollEnabled = YES;
            _layoutTitleCollectionView.showsVerticalScrollIndicator = YES;
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                _titleCell.frame = CGRectMake(0, 0, kScreenWidth, titleCellHeight + 2.5 * kScreenWidth * 48/750. +  LINESPACING * 2);
                _headerCell.transform = CGAffineTransformMakeTranslation(0, 2.5 * kScreenWidth * 48/750. +  LINESPACING * 2);
                _detailCell.transform = CGAffineTransformMakeTranslation(0, 2.5 * kScreenWidth * 48/750. +  LINESPACING * 2);
            } completion:^(BOOL finished) {
                [self setLayoutCell:_titleCell cellHeight:titleCellHeight + 2.5 * kScreenWidth * 48/750. +  LINESPACING * 2 inRow:0 andSection:0];
                [self.layoutTableView reloadData];
            }];
        } else {
            [btn setTitle:@"更多" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"hot_more_icon"] forState:UIControlStateNormal];
            _layoutTitleCollectionView.scrollEnabled = NO;
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                _titleCell.frame = CGRectMake(0, 0, kScreenWidth, titleCellHeight);
                _headerCell.transform = CGAffineTransformMakeTranslation(0, 0);
                _detailCell.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                [self setLayoutCell:_titleCell cellHeight:titleCellHeight inRow:0 andSection:0];
                [self.layoutTableView reloadData];
            }];
            
            [_layoutTitleCollectionView scrollToItemAtIndexPath:_selectecIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [_layoutTitleCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_titleCell);
            make.bottom.equalTo(_titleCell.mas_bottom).offset(-(kScreenWidth * 48 /750. + LINESPACING));
        }];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_titleCell).offset(0);
            make.right.equalTo(_titleCell).offset(-5/375.*kScreenWidth);
            make.size.mas_equalTo(CGSizeMake(68/375.*kScreenWidth,kScreenWidth * 24 /375. + LINESPACING));
        }];
    }
    
    [self setLayoutCell:_titleCell cellHeight:titleCellHeight inRow:0 andSection:0];
}

- (void)initHeaderCell:(NSUInteger)section column:(JFChannelColumnModel *)column {
    _headerCell = [[UITableViewCell alloc] init];
    _headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _headerCell.backgroundColor = [UIColor clearColor];
    
    _label = [[UILabel alloc] init];
    _label.textColor = [[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.54];
    _label.font = [UIFont systemFontOfSize:kScreenWidth * 30 /750.];
    _label.text = [NSString stringWithFormat:@"共搜索到%ld部\"%@\"的作品",_detailArray.count,column.name];
    [_headerCell addSubview:_label];
    {
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerCell).offset(kScreenWidth * 2 / 750.);
            make.left.equalTo(_headerCell).offset(15);
            make.right.equalTo(_headerCell);
            make.height.mas_equalTo(kScreenWidth * 30 / 750.);
        }];
    }
    [self setLayoutCell:_headerCell cellHeight:kScreenWidth * 50 / 750. inRow:0 andSection:section++];
}
- (void)initDetailCell:(NSUInteger)section column:(JFChannelColumnModel *)column {
    _detailCell = [[UITableViewCell alloc] init];
    _detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _detailCell.backgroundColor = [UIColor clearColor];
    _label.text = [NSString stringWithFormat:@"共搜索到%ld部\"%@\"的作品",_detailArray.count,column.name];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = layout.minimumLineSpacing;
    _layoutDetailCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutDetailCollectionView.backgroundColor = [UIColor clearColor];
    _layoutDetailCollectionView.delegate = self;
    _layoutDetailCollectionView.dataSource = self;
    _layoutDetailCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutDetailCollectionView registerClass:[JFChannelProgramCell class] forCellWithReuseIdentifier:kChannelProgramCellReusableIdentifier];
    _layoutDetailCollectionView.scrollEnabled = NO;
    [_detailCell addSubview:_layoutDetailCollectionView];
    {
        [_layoutDetailCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_detailCell);
        }];
    }
    
    const CGFloat fullWidth = kScreenWidth;
    const CGFloat width = (fullWidth - 2*layout.minimumLineSpacing - EDGINSETS.left - EDGINSETS.right)/3;
    const CGFloat height = width * 300 / 227. + kWidth(30);
    NSInteger itemLines = self.detailArray.count % 3 == 0 ? (self.detailArray.count / 3) : (self.detailArray.count / 3 + 1);
    CGFloat collectionViewHeight =  (itemLines - 1) * 5 + EDGINSETS.bottom + EDGINSETS.top + itemLines * height;
    [self setLayoutCell:_detailCell cellHeight:collectionViewHeight inRow:0 andSection:section];
    
    [self.layoutTableView reloadData];
    
    [_layoutTitleCollectionView selectItemAtIndexPath:_selectecIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _layoutTitleCollectionView) {
        return self.titleArray.count;
    } else if (collectionView == _layoutDetailCollectionView) {
        return self.detailArray.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _layoutTitleCollectionView) {
        JFTitleLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHotTitleCellReusableIdentifier forIndexPath:indexPath];
        if (indexPath.item < self.titleArray.count) {
            JFChannelColumnModel *column = self.titleArray[indexPath.item];
            cell.title = column.name;
            if (indexPath.item == _selectecIndexPath.item) {
                
            }
            return cell;
        }
    } else if (collectionView == _layoutDetailCollectionView) {
        JFChannelProgramCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kChannelProgramCellReusableIdentifier forIndexPath:indexPath];
        if (indexPath.item < self.detailArray.count) {
            JFChannelProgram *program = self.detailArray[indexPath.item];
            cell.title = program.title;
            cell.imgUrl = program.coverImg;
            return cell;
        }
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _layoutTitleCollectionView) {
        if (indexPath.item < self.titleArray.count) {
            JFChannelColumnModel *column = self.titleArray[indexPath.item];
            _columnId = column.columnId;
            _selectecIndexPath = indexPath;
            [_layoutTitleCollectionView scrollToItemAtIndexPath:_selectecIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            [self loadProgramsWithColumnInfo:column];
            
            JFBaseModel *baseModel = [[JFBaseModel alloc] init];
            baseModel.realColumnId = @(column.realColumnId);
            baseModel.channelType = @(column.type);
            baseModel.programLocation = indexPath.item;
            
            [[JFStatsManager sharedManager] statsCPCWithBeseModel:baseModel inTabIndex:self.tabBarController.selectedIndex];
        }
    } else if (collectionView == _layoutDetailCollectionView) {
        
        JFChannelProgram *program = self.detailArray[indexPath.item];
        JFChannelColumnModel *column = self.titleArray[_selectecIndexPath.item];
        
        JFBaseModel *baseModel = [[JFBaseModel alloc] init];
        baseModel.realColumnId = @(column.realColumnId);
        baseModel.channelType = @(column.type);
        baseModel.programId = @(program.programId);
        baseModel.programType = @(program.type);
        baseModel.programLocation = indexPath.item;
        baseModel.spec = [program.spec integerValue];
        
//        [self playVideoWithInfo:baseModel videoUrl:program.videoUrl];
        
        JFDetailViewController *detailVC = [[JFDetailViewController alloc] initWithColumnId:_columnId ProgramId:program.programId];
        detailVC.baseModel = baseModel;
        [self.navigationController pushViewController:detailVC animated:YES];
        
        [[JFStatsManager sharedManager] statsCPCWithBeseModel:baseModel programLocation:indexPath.item andTabIndex:self.tabBarController.selectedIndex subTabIndex:[JFUtil currentSubTabPageIndex]];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == _layoutTitleCollectionView) {
        const CGFloat width = [self.titleWidthArray[indexPath.item] floatValue];
        const CGFloat height = kScreenWidth * 48 / 750.;
        return CGSizeMake(width , height);
    } else if (collectionView == _layoutDetailCollectionView) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_layoutDetailCollectionView.collectionViewLayout;
        const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
        UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
        const CGFloat width = (fullWidth - 2*layout.minimumInteritemSpacing  - insets.left - insets.right)/3.;
        const CGFloat height = width * 300 / 227.+ kWidth(30);
        return CGSizeMake((long)width , (long)height);
    } else {
        return CGSizeZero;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return EDGINSETS;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[JFStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[JFUtil currentSubTabPageIndex] forSlideCount:1];
    
}

@end
