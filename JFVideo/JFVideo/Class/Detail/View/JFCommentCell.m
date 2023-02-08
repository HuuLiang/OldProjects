//
//  JFCommentCell.m
//  JFVideo
//
//  Created by Liang on 16/6/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFCommentCell.h"

@interface JFCommentCell ()
{
    UIImageView *_userImgV;
    UILabel *_userNameLabel;
    UILabel *_timeLabel;
    UILabel *_commentDetailLabel;
}
@end

@implementation JFCommentCell

- (instancetype)initWithHeight:(CGFloat)height
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _userImgV = [[UIImageView alloc] init];
        _userImgV.layer.cornerRadius = kScreenWidth*39/750.;
        _userImgV.layer.masksToBounds = YES;
        [self addSubview:_userImgV];
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.textColor = [[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.54];;
        _userNameLabel.textAlignment = NSTextAlignmentCenter;
        _userNameLabel.font = [UIFont systemFontOfSize:13./375. *kScreenWidth];
        [self addSubview:_userNameLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.54];;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:13./375. *kScreenWidth];
        [self addSubview:_timeLabel];
        
        _commentDetailLabel = [[UILabel alloc] init];
        _commentDetailLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _commentDetailLabel.font = [UIFont systemFontOfSize:kScreenWidth*16/375.];
        _commentDetailLabel.numberOfLines = 0;
//        _commentDetailLabel.lineBreakMode = UILineBreakModeWordWrap;
        [self addSubview:_commentDetailLabel];
        
        {
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(10);
                make.left.equalTo(self).offset(10/375.*kScreenWidth);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth*78/750., kScreenWidth*78/750.));
            }];
            
            [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_userImgV.mas_centerY);
                make.left.equalTo(_userImgV.mas_right).offset(10/375.*kScreenWidth);
                make.height.mas_equalTo(18/375. *kScreenWidth);
            }];

            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_userImgV.mas_centerY);
                make.right.equalTo(self).offset(-10);
                make.height.mas_equalTo(18/375. *kScreenWidth);
            }];
            
            [_commentDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_userImgV.mas_bottom).offset(5);
                make.left.equalTo(_userNameLabel.mas_left);
                make.right.equalTo(self).offset(-10);
                make.height.mas_equalTo(height);
            }];
        }
    }
    return self;
}

- (void)setUserImgUrl:(NSString *)userImgUrl {
    [_userImgV sd_setImageWithURL:[NSURL URLWithString:userImgUrl]];
}

- (void)setUserNameStr:(NSString *)userNameStr {
    _userNameLabel.text = userNameStr;
}

- (void)setCommentStr:(NSString *)commentStr {
    _commentDetailLabel.text = commentStr;
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeLabel.text = [self compareCurrentTime:[JFUtil dateFromString:timeStr]];
}

- (NSString *)compareCurrentTime:(NSDate*)compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    //    DLog("%f",timeInterval);
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}


@end
