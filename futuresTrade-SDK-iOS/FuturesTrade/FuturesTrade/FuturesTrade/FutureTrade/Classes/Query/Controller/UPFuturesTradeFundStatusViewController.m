//
//  UPFuturesTradeFundStatusViewController.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/8.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeFundStatusViewController.h"
#import "UPFuturesTradeFundStatusCell.h"
#import "UPFuturesTradeFundStatusSectionHeaderView.h"
#import "UPFuturesTradeCaculateUtil.h"

@interface UPFuturesTradeFundStatusViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSMutableArray *viewModels;

@end

@implementation UPFuturesTradeFundStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupOptions];
    [self setNavBar];
    [self setupTableView];
    [self queryTradingAccount:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupOptions {
    _options = @[
                 @[@"期货账户"],
                 @[
                  @"静态权益",
                  @"动态权益",
                  @"占用保证金",
                  @"可用资金",
                  @"手续费",
                  @"下单冻结"
                 ],
                 @[
                   @"持仓盈亏",
                   @"平仓盈亏"
                  ]
                 ];
}

- (void)setNavBar {
    self.navigationItem.title = @"资金现状";
}

- (void)setupTableView {
    _table.dataSource = self;
    _table.delegate = self;
    [_table registerNib:[UINib nibWithNibName:UPFuturesTradeFundStatusCellReuseId bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FuturesTradeBundle" ofType:@"bundle"]]] forCellReuseIdentifier:UPFuturesTradeFundStatusCellReuseId];
    [_table registerNib:[UINib nibWithNibName:UPFuturesTradeFundStatusSectionHeaderViewReuseId bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FuturesTradeBundle" ofType:@"bundle"]]] forHeaderFooterViewReuseIdentifier:UPFuturesTradeFundStatusSectionHeaderViewReuseId];
    
    UPFuturesTradeWeakSelf(self)
    _table.UPFuturesTrade_header = [UPFuturesTradeRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself queryTradingAccount:NO];
    }];
}

#pragma mark - Getter
- (NSMutableArray *)viewModels {
    if (!_viewModels) {
        _viewModels = [NSMutableArray array];
    }
    return _viewModels;
}

#pragma mark - Query Trading Account

- (void)queryTradingAccount:(BOOL)needHint {
    [self queryTradingAccount:needHint callback:^(id result, NSError *error) {
        [UPHUD hideHUD:self.view];
        [_table.UPFuturesTrade_header endRefreshing];
        if (!error) {
            self.rspTradingAccount = result;
        } else {
            
        }
        [self refreshViewModels];
    }];
}

- (void)refreshViewModels {
    [self.viewModels removeAllObjects];
    for (NSInteger i = 0; i < _options.count; i++) {
        NSArray *subOptions = _options[i];
        NSMutableArray *subViewModels = [NSMutableArray array];
        for (NSInteger j = 0; j < subOptions.count; j++) {
            UPFuturesTradeFundStatusCellModel *viewModel = [[UPFuturesTradeFundStatusCellModel alloc] init];
            viewModel.identifier = _options[i][j];
            if (0 == i) {
                if (0 == j) {
                    UPRspUserLoginModel *userInfo = [self.ctpTradeManager userInfo];
                    viewModel.identifier = [NSString stringWithFormat:@"%@%@", _options[i][j], userInfo.UserID];
                }
            } else if (1 == i) {
                if (0 == j) {
                    viewModel.value = [UPFuturesTradeNumberUtil double2String:[UPFuturesTradeCaculateUtil staticEquity:self.rspTradingAccount]];
                } else if (1 == j) {
                    viewModel.value = [UPFuturesTradeNumberUtil double2String:[UPFuturesTradeCaculateUtil dynamicEquity:self.rspTradingAccount]];
                } else if (2 == j) {
                    viewModel.value = [UPFuturesTradeNumberUtil double2String:self.rspTradingAccount.CurrMargin];
                } else if (3 == j) {
                    viewModel.value = [UPFuturesTradeNumberUtil double2String:self.rspTradingAccount.Available];
                } else if (4 == j) {
                    viewModel.value = [UPFuturesTradeNumberUtil double2String:self.rspTradingAccount.Commission];
                } else if (5 == j) {
                    viewModel.value = [UPFuturesTradeNumberUtil double2String:self.rspTradingAccount.FrozenCash];
                }
            } else if (2 == i) {
                if (0 == j) {
                    viewModel.value = [UPFuturesTradeNumberUtil double2String:self.rspTradingAccount.PositionProfit];
                } else if (1 == j) {
                    viewModel.value = [UPFuturesTradeNumberUtil double2String:self.rspTradingAccount.CloseProfit];
                }
            }
            [subViewModels addObject:viewModel];
        }
        [self.viewModels addObject:[subViewModels copy]];
    }
    [self reloadTable];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.viewModels[section];
    return [arr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UPFuturesTradeFundStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:UPFuturesTradeFundStatusCellReuseId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = self.viewModels[indexPath.section];
    cell.viewModel = arr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 0;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UPFuturesTradeFundStatusSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:UPFuturesTradeFundStatusSectionHeaderViewReuseId];
    headerView.contentView.backgroundColor = UPColorFromRGB(0xf4f4f4);
    if (1 == section) {
        [headerView setupLabel:@"权益与保证金"];
    } else if (2 == section) {
        [headerView setupLabel:@"账户盈亏"];
    } else {
        [headerView setupLabel:@""];
    }
    return headerView;
}

- (void)reloadTable {
    [_table reloadData];
}

#pragma mark - Refresh

- (void)refresh {
    [self queryTradingAccount:NO];
}

@end
