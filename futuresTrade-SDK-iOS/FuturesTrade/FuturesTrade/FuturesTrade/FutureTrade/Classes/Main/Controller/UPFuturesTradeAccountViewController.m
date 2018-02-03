//
//  UPFuturesTradeAccountViewController.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/28.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeAccountViewController.h"
#import <FuturesTradeSDK/UPCTPModelHeader.h>
#import "UPFuturesTradeMainViewController.h"
#import "UPFuturesTradeQueryViewController.h"
#import "UPFuturesTradeTransferMainViewController.h"
#import "UPFuturesTradeCaculateUtil.h"

@interface UPFuturesTradeAccountViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dynamicEquityLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitAndLossLabel;
@property (weak, nonatomic) IBOutlet UILabel *riskyLabel;
@property (weak, nonatomic) IBOutlet UILabel *canUseLabel;
@property (weak, nonatomic) IBOutlet UILabel *canGetLabel;
@property (weak, nonatomic) IBOutlet UIView *operationView;
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;

@end

@implementation UPFuturesTradeAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBar];
    [self setupBaseScrollView];
    [self setupOperationView];
    [self queryTradingAccount:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavBar {
    self.navigationItem.title = [NSString stringWithFormat:@"期货账户%@", _rspUserLoginModel.UserID ? _rspUserLoginModel.UserID : @""];
    if (_needHideBackBtn) {
        [self hideBackBtn];
    }
}

- (void)setupBaseScrollView {
    _baseScrollView.showsVerticalScrollIndicator = NO;
    UPFuturesTradeWeakSelf(self)
    _baseScrollView.UPFuturesTrade_header = [UPFuturesTradeRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself queryTradingAccount:NO];
    }];
}

- (void)setupOperationView {
    NSArray *subviews = _operationView.subviews;
    if (subviews.count > 1) {
        return;
    }
    
    int divider = 4;
    CGFloat viewWidth = kFutursTradeScreenWidth/divider;
    CGFloat viewHeight = 80.f;
    NSArray *operations = @[
                            @{@"name":@"下单", @"image":@"futures_trade_01"},
                            @{@"name":@"委托", @"image":@"futures_trade_02"},
                            @{@"name":@"成交", @"image":@"futures_trade_03"},
                            @{@"name":@"持仓", @"image":@"futures_trade_04"},
                            @{@"name":@"查询", @"image":@"futures_trade_05"},
                            @{@"name":@"银期转账", @"image":@"futures_trade_06"}
                            ];
    
    if ([self.ctpTradeManager isTestEnvironment]) {     // 测试环境下没有转账功能
        operations = @[
                       @{@"name":@"下单", @"image":@"futures_trade_01"},
                       @{@"name":@"委托", @"image":@"futures_trade_02"},
                       @{@"name":@"成交", @"image":@"futures_trade_03"},
                       @{@"name":@"持仓", @"image":@"futures_trade_04"},
                       @{@"name":@"查询", @"image":@"futures_trade_05"}
                       ];
    }
    
    for (NSInteger i = 0; i < operations.count; i++) {
        CGSize viewSize = CGSizeMake(viewWidth, viewHeight);
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.frame = CGRectMake((i%divider)*viewWidth, (i/divider)*viewHeight, viewSize.width, viewSize.height);
        [_operationView addSubview:view];
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"FuturesTradeBundle.bundle/%@", operations[i][@"image"]]];
        CGSize imageSize = CGSizeMake(image.size.width, image.size.height);
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.frame = CGRectMake((viewSize.width - imageSize.width)/2, 15, imageSize.width, imageSize.height);
        imageView.image = image;
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = UPColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = operations[i][@"name"];
        label.frame = CGRectMake(10, imageView.frame.origin.y + imageView.frame.size.height + 13, viewSize.width - 20, 15);
        [view addSubview:label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.tag = i;
        button.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
}

#pragma mark - Query Trading Account

- (void)queryTradingAccount:(BOOL)needHint {
    UPFuturesTradeWeakSelf(self)
    [self queryTradingAccount:needHint callback:^(id result, NSError *error) {
        [weakself finishQueryingTradingAccount:needHint result:result error:error];
    }];
}

