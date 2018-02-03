//
//  UPFuturesTradeOrderViewController.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/5.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeOrderViewController.h"
#import "UPFuturesTradeOrderCell.h"
#import "UPFuturesTradeOrderHeaderCell.h"
#import "UPFuturesTradeOrderActionModel.h"

@interface UPFuturesTradeOrderViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray *orders;

@end

@implementation UPFuturesTradeOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBar];
    [self setupTableView];
    [self queryOrders:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavBar {
    self.navigationItem.title = @"委托查询";
}

- (void)setupTableView {
    _table.dataSource = self;
    _table.delegate = self;
    [_table registerNib:[UINib nibWithNibName:UPFuturesTradeOrderHeaderCellReuseId bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FuturesTradeBundle" ofType:@"bundle"]]] forCellReuseIdentifier:UPFuturesTradeOrderHeaderCellReuseId];
    [_table registerNib:[UINib nibWithNibName:UPFuturesTradeOrderCellReuseId bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FuturesTradeBundle" ofType:@"bundle"]]] forCellReuseIdentifier:UPFuturesTradeOrderCellReuseId];
    
    UPFuturesTradeWeakSelf(self)
    _table.UPFuturesTrade_header = [UPFuturesTradeRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself queryOrders:NO];
    }];
}

#pragma mark - Getter

- (NSMutableArray *)orders {
    if (!_orders) {
        _orders = [NSMutableArray array];
    }
    return _orders;
}

#pragma mark - Query Orders

- (void)queryOrders:(BOOL)needHint {
    if (needHint) {
        [UPHUD showHUD:self.view];
    }
    UPFuturesTradeWeakSelf(self)
    [self.ctpTradeManager reqQueryOrder:nil callback:^(id result, NSError *error) {
        [weakself finishQueryingOrders:result error:error];
    }];
}

- (void)finishQueryingOrders:(id)result error:(NSError *)error {
    [UPHUD hideHUD:self.view];
    [_table.UPFuturesTrade_header endRefreshing];
    [self.orders removeAllObjects];
    NSArray *orders = result;
    if (UPFuturesTradeIsValidateArr(orders)) {
        [self.orders addObjectsFromArray:orders];
    }
    [self reloadTable];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return UPFuturesTradeIsValidateArr(self.orders) ? self.orders.count + 1 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        return 30;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        UPFuturesTradeOrderHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:UPFuturesTradeOrderHeaderCellReuseId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UPFuturesTradeOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:UPFuturesTradeOrderCellReuseId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.tradeType = self.tradeType;
        if (self.orders.count > indexPath.row - 1) {
            cell.viewModel = self.orders[indexPath.row - 1];
        }
        [cell setupOperationShowStatus:NO];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self orderAction:indexPath.row - 1];
    }
}

- (void)reloadTable {
    [_table reloadData];
}

#pragma mark - Order Action

- (void)orderAction:(NSInteger)index {
    if (self.orders.count > index) {
        UPRspOrderModel *orderModel = self.orders[index];
        UPFuturesTradeWeakSelf(self)
        [self.orderConfirmAlert showOrderActionConfirmAlert:orderModel block:^(id model) {
            [weakself deleteOrder:model];
        }];
    }
}

- (void)deleteOrder:(UPFuturesTradeOrderActionModel *)orderActionModel {
    if (orderActionModel) {
        [UPHUD showHUD:self.view];
        UPFuturesTradeWeakSelf(self)
        [self.ctpTradeManager reqOrderAction:orderActionModel.instrumentID orderRef:orderActionModel.orderRef frontID:orderActionModel.frontID sessionID:orderActionModel.sessionID exchangeID:orderActionModel.exchangeID callback:^(id result, NSError *error) {
            [weakself finishDeletingOrder:result error:error];
        }];
    }
}

- (void)finishDeletingOrder:(id)result error:(NSError *)error {
    [UPHUD hideHUD:self.view];
    if (!error) {
        [UPHUD showToast:self.view withText:@"撤单成功"];
        [self queryOrders:NO];
    } else {
        [UPHUD showToast:self.view withText:UPFuturesTradeIsValidateString(error.domain)?error.domain:@"撤单失败"];
    }
}

#pragma mark - Refresh

- (void)refresh {
    [self queryOrders:NO];
}

@end
