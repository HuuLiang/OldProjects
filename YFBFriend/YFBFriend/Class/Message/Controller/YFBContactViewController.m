//
//  YFBContactViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBContactViewController.h"
#import "YFBContactCell.h"
#import "YFBMessageViewController.h"
#import "YFBContactManager.h"
#import "YFBVisiteModel.h"
#import "YFBVisitemeViewController.h"

static NSString *const kYFBContactCellReusableIdentifier = @"kYFBContactCellReusableIdentifier";

@interface YFBContactViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_notiLabel;
    UIButton *_deleteButton;
    UIButton *_readButton;
    NSInteger visitemeCount;
}
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIView *editingView;
@property (nonatomic) NSMutableArray <YFBContactModel *>*dataSource;
@property (nonatomic) NSMutableArray *selectedIndexPathes;
@property (nonatomic) YFBVisiteModel *visiteModel;
@property (nonatomic) dispatch_queue_t mainQueue;
@end

@implementation YFBContactViewController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(NSMutableArray, selectedIndexPathes)
QBDefineLazyPropertyInitialization(YFBVisiteModel, visiteModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
//    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_tableView registerClass:[YFBContactCell class] forCellReuseIdentifier:kYFBContactCellReusableIdentifier];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"编辑" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        //进入编辑模式
        if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
            self.navigationItem.rightBarButtonItem.title = @"取消";
            [self animationEditingViewHidden:NO];
            [_tableView setEditing:YES animated:YES];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"全选" style:UIBarButtonItemStylePlain handler:^(id sender) {
                @strongify(self);
                if ([self.navigationItem.leftBarButtonItem.title isEqualToString:@"全选"]) {
                    //全选
                    //获取表格视图内容的尺寸
                    CGSize size = self.tableView.contentSize;
                    CGRect rect = CGRectMake(0, 0, size.width, size.height);
                    //获取指定区域的cell的indexPath
                    NSArray * indexPathes = [self.tableView indexPathsForRowsInRect:rect];
                    for (NSIndexPath * indexPath in indexPathes) {
                        //使用代码方式选中一行
                        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                    }
                    [self.selectedIndexPathes removeAllObjects];
                    [self.selectedIndexPathes addObjectsFromArray:indexPathes];
                    
                } else if ([self.navigationItem.leftBarButtonItem.title isEqualToString:@"全不选"]) {
                    for (NSIndexPath * indexPath in self.selectedIndexPathes) {
                        //使用代码方式取消选中一行
                        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                    }
                    //清空选中cell的记录数组
                    [self.selectedIndexPathes removeAllObjects];
                    self.navigationItem.leftBarButtonItem.title = @"全选";
                }
                
            }];
        } else if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"取消"]) {
            [self.selectedIndexPathes removeAllObjects];
            self.navigationItem.rightBarButtonItem.title = @"编辑";
            [self animationEditingViewHidden:YES];
            [self->_tableView setEditing:NO animated:YES];
            self.navigationItem.leftBarButtonItem = nil;
        }
    }];
    
    [self.dataSource addObjectsFromArray:[[YFBContactManager manager] loadAllContactInfo]];
    [_tableView reloadData];
    
    [self loadVisitemeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshBadege];
    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBShowChargeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadgeNumber:) name:KUpdateContactUnReadMessageNotification object:nil];
    [_tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBHideChargeNotification object:nil];
}


- (void)refreshBadege {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __block NSInteger unreadMsgCount = 0;
        NSArray *array = [NSArray arrayWithArray:self.dataSource];
        [array enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(YFBContactModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            unreadMsgCount += obj.unreadMsgCount;
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (unreadMsgCount > 0) {
                if (unreadMsgCount < 100) {
                    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (unsigned long)unreadMsgCount];
                } else {
                    self.navigationController.tabBarItem.badgeValue = @"99+";
                }
            } else {
                self.navigationController.tabBarItem.badgeValue = nil;
            }
            [self.tableView reloadData];
        });
    });
}

