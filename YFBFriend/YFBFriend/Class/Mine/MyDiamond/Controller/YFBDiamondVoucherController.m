//
//  YFBDiamondVoucherController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDiamondVoucherController.h"
#import "YFBDiamondPayTypeCell.h"
#import "YFBDiamondLabel.h"
#import "YFBPaymentManager.h"
#import "YFBSystemConfigModel.h"

static NSString *const kYFBDiamondPayTypeCellIdentifier = @"kyfb_diamond_pay_type_cell_identifier";

typedef NS_ENUM(NSUInteger, YFBDiamondPayType) {
    YFBDiamondPayTypeTitle,
    YFBDiamondPayTypePayType,
    YFBDiamondPayTypeSubTitle,
    YFBDiamondPayTypeCount
};


@interface YFBDiamondVoucherController ()<UITableViewDelegate,UITableViewDataSource>

{
    CGFloat _price;
    NSInteger _diamond;
    NSString * _payAction;
    UITableView *_layoutTableView;
    UITableViewCell *_titleCell;
    UITableViewCell *_subTitleCell;
}

@end

@implementation YFBDiamondVoucherController

- (instancetype)initWithPrice:(CGFloat)price diamond:(NSInteger)diamond
{
    return [self initWithPrice:price diamond:diamond Action:nil];
}

