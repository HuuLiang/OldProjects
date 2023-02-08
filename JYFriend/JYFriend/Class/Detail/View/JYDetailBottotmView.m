//
//  JYDetailBottotmView.m
//  JYFriend
//
//  Created by ylz on 2017/1/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYDetailBottotmView.h"
#import "JYDetailBottomButton.h"

@implementation JYDetailBottomModel

+ (instancetype)creatBottomModelWith:(NSString *)title withImage:(NSString *)image {
    JYDetailBottomModel *model = [[JYDetailBottomModel alloc] init];
    model.title = title;
    model.image = image;
    return model;
}

@end

@interface JYDetailBottotmView ()

@property (nonatomic,retain) NSMutableArray <JYDetailBottomButton *> *detailButtons;

@end

@implementation JYDetailBottotmView

- (instancetype)init
{
    self = [super init];
    if (self) {
    
        
    }
    return self;
}

QBDefineLazyPropertyInitialization(NSMutableArray, detailButtons)

- (void)setButtonModels:(NSArray<JYDetailBottomModel *> *)buttonModels {
    _buttonModels = buttonModels;
    if (buttonModels.count != 0 ) {
        [buttonModels enumerateObjectsUsingBlock:^(JYDetailBottomModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
            JYDetailBottomButton *button = [[JYDetailBottomButton alloc] init];
            [button setTitle:obj.title forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:obj.image] forState:UIControlStateNormal];
            if ([obj.title isEqualToString:@"关注TA"])  [button setImage:[UIImage imageNamed:@"detail_attention_selection_icon"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(currentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if (idx < buttonModels.count - 1) {
                button.hasLine = YES;
            }else {
                button.hasLine = NO;
            }
            [self.detailButtons addObject:button];
            [self addSubview:button];
        }];
    }

}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.detailButtons.count != 0) {
        CGFloat width = (kScreenWidth - (self.detailButtons.count - 1.))/self.detailButtons.count;
      [self.detailButtons enumerateObjectsUsingBlock:^(JYDetailBottomButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          
              obj.frame = CGRectMake(idx *(width +1), 0, width, self.bounds.size.height);

      }];
    }
}

- (void)currentBtnClick:(UIButton *)button {

    if (self.action) {
        self.action(button);
    }
}

- (void)setAttentionBtnSelect:(BOOL)attentionBtnSelect {
    _attentionBtnSelect = attentionBtnSelect;
    if (attentionBtnSelect) {
        [self.detailButtons enumerateObjectsUsingBlock:^(JYDetailBottomButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.titleLabel.text isEqualToString:@"关注TA"]) {
                obj.selected = YES;
                *stop = YES;
            }
        }];
    }

}


@end
