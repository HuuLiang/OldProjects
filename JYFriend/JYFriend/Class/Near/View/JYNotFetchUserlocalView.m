//
//  JYNotFetchUserlocalView.m
//  JYFriend
//
//  Created by ylz on 2016/12/24.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYNotFetchUserlocalView.h"


@implementation JYNotFetchUserlocalView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:kWidth(32.)];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.numberOfLines = 0;
        titleLabel.text = @"应用未开启定位服务,请前往系统设置允许定位服务。";
        [self addSubview:titleLabel];
        {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self).mas_offset(kScreenWidth *0.15);
            make.width.mas_equalTo(kScreenWidth *0.7);
        }];
        }
        
        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        settingBtn.backgroundColor = [UIColor colorWithHexString:@"#249bd3"];
        [settingBtn setTitle:@"前往设置" forState:UIControlStateNormal];
        [settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        settingBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(40.)];
        [self addSubview:settingBtn];
        {
        [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.width.mas_equalTo(kScreenWidth *0.4);
            make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(kScreenWidth *0.15);
            make.height.mas_equalTo(kWidth(80.));
        }];
        }
        
        @weakify(self);
        [settingBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.settingAction) {
                self.settingAction(sender);
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}


@end
