
//
//  JYMyPhotoCell.m
//  JYFriend
//
//  Created by ylz on 2016/12/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMyPhotoCell.h"

@interface JYMyPhotoCell ()

{
    UIImageView *_imageView;
}

@property (nonatomic,retain) UIButton *deleteBtn;

@end

@implementation JYMyPhotoCell

- (UIButton *)deleteBtn{
    if (_deleteBtn) {
        return _deleteBtn;
    }
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];//[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_photo_delete_icon"]];
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"mine_photo_delete_icon"] forState:UIControlStateNormal];
    _deleteBtn.userInteractionEnabled = NO;
    [self addSubview:_deleteBtn];
    {
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_imageView.mas_right).mas_offset(kWidth(-5));
        make.centerY.mas_equalTo(_imageView.mas_top).mas_offset(kWidth(5));
        make.size.mas_equalTo(CGSizeMake(kWidth(36), kWidth(36)));
    }];
    }
//    @weakify(self);
//    [_deleteBtn bk_addEventHandler:^(id sender) {
//        @strongify(self);
//        QBSafelyCallBlock(self.action,self);
//    } forControlEvents:UIControlEventTouchUpInside];
    return _deleteBtn;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor redColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        {
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(self);
            make.left.bottom.mas_equalTo(self);
            make.top.mas_equalTo(self).mas_offset(kWidth(15));
            make.right.mas_equalTo(self).mas_offset(kWidth(-15));
        }];
        }
        
    }
    return self;
}


- (void)setIsAdd:(BOOL)isAdd {
    _isAdd = isAdd;
    if (isAdd) {
        _imageView.image = [UIImage imageNamed:@"mine_photo_add"];
    } else {
        _imageView.image = nil;
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
    }

- (void)setIsDelegate:(BOOL)isDelegate {
    _isDelegate = isDelegate;
    if (isDelegate) {
        self.deleteBtn.hidden = NO;
    }else{
        _deleteBtn.hidden = YES;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id view = [super hitTest:point withEvent:event];
    
    if (!view) {
        return view;
    }
    CGRect buttonFrame = _deleteBtn.frame;
    if (CGRectIsEmpty(buttonFrame)) {
        return view;
    }
    CGRect expandedFrame = CGRectInset(buttonFrame, -10, -10);
    if (CGRectContainsPoint(expandedFrame, point)) {
        return _deleteBtn;
    }
    return view;
}

@end
