//
//  JYSendDynamicViewController.m
//  JYFriend
//
//  Created by ylz on 2017/1/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYSendDynamicViewController.h"
#import "JYSendDynamicTableViewCell.h"
#import "JYLocalPhotoUtils.h"
#import "JYUserImageCache.h"
#import "JYDynamicCacheUtil.h"

static NSString *const kSendDynamicTableViewCellIdentifier = @"senddynamic_tableviewcell_identifier";

typedef NS_ENUM(NSUInteger , JYDynamicSectionType) {
    JYDynamicSectionTypeMessage,
    JYDynamicSectionTypeCount
};

@interface JYSendDynamicViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *_layoutTableView;
    JYSendDynamicTableViewCell *_sendDynamicCell;
}

@property (nonatomic,retain) NSArray <JYSendDynamaicModel *>*userDynamic;//图片或者视频
@end

@implementation JYSendDynamicViewController
QBDefineLazyPropertyInitialization(NSArray, userDynamic)


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"发动态";
    @weakify(self);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"发布" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        //保存用户动态
        if ([JYUtil isVip]) {
            
            [self saveUserDynamic];
        }else {
            [[JYHudManager manager] showHudWithText:@"只有VIP会员才可以发布动态"];
        }
        

        
    }];
    

    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.tableFooterView = [UIView new];
    _layoutTableView.estimatedRowHeight = 250.;
    [_layoutTableView registerClass:[JYSendDynamicTableViewCell class] forCellReuseIdentifier:kSendDynamicTableViewCellIdentifier];
    [self.view addSubview:_layoutTableView];
    {
    [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    }
}

//保存用户动态
- (void)saveUserDynamic {
    if (self.userDynamic.count == 0 && self->_sendDynamicCell.textView.text.length == 0){
        return;
    }
    if (self.userDynamic.count == 0 && self->_sendDynamicCell.textView.text.length > 0) {
    [JYDynamicCacheUtil saveUserDynamicWithUserState:self->_sendDynamicCell.textView.text imageUrls:nil];
        [[JYHudManager manager] showHudWithText:@"发布成功,请耐心等待审核"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
 
    NSMutableArray *images = [NSMutableArray array];
    @weakify(self);
  [self.userDynamic enumerateObjectsUsingBlock:^(JYSendDynamaicModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      @strongify(self);
    if (obj.type == JYSendModelTypePicture) {
        [images addObject:obj.image];
    }else if(obj.type == JYSendModelTypeVideo){
        [JYDynamicCacheUtil saveUserVideoDyanmicWithUserState:self->_sendDynamicCell.textView.text videoUrl:obj.videoUrl];
    }
}];
    if (images.count > 0) {
        [JYDynamicCacheUtil saveUserDynamicWithUserState:self->_sendDynamicCell.textView.text imageUrls:images];
    }
    [[JYHudManager manager] showHudWithText:@"发布成功,请耐心等待审核"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return JYDynamicSectionTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == JYDynamicSectionTypeMessage) {
        
        JYSendDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSendDynamicTableViewCellIdentifier forIndexPath:indexPath];
        _sendDynamicCell = cell;
        cell.curentVC = self;
        cell.tabBar = self.tabBarController.tabBar;
        @weakify(self);
        cell.collectAction = ^(NSArray<JYSendDynamaicModel *> *models){
            @strongify(self);
        self.userDynamic = models;
        
        };
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == JYDynamicSectionTypeMessage) {
        return 250.;
    }
    return 0;
}
@end
