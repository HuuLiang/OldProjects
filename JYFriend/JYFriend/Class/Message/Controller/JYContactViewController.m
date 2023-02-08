//
//  JYContactViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/22.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYContactViewController.h"
#import "JYContactCell.h"
#import "JYMessageViewController.h"
#import "JYContactModel.h"
#import "JYDetailViewController.h"
#import "JYMessageModel.h"
#import "JYAutoContactManager.h"
#import "MGSwipeButton.h"

typedef NS_ENUM(NSUInteger, JYUserState) {
    JYUserStick = 0,//置顶用户
    JYUserNormal, //非置顶用户
    JYUserStateSection
};

static NSString *const kContactCellReusableIdentifier = @"ContactCellReusableIdentifier";

@interface JYContactViewController () <UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>
{
    UITableView *_tableVC;
}
@property (nonatomic) NSMutableArray <JYContactModel *>*normalContacts;
@property (nonatomic) NSMutableArray <JYContactModel *>*stickContacts;
@end

@implementation JYContactViewController
QBDefineLazyPropertyInitialization(NSMutableArray, stickContacts)
QBDefineLazyPropertyInitialization(NSMutableArray, normalContacts)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableVC = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableVC.backgroundColor = kColor(@"#efefef");
    _tableVC.delegate = self;
    _tableVC.dataSource = self;
    [_tableVC registerClass:[JYContactCell class] forCellReuseIdentifier:kContactCellReusableIdentifier];
    [self.view addSubview:_tableVC];
    _tableVC.tableFooterView = [[UIView alloc] init];
    {
        [_tableVC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    [_tableVC reloadData];
    
    [self reloadContactsWithUIReload:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataSource) name:KUpdateContactUnReadMessageNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.isMovingToParentViewController) {
        [self reloadContactsWithUIReload:YES];
    }
}

- (void)reloadDataSource {
    if (self.isViewLoaded) {
        [self reloadContactsWithUIReload:YES];
    }
}

- (void)reloadContactsWithUIReload:(BOOL)reloadUI {
    NSArray *allContacts = [JYContactModel allContacts];
    [self.stickContacts removeAllObjects];
    [self.normalContacts removeAllObjects];
    
    __block NSUInteger unreadMessages = 0;
    [allContacts enumerateObjectsUsingBlock:^(JYContactModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isStick) {
            [self.stickContacts addObject:obj];
        } else {
            [self.normalContacts addObject:obj];
        }
        unreadMessages += obj.unreadMessages;
    }];

    if (![self.navigationController.tabBarItem.badgeValue isEqualToString:[NSString stringWithFormat:@"%ld",unreadMessages]]) {
        reloadUI = YES;
    }
    
    if (unreadMessages > 0) {
        if (unreadMessages < 100) {
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (unsigned long)unreadMessages];
        } else {
            self.navigationController.tabBarItem.badgeValue = @"99+";
        }
    } else {
        self.navigationController.tabBarItem.badgeValue = nil;
    }
    
    if (reloadUI) {
        [_tableVC reloadData];
    }
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return JYUserStateSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == JYUserStick) {
        return self.stickContacts.count;
    } else if (section == JYUserNormal) {
        return self.normalContacts.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    JYContactCell *contactCell = [tableView dequeueReusableCellWithIdentifier:kContactCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.section < JYUserStateSection) {
        JYContactModel *contact;
        if (indexPath.section == JYUserStick) {
            if (indexPath.row < self.stickContacts.count) {
                contact = self.stickContacts[indexPath.row];
            }
        } else if (indexPath.section == JYUserNormal) {
            if (indexPath.row < self.normalContacts.count) {
                contact = self.normalContacts[indexPath.row];
            }
        }
        
        if (contact) {
            contactCell.touchUserImgVAction = ^(id obj) {
                @strongify(self);
                //用户详情
                [self pushDetailViewControllerWithUserId:contact.userId time:nil distance:nil nickName:contact.nickName];
            };
            contactCell.userImgStr = contact.logoUrl;
            contactCell.nickNameStr = contact.nickName;
            contactCell.recentTimeStr = [JYUtil timeStringFromDate:[NSDate dateWithTimeIntervalSince1970:contact.recentTime] WithDateFormat:KDateFormatLong];
            contactCell.recentMessage = contact.recentMessage;
            contactCell.isStick = contact.isStick;
            contactCell.unreadMessage = contact.unreadMessages;
            contactCell.delegate = self;
        }
    }
    return contactCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(140);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JYContactModel *contact = nil;
    if (indexPath.section == JYUserStick) {
        if (indexPath.row < self.stickContacts.count) {
            contact = self.stickContacts[indexPath.row];
        }
    } else if (indexPath.section == JYUserNormal) {
        if (indexPath.row < self.normalContacts.count) {
            contact = self.normalContacts[indexPath.row];
        }
    }
    if (contact) {
        JYUser *user = [[JYUser alloc] init];
        user.userId = contact.userId;
        user.nickName = contact.nickName;
        user.userImgKey = contact.logoUrl;
        
        [JYMessageViewController showMessageWithUser:user inViewController:self];
    }
}

