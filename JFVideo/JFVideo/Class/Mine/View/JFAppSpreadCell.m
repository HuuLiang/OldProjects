//
//  JFAppSpreadCell.m
//  JFVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFAppSpreadCell.h"

@interface JFAppSpreadCell ()
{
    UIImageView *_bgImgv;
    UILabel *_title;
    
    UIView *_isInstallView;
    UILabel *_isInstallLabel;
}
@end

@implementation JFAppSpreadCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = kScreenWidth * 30/750.;
        self.layer.masksToBounds = YES;
        
        _bgImgv = [[UIImageView alloc] init];
        _bgImgv.backgroundColor = [UIColor clearColor];
        _bgImgv.layer.cornerRadius = kScreenWidth * 30/750.;
        _bgImgv.layer.masksToBounds = YES;
        [self addSubview:_bgImgv];
        
        _title = [[UILabel alloc] init];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont systemFontOfSize:kScreenWidth * 28/750.];
        _title.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [self addSubview:_title];
        
        _isInstallView = [[UIView alloc] init];
        _isInstallView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.7];
        _isInstallView.layer.cornerRadius = kScreenWidth * 30/750.;
        _isInstallView.layer.masksToBounds = YES;
        [self addSubview:_isInstallView];
        
        _isInstallLabel = [[UILabel alloc] init];
        _isInstallLabel.textAlignment = NSTextAlignmentCenter;
        _isInstallLabel.text = @"已安装";
        _isInstallLabel.backgroundColor = [UIColor clearColor];
        _isInstallLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _isInstallLabel.font = [UIFont systemFontOfSize:15.];
        [_isInstallView addSubview:_isInstallLabel];
        
        {
            [_bgImgv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self);
                make.height.mas_equalTo(self.frame.size.width);
            }];
            
            [_title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bgImgv.mas_bottom).offset(5);
                make.centerX.equalTo(self);
                make.height.mas_equalTo(20);
            }];
            
            [_isInstallView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self);
                make.height.mas_equalTo(self.frame.size.width);
            }];
            
            [_isInstallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(_isInstallView.center);
                make.height.mas_equalTo(20);
            }];
        }
        
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr {
    _title.text = titleStr;
}

- (void)setImgUrl:(NSString *)imgUrl {
    [_bgImgv sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

- (void)setIsInstall:(BOOL)isInstall {
    _isInstallView.hidden = !isInstall;
}


@end