- (instancetype)initWithPrice:(CGFloat)price diamond:(NSInteger)diamond Action:(NSString *)payAction {
    self = [super init];
    if (self) {
        _price = price;
        _diamond = diamond;
        _payAction = payAction;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"支付订单";
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _layoutTableView.backgroundColor = kColor(@"#eeeeee");
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.tableFooterView = [UIView new];
    [_layoutTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_layoutTableView registerClass:[YFBDiamondPayTypeCell class] forCellReuseIdentifier:kYFBDiamondPayTypeCellIdentifier];
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return YFBDiamondPayTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == YFBDiamondPayTypeTitle) {
        return 1;
    }else if(section == YFBDiamondPayTypePayType){
        return 2;
    }else if (section == YFBDiamondPayTypeSubTitle){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBDiamondPayTypeTitle) {
        if (!_titleCell) {
            _titleCell = [[UITableViewCell alloc] init];
            _titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSString *descStr;
            if ([_payAction isEqualToString:kYFBPaymentActionOpenVipKeyName]) {
                descStr = [NSString stringWithFormat:@"订单信息:  充值%zd天VIP  %.1f元",_diamond,_price/100];
            } else if ([_payAction isEqualToString:kYFBPaymentActionPURCHASEDIAMONDKeyName]) {
                descStr = [NSString stringWithFormat:@"订单信息:  充值%zd钻石  %.1f元",_diamond,_price/100];
            }
            
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:descStr];
            NSString *priceStr = [NSString stringWithFormat:@"%.1f元",_price];
            [attributeStr setAttributes:@{NSForegroundColorAttributeName : kColor(@"#ffb76a")} range:NSMakeRange(attributeStr.length-priceStr.length, priceStr.length)];
            _titleCell.textLabel.attributedText = attributeStr;
        }
        return _titleCell;
        
    }else if(indexPath.section == YFBDiamondPayTypePayType){
        YFBDiamondPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBDiamondPayTypeCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.image = [UIImage imageNamed:@"mine_alipay_icon"];
            cell.title = @"支付宝";
            cell.subTitle = @"推荐支付宝用户使用";
            cell.needLine = YES;
        }else if (indexPath.row == 1){
            cell.image = [UIImage imageNamed:@"mine_wechat_pay_icon"];
            cell.title = @"微信支付";
            cell.subTitle = @"推荐开通微信支付功能的用户使用";
            cell.needLine = NO;
        }
        return cell;
    }else if (indexPath.section == YFBDiamondPayTypeSubTitle){
        if (!_subTitleCell) {
            _subTitleCell = [[UITableViewCell alloc] init];
            _subTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [qqBtn setTitle:@"QQ客服" forState:UIControlStateNormal];
            [qqBtn setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
            qqBtn.titleLabel.font = kFont(15);
            [qqBtn setBackgroundColor:kColor(@"#8458d0")];
            [_subTitleCell addSubview:qqBtn];
            
            @weakify(self);
            [qqBtn bk_addEventHandler:^(id sender) {
                @strongify(self);
                [self contactCustomerService];
            } forControlEvents:UIControlEventTouchUpInside];
            
            {
                [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(_subTitleCell).mas_offset(kWidth(-32));
                    make.left.mas_equalTo(_subTitleCell).mas_offset(kWidth(kWidth(24)));
                    make.right.mas_equalTo(_subTitleCell).mas_offset(kWidth(-20));
                    make.height.mas_equalTo(kWidth(80));
                }];
            }
            
            YFBDiamondLabel *titleLabel = [[YFBDiamondLabel alloc] init];
            titleLabel.textColor = kColor(@"#666666");
            titleLabel.font = kFont(14);
            titleLabel.numberOfLines = 0;
            titleLabel.backgroundColor = kColor(@"#e6e6e6");
            titleLabel.text = @"亲爱的用户,您的支付过程中,有任何疑惑或者疑难,欢迎在线咨询,客服妹妹会在第一时间回复并帮助您解决问题。";
            [_subTitleCell addSubview:titleLabel];
            {
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(_subTitleCell).mas_offset(kWidth(26));
                    make.left.right.mas_equalTo(qqBtn);
                    make.bottom.mas_equalTo(qqBtn.mas_top).mas_offset(kWidth(-26));
                }];
            }
        }
        return _subTitleCell;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == YFBDiamondPayTypePayType) {
        return @"选择支付方式";
    }else if (section == YFBDiamondPayTypeSubTitle){
        return @"充值疑难解答";
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBDiamondPayTypeTitle) {
        return kWidth(60);
    }else if (indexPath.section == YFBDiamondPayTypePayType){
        return kWidth(160);
    }else if (indexPath.section == YFBDiamondPayTypeSubTitle){
        return kWidth(310);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == YFBDiamondPayTypeTitle) {
        return kWidth(30);
    }else if (section == YFBDiamondPayTypePayType){
        return kWidth(62);
    }else if (section == YFBDiamondPayTypeSubTitle){
        return kWidth(62);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBDiamondPayTypePayType) {
        if (indexPath.row == 0) {
            QBLog(@"支付宝支付");
            [[YFBPaymentManager manager] payForAction:_payAction WithPayType:YFBPayTypeAliPay price:self->_price count:self->_diamond handler:^(BOOL success) {
                if (success) {
                    if (!self) {
                        return ;
                    }
                }
            }];
        } else if (indexPath.row == 1){
            QBLog(@"微信支付")
            [[YFBPaymentManager manager] payForAction:_payAction WithPayType:YFBPayTypeWeiXin price:self->_price count:self->_diamond handler:^(BOOL success) {
                if (success) {
                    if (!self) {
                        return ;
                    }
                }
            }];
            
        }
    } else if (indexPath.section == YFBDiamondPayTypeSubTitle){
        if (indexPath.row == 1) {
//            [self contactCustomerService];
        }
    }
}
//qq客服
- (void)contactCustomerService {
    NSString *contactScheme = [YFBSystemConfigModel defaultConfig].config.CONTACT_SCHEME;
    NSString *contactName = [YFBSystemConfigModel defaultConfig].config.CONTACT_NAME;
    
    if (contactScheme.length == 0) {
        return ;
    }
    
    [UIAlertView bk_showAlertViewWithTitle:nil
                                   message:[NSString stringWithFormat:@"是否联系客服%@？", contactName ?: @""]
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@[@"确认"]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         if (buttonIndex == 1) {
             if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:contactScheme]]) {
                 
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:contactScheme]];
             }
         }
     }];
}

@end