- (void)loadVisitemeData {
    @weakify(self);
    [self.visiteModel fetchVisitemeInfoWithCompletionHandler:^(BOOL success, YFBVisiteResponse * visiteResponse) {
        @strongify(self);
        if (success) {
            self->visitemeCount = visiteResponse.userList.count;
            self->_tableView.tableHeaderView = [self configHeaderView];
        }
    }];
}

- (dispatch_queue_t)mainQueue {
    if (!_mainQueue) {
        _mainQueue = dispatch_queue_create("update_Badge_Number_queue", NULL);
    }
    return _mainQueue;
}

- (void)updateBadgeNumber:(NSNotification *)notification {
    if (self.viewLoaded) {
        dispatch_async(self.mainQueue, ^{
            YFBContactModel *contactModel = nil;
            if (notification) {
                contactModel = (YFBContactModel *)[notification object];
            }
            if ([contactModel.userId isEqualToString:[YFBUser currentUser].userId]) {
                return ;
            }
            if (contactModel) {
                __block BOOL alreadyRobot = NO;
                __block BOOL needSort = NO;
                [self.dataSource enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(YFBContactModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.userId isEqualToString:contactModel.userId]) {
                        QBLog(@"obj.messageTime = %ld contactModel.messageTime =  %ld",obj.messageTime,contactModel.messageTime);
                        if (obj.messageTime != contactModel.messageTime) {
                            needSort = YES;
                        }
                        obj.messageTime = contactModel.messageTime;
                        obj.messageContent = contactModel.messageContent;
                        obj.messageType = contactModel.messageType;
                        obj.unreadMsgCount = contactModel.unreadMsgCount;
                        obj.isOneline = contactModel.isOneline;
                        alreadyRobot = YES;
                        * stop = YES;
                    }
                }];
                
                if (!alreadyRobot) {
                    [self.dataSource addObject:contactModel];
                }
                
                if (needSort) {
                    [self.dataSource sortUsingComparator:^NSComparisonResult(YFBContactModel * _Nonnull obj1, YFBContactModel *  _Nonnull obj2) {
                        if (obj1.messageTime > obj2.messageTime) {
                            return NSOrderedAscending;
                        }
                        if (obj1.messageTime < obj2.messageTime) {
                            return NSOrderedDescending;
                        }
                        return NSOrderedSame;
                    }];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshBadege];
            });
        });
    }
}

- (void)animationEditingViewHidden:(BOOL)hidden {
    if (!_editingView) {
        self.editingView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kWidth(98) + 49 - 64, kScreenWidth, kWidth(98))];
        _editingView.backgroundColor = kColor(@"#000000");
        [[UIApplication sharedApplication].keyWindow addSubview:_editingView];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(kWidth(20), kWidth(13), kWidth(348), kWidth(72));
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _deleteButton.backgroundColor = [UIColor colorWithHexString:@"#d8d8d8"];
        _deleteButton.layer.cornerRadius = 5;
        _deleteButton.layer.masksToBounds = YES;
        [_editingView addSubview:_deleteButton];
        
        _readButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _readButton.frame = CGRectMake(kWidth(388) , kWidth(13), kWidth(348), kWidth(72));
        [_readButton setTitle:@"全部设为已读" forState:UIControlStateNormal];
        _readButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _readButton.backgroundColor = [UIColor colorWithHexString:@"#8458D0"];
        _readButton.layer.cornerRadius = 5;
        _readButton.layer.masksToBounds = YES;
        [_editingView addSubview:_readButton];
        
        @weakify(self);
        [_deleteButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            //删除数组的元素会影响后面的顺序，需要倒序删除
            NSArray * newIndexPathes = [self.selectedIndexPathes sortedArrayUsingSelector:@selector(compare:)];
            for (NSInteger i = newIndexPathes.count-1; i>= 0 ; i--) {
                NSIndexPath * indexPath = newIndexPathes[i];
                //删除数据源中的数据
                YFBContactModel *contactModel = self.dataSource[indexPath.row];
                [contactModel deleteObject];
                [self.dataSource removeObjectAtIndex:indexPath.row];
            }
            [self.tableView deleteRowsAtIndexPaths:self.selectedIndexPathes withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.selectedIndexPathes removeAllObjects];
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_readButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            [self.dataSource enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(YFBContactModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.unreadMsgCount = 0;
                [obj saveOrUpdate];
                [self.dataSource replaceObjectAtIndex:idx withObject:obj];
                [self.tableView reloadData];
            }];
            self.navigationController.tabBarItem.badgeValue = nil;
        } forControlEvents:UIControlEventTouchUpInside];
    }
    self.navigationItem.leftBarButtonItem.customView.hidden = hidden;
    self.tabBarController.tabBar.hidden = !hidden;
    
    if (!hidden) {
        [_editingView showWithPopAnimation];
    } else {
        [_editingView hiddenWithPopAnimation];
    }
}

