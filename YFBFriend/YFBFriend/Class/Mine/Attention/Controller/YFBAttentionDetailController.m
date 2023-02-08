//
//  YFBAttentionDetailController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBAttentionDetailController.h"
#import "YFBAttentionTableViewCell.h"
#import "YFBAttentionListModel.h"
#import "YFBInteractionManager.h"
#import "YFBRobot.h"

static NSString *const kAttentionOtherCellIdentifier = @"yfb_attention_other_identifier";
static NSString *const kAttentionMeCellIdentifier = @"yfb_attention_me_identifier";

@interface YFBAttentionDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
    BOOL _isAttentionMe;
}
@property (nonatomic,retain) NSMutableArray *dataSource;
@property (nonatomic,retain) YFBAttentionListModel *attentionModel;
@end

@implementation YFBAttentionDetailController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(YFBAttentionListModel, attentionModel)

- (instancetype)initWithIsAttentionMe:(BOOL)isAttentionMe
{
    self = [super init];
    if (self) {
        _isAttentionMe = isAttentionMe;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _layoutTableView.backgroundColor = self.view.backgroundColor;
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.tableFooterView = [UIView new];
    [_layoutTableView setSeparatorInset:UIEdgeInsetsZero];
    [_layoutTableView setSeparatorColor:kColor(@"#e6e6e6")];
    if (_isAttentionMe) {
        [_layoutTableView registerClass:[YFBAttentionTableViewCell class] forCellReuseIdentifier:kAttentionMeCellIdentifier];
    } else {
        [_layoutTableView registerClass:[YFBAttentionTableViewCell class] forCellReuseIdentifier:kAttentionOtherCellIdentifier];
    }
    [self.view addSubview:_layoutTableView];
    
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutTableView YFB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadData];
    }];
    
    [_layoutTableView YFB_triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    @weakify(self);
    [self.attentionModel fetchAttentionListWithType:self->_isAttentionMe ? kYFBAttentionListConcernedKeyName : kYFBAttentionListConcernKeyName
                                  CompletionHandler:^(BOOL success, NSArray <YFBAttentionInfo *>* userList)
    {
        @strongify(self);
        
        [self->_layoutTableView YFB_endPullToRefresh];
        if (success) {
            if (!self) {
                return ;
            }
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:userList];
            if (!self->_isAttentionMe) {
                [userList enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(YFBAttentionInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    YFBRobot *robot = [YFBRobot findFirstByCriteria:[NSString stringWithFormat:@"where userId=\'%@\'",obj.userId]];
                    if (!robot) {
                        robot = [[YFBRobot alloc] init];
                        robot.userId = obj.userId;
                        robot.concerned = YES;
                    }
                    [robot saveOrUpdate];
                }];
            }
            
            [self->_layoutTableView reloadData];
        }
    }];
}

#pragma mark  UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_isAttentionMe ? kAttentionMeCellIdentifier : kAttentionOtherCellIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        YFBAttentionInfo *info = self.dataSource[indexPath.row];
        cell.name = info.nickName;
        cell.headerUrl = info.portraitUrl;
        cell.age = (long)info.age;
        cell.photoCount = info.photoCount;
        if (!_isAttentionMe) {
            @weakify(self);
            cell.attentionAction = ^ {
                @strongify(self);
                [[YFBInteractionManager manager] cancleConcernUserWithUserId:info.userId handler:^(BOOL success) {
                    if (success) {
                        [self.dataSource removeObject:info];
                        [self->_layoutTableView reloadData];
                    }
                }];
            };
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(140);
}

@end
