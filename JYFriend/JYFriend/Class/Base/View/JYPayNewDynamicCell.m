//
//  JYNewDynamicCell.m
//  JYFriend
//
//  Created by ylz on 2017/1/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYPayNewDynamicCell.h"

static NSString *const kJYFrientScrollTitleKeyName = @"kJYFrientScrollTitleKeyName";

@interface JYPayNewDynamicCell () <UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_titleLable;
    UIImageView *_imgV;
    UILabel *_dynamicLabel;
    
    UITableView *_tableView;
    BOOL _startScroll;
    NSInteger _currentIndex;
}

@end

@implementation JYPayNewDynamicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = [UIFont systemFontOfSize:kWidth(30)];
        _titleLable.textColor = [UIColor colorWithHexString:@"#E147A5"];
        _titleLable.text = @"最新动态";
        [self.contentView addSubview:_titleLable];
        
        UIImageView *grayLine = [[UIImageView alloc] init];
        grayLine.backgroundColor = kColor(@"#DADADA");
        [self.contentView addSubview:grayLine];
        
        _imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_play"]];
        [self.contentView addSubview:_imgV];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kJYFrientScrollTitleKeyName];
        _tableView.userInteractionEnabled = NO;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.contentView addSubview:_tableView];
        
        UIImageView *redLine = [[UIImageView alloc] init];
        redLine.backgroundColor = kColor(@"#FBDCEF");
        [self.contentView addSubview:redLine];
        
        {
            [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.height.mas_equalTo(kWidth(30));
            }];
            
            [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(_titleLable.mas_right).offset(kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(1), kWidth(30)));
            }];
            
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(grayLine.mas_right).offset(kWidth(36));
                make.size.mas_equalTo(CGSizeMake(kWidth(36), kWidth(36)));
            }];
            
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_imgV.mas_right).offset(kWidth(1));
                make.right.equalTo(self.contentView);
                make.top.equalTo(self.contentView.mas_top).offset(kWidth(1));
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-kWidth(1));
            }];
            
            [redLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(self.contentView);
                make.height.mas_equalTo(kWidth(1));
            }];
        }
    }
    
    return self;
}

- (void)setScrollContents:(NSArray *)scrollContents {
    _scrollContents = scrollContents;
    [_tableView reloadData];
    if (_scrollContents.count > 0) {
        _startScroll = YES;
        _currentIndex = 0;
    } else {
        _startScroll = NO;
        _currentIndex = 0;
    }
    [self performSelector:@selector(scrollTitle) withObject:nil afterDelay:1];
}

- (void)scrollTitle {
    if (_currentIndex < _scrollContents.count) {
        [_tableView setContentOffset:CGPointMake(0, kWidth(60)*_currentIndex++) animated:YES];
    } else {
        _currentIndex = 0;
        [_tableView setContentOffset:CGPointZero animated:NO];
    }
    if (_startScroll) {
        [self performSelector:@selector(scrollTitle) withObject:nil afterDelay:2];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _scrollContents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJYFrientScrollTitleKeyName forIndexPath:indexPath];
    if (indexPath.row < _scrollContents.count) {
        cell.textLabel.textColor = kColor(@"#E147A5");
        cell.textLabel.font = [UIFont systemFontOfSize:kWidth(26)];
        cell.textLabel.text = _scrollContents[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(60);
}

@end
