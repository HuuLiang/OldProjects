//
//  YFBMessageAdView.m
//  YFBFriend
//
//  Created by Liang on 2017/4/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessageAdView.h"

static NSString *const kYFBMessageAdCellReusableIdentifier = @"kYFBMessageAdCellReusableIdentifier";

@interface YFBMessageAdView () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) NSInteger scrollIndex;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation YFBMessageAdView
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _scrollIndex = 0;
        
        self.backgroundColor = [UIColor colorWithHexString:@"#D3B7FF"];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#D3B7FF"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[YFBMessageAdCell class] forCellReuseIdentifier:kYFBMessageAdCellReusableIdentifier];
        [self addSubview:_tableView];
        
        
        {
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
    }
    return self;
}

- (void)scrollTableView {
    if (self.dataSource.count == 0) {
        return;
    }
    
    if (self.scrollIndex >= self.dataSource.count) {
        self.scrollIndex = 0;
    }
    [self->_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.scrollIndex++ inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:self.scrollIndex != 1];
}

- (void)setRecordsArr:(NSArray *)recordsArr {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:recordsArr];
    [_tableView reloadData];
}

- (void)setScrollStart:(BOOL)scrollStart {
    if (scrollStart) {
        if (!_timer) {
            _timer =  [NSTimer timerWithTimeInterval:1 target:self selector:@selector(scrollTableView) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
        [_timer fire];
    } else {
        [_timer invalidate];
    }
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBMessageAdCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBMessageAdCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        cell.title = self.dataSource[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(48);
}

@end


@interface YFBMessageAdCell ()
@property (nonatomic) UILabel *label;
@end

@implementation YFBMessageAdCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#D3B7FF"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.label = [[UILabel alloc] init];
        _label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _label.font = [UIFont systemFontOfSize:kWidth(24)];
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
        
        {
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
        }
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _label.text = title;
}

@end
