//
//  YFBMyPhotoCell.m
//  YFBFriend
//
//  Created by Liang on 2017/3/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMyPhotoCell.h"

@interface YFBMyPhotoCell ()
@property (nonatomic,strong) UIImageView *photoImageView;
@property (nonatomic,strong) UIView *shadowView;
@property (nonatomic,strong) UILabel *noticeLabel;
@end

@implementation YFBMyPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        
        self.photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_add_photo"]];
        [self.contentView addSubview:_photoImageView];
        
        self.shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [kColor(@"#000000") colorWithAlphaComponent:0.3];
        [self.contentView addSubview:_shadowView];
        _shadowView.hidden = YES;
        
        self.noticeLabel = [[UILabel alloc] init];
        _noticeLabel.text = @"审核中";
        _noticeLabel.textColor = kColor(@"#F5C73D");
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
        _noticeLabel.font = kFont(10);
        [_shadowView addSubview:_noticeLabel];
        
        {
            [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
            
            [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.contentView);
                make.height.mas_equalTo(kWidth(kWidth(40)));
            }];
            
            [_noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_shadowView);
            }];
        }
        
    }
    return self;
}

- (void)setImageKeyName:(NSString *)imageKeyName {
    _shadowView.hidden = NO;
    NSString *imageKey = [[[[imageKeyName componentsSeparatedByString:@"_"] lastObject] componentsSeparatedByString:@"."] firstObject];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageKey];
    if (image) {
        _photoImageView.image = image;
    } else {
        [_photoImageView sd_setImageWithURL:[NSURL URLWithString:imageKeyName] placeholderImage:[UIImage imageNamed:@"mine_add_photo"]];
    }
}

- (void)setFunctionCell:(BOOL)functionCell {
    if (functionCell) {
        _shadowView.hidden = YES;
        _photoImageView.image = [UIImage imageNamed:@"mine_add_photo"];
    }
}

@end
