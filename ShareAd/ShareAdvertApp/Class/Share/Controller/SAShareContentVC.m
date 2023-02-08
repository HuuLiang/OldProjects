//
//  SAShareContentVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAShareContentVC.h"
#import "SAShareContentCell.h"
#import "SAShareContentModel.h"
#import "SAReqManager.h"
#import "SAShareDetailVC.h"
#import "SAShareManager.h"
#import "SAMineAlertUIHelper.h"

static NSString *const kSAShareContentCellReusableIdentifier = @"kSAShareContentCellReusableIdentifier";

@interface SAShareContentVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) NSString *columnId;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) SAShareContentResponse *response;
@end

@implementation SAShareContentVC
QBDefineLazyPropertyInitialization(SAShareContentResponse, response)

- (instancetype)initWithColumnId:(NSString *)columnId
{
    self = [super init];
    if (self) {
        _columnId = columnId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#ffffff");
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColor(@"#ffffff");
    [_tableView registerClass:[SAShareContentCell class] forCellReuseIdentifier:kSAShareContentCellReusableIdentifier];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setSeparatorColor:kColor(@"#efefef")];
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-kWidth(80));
        }];
    }
    
    [self fetchSourceWithColumnId:self.columnId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)refreshContent {
    [self fetchSourceWithColumnId:self.columnId];
}

- (void)startToShareContentWithProgramModel:(SAShareContentProgramModel *)programModel {
    if (![SAUtil checkUserIsLogin]) {
        [SAMineAlertUIHelper showAlertUIWithType:SAMineAlertTypeShareOffline onCurrentVC:self];
    } else {
        [[SAShareManager manager] startToShareWithModel:programModel];
    }
}

- (void)fetchSourceWithColumnId:(NSString *)columnId {
    @weakify(self);
    [[SAReqManager manager] fetchShareListWithColumnId:_columnId class:[SAShareContentResponse class] handler:^(BOOL success, id obj) {
        @strongify(self);
        if (success) {
            if (self.endRefresh) {
                self.endRefresh();
            }
            self.response = obj;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDelegate,UITalbeViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.response.shares.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAShareContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kSAShareContentCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.response.shares.count) {
        SAShareContentProgramModel *programModel = self.response.shares[indexPath.row];
        cell.imgUrl = programModel.coverImg;
        cell.specilTitle = @"限时上涨到2毛";
        cell.title = programModel.title;
        cell.price = [NSString stringWithFormat:@"高价  %.2f元/阅读",(float)programModel.shAmount/100];
        cell.read = [NSString stringWithFormat:@"阅读:%@",programModel.readNumber];
        @weakify(self);
        cell.shareAction = ^{
            @strongify(self);
            [self startToShareContentWithProgramModel:programModel];
        };
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(200);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SAShareContentProgramModel *programModel = self.response.shares[indexPath.row];
    if (indexPath.row < self.response.shares.count) {
        if (![SAUtil checkUserIsLogin]) {
            [SAMineAlertUIHelper showAlertUIWithType:SAMineAlertTypeShareOffline onCurrentVC:self];
            return;
        }
        SAShareDetailVC *detailVC = [[SAShareDetailVC alloc] initWithInfo:programModel];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(observerContentScrollViewDidScroll:)]) {
        [self.delegate observerContentScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(observerContentScrollViewBeginDragging:)]) {
        [self.delegate observerContentScrollViewBeginDragging:scrollView];
    }
}

@end