#pragma mark - MGSwipeTableCellDelegate
-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings;
{
    swipeSettings.transition = MGSwipeTransitionRotate3D;
    
    if (direction == MGSwipeDirectionRightToLeft) {
        return [self createRightButtonsWithCell:cell];
    }
    return nil;

}

-(NSArray *) createRightButtonsWithCell:(MGSwipeTableCell *)cell {
    NSMutableArray *buttons = [NSMutableArray array];
    NSIndexPath *indexPath = [self->_tableVC indexPathForCell:cell];
    //获取indexPath对应的数据
    JYContactModel *contact;
    if (indexPath.section == JYUserStick) {
        contact = self.stickContacts[indexPath.row];
    } else if (indexPath.section == JYUserNormal) {
        contact = self.normalContacts[indexPath.row];
    }
    
    if (contact) {
        //删除标签
        MGSwipeButton *deleteButton = [MGSwipeButton buttonWithTitle:@" 删除 "
                                                     backgroundColor:kColor(@"#E55D51")
                                                            callback:^BOOL(MGSwipeTableCell * _Nonnull cell)
        {
            //dataSource 中删除
            if (indexPath.section == JYUserStick) {
                [self.stickContacts removeObject:contact];
            } else if (indexPath.section == JYUserNormal) {
                [self.normalContacts removeObject:contact];
            }
            //删除 动画
            [self->_tableVC beginUpdates];
            [self->_tableVC deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [self->_tableVC endUpdates];
            [self updataBadgeWith:contact];
            //数据库中删除
            [JYContactModel deleteObjects:@[contact]];

            return YES;
        }];
        [buttons addObject:deleteButton];
        
        //置顶 取消置顶标签
        MGSwipeButton *stickButton = [MGSwipeButton buttonWithTitle:contact.isStick ? @"取消置顶" :@" 置顶 "
                                                    backgroundColor:kColor(@"#DEDEDE")
                                                           callback:^BOOL(MGSwipeTableCell * _Nonnull cell)
        {
            [self->_tableVC setEditing:NO];
            NSIndexPath *newIndexPath;
            if (contact.isStick) {
                //从置顶移动到普通 取消置顶
                [self.stickContacts removeObject:contact];
                contact.isStick = !contact.isStick;
                [self.normalContacts insertObject:contact atIndex:0];
                newIndexPath = [NSIndexPath indexPathForRow:0 inSection:JYUserNormal];
                
                [self->_tableVC beginUpdates];
                [self->_tableVC deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                [self->_tableVC insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [self->_tableVC endUpdates];
            } else {
                //从普通移动到置顶 设置为置顶
                [self.normalContacts removeObject:contact];
                contact.isStick = !contact.isStick;
                [self.stickContacts insertObject:contact atIndex:0];
                newIndexPath = [NSIndexPath indexPathForRow:0 inSection:JYUserStick];
                
                [self->_tableVC beginUpdates];
                [self->_tableVC deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [self->_tableVC insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
                [self->_tableVC endUpdates];
            }
            JYContactCell *contactCell = (JYContactCell *)[self->_tableVC cellForRowAtIndexPath:newIndexPath];
            contactCell.isStick = contact.isStick;
            
            [contact saveOrUpdate];

            return YES;
        }];
        
        [buttons addObject:stickButton];
    }

    return buttons.count > 0 ? buttons : nil;
}

- (void)updataBadgeWith:(JYContactModel *)contact {
    NSInteger unreadMessages =  [self.navigationController.tabBarItem.badgeValue integerValue] - contact.unreadMessages;
    
    if (unreadMessages > 0) {
        if (unreadMessages < 100) {
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (unsigned long)unreadMessages];
        } else {
            self.navigationController.tabBarItem.badgeValue = @"99+";
        }
    } else {
        self.navigationController.tabBarItem.badgeValue = nil;
    }

}

@end
