//
//  UPFuturesTradeQueryViewController.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/7.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeQueryViewController.h"
#import "UPFuturesTradeQueryCell.h"
#import "UPFuturesTradeTradeViewController.h"
#import "UPFuturesTradeFundStatusViewController.h"
#import "UPFuturesTradeOrderViewController.h"

@interface UPFuturesTradeQueryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, copy) NSArray *options;

@end

@implementation UPFuturesTradeQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupNavBar];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavBar {
    self.navigationItem.title = @"查询";
}

- (void)setupTableView {
    _table.dataSource = self;
    _table.delegate = self;
    [_table registerNib:[UINib nibWithNibName:UPFuturesTradeQueryCellReuseId bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FuturesTradeBundle" ofType:@"bundle"]]] forCellReuseIdentifier:UPFuturesTradeQueryCellReuseId];
}

- (NSArray *)options {
    if (!_options) {
        _options = @[
                     @"资金现状"/*,
                     @"委托查询",
                     @"成交查询"*/
                     ];
    }
    return _options;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UPFuturesTradeQueryCell *cell = [tableView dequeueReusableCellWithIdentifier:UPFuturesTradeQueryCellReuseId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell setupNameLabel:self.options[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (0 == indexPath.row) {
        UPFuturesTradeFundStatusViewController *fundStatusVC = [[UPFuturesTradeFundStatusViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeFundStatusViewController" bundle:nil tradeType:self.tradeType];
        [self.navigationController pushViewController:fundStatusVC animated:YES];
    } else if (1 == indexPath.row) {
        UPFuturesTradeOrderViewController *orderVC = [[UPFuturesTradeOrderViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeOrderViewController" bundle:nil tradeType:self.tradeType];
        [self.navigationController pushViewController:orderVC animated:YES];
    } else if (2 == indexPath.row) {
        UPFuturesTradeTradeViewController *tradeVC = [[UPFuturesTradeTradeViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeTradeViewController" bundle:nil tradeType:self.tradeType];
        tradeVC.setupHeaderView = YES;
        [self.navigationController pushViewController:tradeVC animated:YES];
    }
}

@end
