//
//  YFBCommentsVC.m
//  YFBFriend
//
//  Created by ZF on 2017/6/6.
//  Copyright © 2017年 ZF. All rights reserved.
//

#import "YFBCommentsVC.h"
#import "YFBSocialModel.h"
#import "YFBCommentCell.h"

static NSString *const kYFBSocialCommentCellReusableIdentifier = @"kYFBSocialCommentCellReusableIdentifier";

@interface YFBCommentsVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray <YFBCommentModel *> * dataSource;
@property (nonatomic) NSMutableArray *heights;
@property (nonatomic) NSInteger allServNum;
@end

@implementation YFBCommentsVC
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(NSMutableArray, heights);

- (instancetype)initWithComments:(NSArray *)comments allServNum:(NSInteger)allServNum {
    self = [super init];
    if (self) {
        [self.dataSource addObjectsFromArray:comments];
        self.allServNum = allServNum;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"全部评价";
    
    self.view.backgroundColor = kColor(@"#efefef");
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColor(@"#efefef");
    [_tableView registerClass:[YFBCommentCell class] forCellReuseIdentifier:kYFBSocialCommentCellReusableIdentifier];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:_tableView];
    
    _tableView.tableFooterView = [[UIView alloc] init];

    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self calculateCommentHeight];
}

- (void)calculateCommentHeight {
    [_tableView YFB_triggerPullToRefresh];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *options = [NSMutableArray array];
        YFBCommentModel *lastComment = [self.dataSource lastObject];
        NSTimeInterval lastTimeInterval = lastComment.timeinterval;
        
        [self.dataSource enumerateObjectsUsingBlock:^(YFBCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [options addObject:obj.serv];
        }];
        
         NSInteger optionsCount = options.count;
        
        if (_allServNum > self.dataSource.count) {
            for (NSInteger i = 0; (i = _allServNum - self.dataSource.count); i++) {
                YFBCommentModel *commentModel = [[YFBCommentModel alloc] init];
                commentModel.nickName = @"匿***户";
                commentModel.serv = options[i % optionsCount];
                lastTimeInterval -= 60 * 60 * (arc4random() % 3 + 0.5);
                commentModel.timeinterval = lastTimeInterval;
                commentModel.content = @"系统默认好评!";
                [self.dataSource addObject:commentModel];
            }
        }
        
        
        __block CGFloat lastCommentHeight = 0;
        [self.dataSource enumerateObjectsUsingBlock:^(YFBCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx <= optionsCount) {
                CGFloat commentContentHeight = [obj.content sizeWithFont:kFont(12) maxWidth:kWidth(690)].height;
                CGFloat commentHeight = kWidth(30) + kFont(14).lineHeight + kWidth(10) + kFont(12).lineHeight + kWidth(30) + commentContentHeight + kWidth(40);
                [self.heights addObject:@(commentHeight)];
                lastCommentHeight = commentHeight;
            } else {
                [self.heights addObject:@(lastCommentHeight)];
            }
            QBLog(@"%ld======%f",idx,obj.timeinterval);
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            [_tableView YFB_endPullToRefresh];
        });
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBSocialCommentCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        YFBCommentModel *commentModel = self.dataSource[indexPath.row];
        cell.nickName = commentModel.nickName;
        cell.serverOption = commentModel.serv;
        cell.timeStr = [YFBUtil timeStringFromDate:[NSDate dateWithTimeIntervalSince1970:commentModel.timeinterval] WithDateFormat:kDateFormatShort];
        cell.commentStr = commentModel.content;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.heights.count) {
        return [self.heights[indexPath.row] floatValue];
    }
    return 0;
}

@end
