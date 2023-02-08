//
//  SAMineCenterAdCell.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/7.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAMineCenterAdCell.h"

@interface SAMineCenterAdCell ()
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UILabel *label;
@property (nonatomic) CADisplayLink *displayLink;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat currentOffsetX;
@end

@implementation SAMineCenterAdCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.userInteractionEnabled = NO;
        [self.contentView addSubview:_scrollView];
        
        self.label = [[UILabel alloc] init];
        _label.textColor = kColor(@"#D6A451");
        _label.font = kFont(12);
        [_scrollView addSubview:_label];
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startScroll)];
        _displayLink.paused = YES;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        {
            [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
        }
    }
    return self;
}

- (void)startScroll {
//    NSLog(@"%@  _currentOffsetX = %f",NSStringFromCGSize(_scrollView.contentSize), _currentOffsetX);
    _currentOffsetX += 1.0f;
    if (_currentOffsetX > self.width + kScreenWidth) {
        _currentOffsetX = 0;
    }
    [_scrollView setContentOffset:CGPointMake(_currentOffsetX, 0) animated:NO];
}

- (void)setTitle:(NSString *)title {
    _label.text = title;
    self.width = [title sizeWithFont:kFont(12) maxHeight:kFont(12).lineHeight].width;
    _label.frame = CGRectMake(kScreenWidth, 0, self.width+kScreenWidth, kWidth(66));
    
    _scrollView.contentSize = CGSizeMake(self.width + kScreenWidth, kWidth(66));
    self.displayLink.paused = NO;
}

@end
