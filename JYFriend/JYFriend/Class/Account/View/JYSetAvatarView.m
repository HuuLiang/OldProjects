//
//  JYSetAvatarView.m
//  JYFriend
//
//  Created by Liang on 2016/12/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYSetAvatarView.h"

@interface JYSetAvatarView ()
{
    UIImageView     *_userImgV;
    UIButton        *_photoBtn;
}
@end

@implementation JYSetAvatarView

- (instancetype)initWithFrame:(CGRect)frame action:(void (^)(void))handler
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColor(@"#ffffff");
        
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoBtn setTitle:@"添加头像" forState:UIControlStateNormal];
        [_photoBtn setTitleColor:kColor(@"#999999") forState:UIControlStateNormal];
        _photoBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(24)];
        [_photoBtn setImage:[UIImage imageNamed:@"login_addphoto"] forState:UIControlStateNormal];
        [self addSubview:_photoBtn];
        
        _userImgV = [[UIImageView alloc] init];
        _userImgV.userInteractionEnabled = YES;
        [self addSubview:_userImgV];
        
        [_userImgV bk_whenTapped:^{
            handler();
        }];
        
        {
            [_photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_userImgV);
                make.size.mas_equalTo(CGSizeMake(kWidth(165), kWidth(165)));
            }];
            
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(170), kWidth(170)*13/11));
            }];
        }
        
        [self setNeedsDisplay];
    }
    return self;
}

- (void)setUserImg:(UIImage *)userImg {
    _userImgV.image = userImg;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGSize size = [_photoBtn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, _photoBtn.titleLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _photoBtn.titleLabel.font} context:nil].size;
    
    if ([JYUtil deviceType] >= JYDeviceType_iPhone6) {
        _photoBtn.imageEdgeInsets =UIEdgeInsetsMake(-0.5*size.height-10, 0.5*size.width, 0.5*size.height, -0.5*size.width);
        _photoBtn.titleEdgeInsets =UIEdgeInsetsMake(0.5*_photoBtn.imageView.frame.size.height+10, -0.5*_photoBtn.imageView.frame.size.width, -0.5*_photoBtn.imageView.frame.size.height, 0.5*_photoBtn.imageView.frame.size.width);
    } else {
        _photoBtn.imageEdgeInsets =UIEdgeInsetsMake(-0.5*size.height-10, 0.4*size.width, 0.5*size.height, -0.4*size.width);
        _photoBtn.titleEdgeInsets =UIEdgeInsetsMake(0.5*_photoBtn.imageView.frame.size.height+10, -0.8*_photoBtn.imageView.frame.size.width, -0.5*_photoBtn.imageView.frame.size.height, 0.2*_photoBtn.imageView.frame.size.width);
    }

    
    CGRect frame = _userImgV.frame;
    frame.origin.x += 1.5;
    frame.origin.y += 1.5;
    frame.size.width -= 3;
    frame.size.height -= 3;
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, kColor(@"#CBCBCB").CGColor);
    CGFloat lengths[] = {7,3};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, frame.origin.x, frame.origin.y);
    CGContextAddLineToPoint(context, frame.origin.x+frame.size.width,frame.origin.y);
    CGContextAddLineToPoint(context, frame.origin.x+frame.size.width, frame.origin.y+frame.size.height);
    CGContextAddLineToPoint(context, frame.origin.x, frame.origin.y+frame.size.height);
    CGContextAddLineToPoint(context, frame.origin.x, frame.origin.y);
    CGContextStrokePath(context);
    CGContextClosePath(context);
}
@end
