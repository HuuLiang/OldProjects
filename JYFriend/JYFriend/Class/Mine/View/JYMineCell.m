//
//  JYMineCell.m
//  JYFriend
//
//  Created by Liang on 2016/12/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMineCell.h"

@implementation JYMineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:16.];
        self.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        {
            [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).mas_offset(kWidth(30));
            make.top.bottom.mas_equalTo(self.contentView);
            make.width.mas_equalTo(kWidth(88.));
           }];
    }
        self.imageView.contentMode = UIViewContentModeLeft;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.textLabel.text = title;
}

- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    self.imageView.image = iconImage;
}


@end