- (UIView *)configHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.size = CGSizeMake(kScreenWidth, kWidth(84));
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setTitle:@"谁看过我" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"contact_eye"] forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(26)];
    [headerView addSubview:titleButton];
    
    UIEdgeInsets imageEdge = titleButton.imageEdgeInsets;
    UIEdgeInsets titleEdge = titleButton.titleEdgeInsets;
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(imageEdge.top, imageEdge.left - 2.5, imageEdge.bottom, imageEdge.right + 2.5);
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(titleEdge.top, titleEdge.left + 2.5, titleEdge.bottom, titleEdge.right - 2.5);
    
    
    _notiLabel = [[UILabel alloc] init];
    _notiLabel.text = [NSString stringWithFormat:@"今天共有%ld位女性访问你",self->visitemeCount];
    _notiLabel.font = [UIFont systemFontOfSize:kWidth(26)];
    _notiLabel.textColor = [UIColor colorWithHexString:@"#97BCF0"];
    [headerView addSubview:_notiLabel];
    
    UIImageView *intoImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contact_into"]];
    [headerView addSubview:intoImageV];
    
    {
        [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.left.equalTo(headerView).offset(kWidth(30));
            make.size.mas_equalTo(CGSizeMake(kWidth(190), kWidth(40)));
        }];
        
        [intoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.right.equalTo(headerView.mas_right).offset(-kWidth(30));
            make.size.mas_equalTo(CGSizeMake(kWidth(24), kWidth(44)));
        }];
        
        [_notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.right.equalTo(intoImageV.mas_left).offset(-kWidth(26));
            make.height.mas_equalTo(kWidth(36));
        }];
    }
    
    @weakify(self);
    [headerView bk_whenTapped:^{
        @strongify(self);
        [self animationEditingViewHidden:YES];
        YFBVisitemeViewController *visiteVC = [[YFBVisitemeViewController alloc] initWithTitle:@"最近访客"];
        [self.navigationController pushViewController:visiteVC animated:YES];
    }];
    
    return headerView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBContactCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        YFBContactModel *contactModel = self.dataSource[indexPath.row];
        cell.userImgUrl = contactModel.portraitUrl;
        cell.nickName = contactModel.nickName;
        cell.recentTime = contactModel.messageTime;
        cell.content = contactModel.messageContent;
        cell.msgType = contactModel.messageType;
        cell.unreadMsg = contactModel.unreadMsgCount;
        cell.isOneline = contactModel.isOneline;
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBContactModel *model = nil;
    if (indexPath.row < self.dataSource.count) {
        model = self.dataSource[indexPath.row];
    }
    if (tableView.isEditing) {
        [self.selectedIndexPathes addObject:indexPath];
        if (self.selectedIndexPathes.count == self.dataSource.count) {
            self.navigationItem.leftBarButtonItem.title = @"全不选";
        }
    } else {
        //进入聊天界面
        model.unreadMsgCount = 0;
        [model saveOrUpdate];
        
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
        
        [self pushIntoMessageVCWithUserId:model.userId nickName:model.nickName avatarUrl:model.portraitUrl];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        [self.selectedIndexPathes removeObject:indexPath];
        if (self.selectedIndexPathes.count == 0) {
            self.navigationItem.rightBarButtonItem.title = @"取消";
            self.navigationItem.leftBarButtonItem.title = @"全选";
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(138);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kWidth(20);
}

@end