- (void)finishQueryingTradingAccount:(BOOL)needHint result:(id)result error:(NSError *)error {
    [UPHUD hideHUD:self.view];
    [_baseScrollView.UPFuturesTrade_header endRefreshing];
    if (!error) {
        self.rspTradingAccount = result;
    } else {
        if (needHint) {
            [UPHUD showToast:self.view withText:error.domain ? error.domain : @"账户查询失败"];
        }
    }
    [self reloadTradingAccount];
}

- (void)reloadTradingAccount {
    if ([self.rspTradingAccount isKindOfClass:[UPRspTradingAccountModel class]]) {
        _profitAndLossLabel.text = [UPFuturesTradeNumberUtil double2String:[UPFuturesTradeCaculateUtil profit:self.rspTradingAccount]];
        _canUseLabel.text = [UPFuturesTradeNumberUtil double2String:self.rspTradingAccount.CurrMargin];
        _canGetLabel.text = [UPFuturesTradeNumberUtil double2String:self.rspTradingAccount.Available];
        _dynamicEquityLabel.text = [UPFuturesTradeNumberUtil double2String:[UPFuturesTradeCaculateUtil dynamicEquity:self.rspTradingAccount]];
        _riskyLabel.text = [NSString stringWithFormat:@"%@%@", [UPFuturesTradeNumberUtil double2String:100.f * [UPFuturesTradeCaculateUtil risky:self.rspTradingAccount]], @"%"];
        
        [UPFuturesTradeColorUtil setupLabelColor:_profitAndLossLabel value:[UPFuturesTradeCaculateUtil profit:self.rspTradingAccount]];
        [UPFuturesTradeColorUtil setupLabelColor:_canUseLabel value:self.rspTradingAccount.CurrMargin];
        [UPFuturesTradeColorUtil setupLabelColor:_canGetLabel value:self.rspTradingAccount.Available];
        [UPFuturesTradeColorUtil setupLabelColor:_dynamicEquityLabel value:[UPFuturesTradeCaculateUtil dynamicEquity:self.rspTradingAccount]];
        [UPFuturesTradeColorUtil setupLabelColor:_riskyLabel value:[UPFuturesTradeCaculateUtil risky:self.rspTradingAccount]];
    }
}

- (void)resetTradingAccountWidgets {
    _dynamicEquityLabel.text = DEFAULT_PLACEHOLDER;
    _profitAndLossLabel.text = DEFAULT_PLACEHOLDER;
    _riskyLabel.text = DEFAULT_PLACEHOLDER;
    _canUseLabel.text = DEFAULT_PLACEHOLDER;
    _canGetLabel.text = DEFAULT_PLACEHOLDER;
}

#pragma mark - Button Clicked

- (IBAction)btnClicked:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if (tag < 4) {
        UPFuturesTradeMainViewController *tradeMainVC = [[UPFuturesTradeMainViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeMainViewController" bundle:nil tradeType:self.tradeType];
        tradeMainVC.selectedTab = tag;
        tradeMainVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tradeMainVC animated:YES];
    } else if (4 == tag) {
        UPFuturesTradeQueryViewController *queryVC = [[UPFuturesTradeQueryViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeQueryViewController" bundle:nil tradeType:self.tradeType];
        queryVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:queryVC animated:YES];
    } else if (5 == tag) {
        UPFuturesTradeTransferMainViewController *transferMainVC = [[UPFuturesTradeTransferMainViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeTransferMainViewController" bundle:nil tradeType:self.tradeType];
        transferMainVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:transferMainVC animated:YES];
    }
}

- (IBAction)logoutClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)logout {
    [UPHUD showHUD:self.view];
    UPFuturesTradeWeakSelf(self)
    [self.ctpTradeManager reqUserLogout:^(id result, NSError *error) {
        [weakself finishLogingOut:result error:error];
    }];
}

- (void)finishLogingOut:(id)result error:(NSError *)error {
    [UPHUD hideHUD:self.view];
    if (!error) {
        
    } else {
        NSLog(@"FinishLogingOut: %@", error.domain);
//        [UPHUD showToast:self.view withText:error.domain ? error.domain : @"退出登录失败"];
    }
    
    [self.navigationController popViewControllerAnimated:!_needHideBackBtn];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
        [self logout];
    }
}

#pragma mark - Refresh

- (void)refresh {
    [self queryTradingAccount:NO];
}

@end
