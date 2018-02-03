//
//  UPFuturesTradeTradeViewController.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/6.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeTradeViewController.h"
#import "UPFuturesTradeOrderCell.h"
#import "UPFuturesTradeOrderHeaderCell.h"
#import "UPFuturesTradeChooseDateView.h"
#import "UPFuturesTradeUIDatePickerView.h"

@interface UPFuturesTradeTradeViewController () <UITableViewDataSource, UITableViewDelegate, UPFuturesTradeUIDatePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray *trades;
@property (strong, nonatomic) UPFuturesTradeChooseDateView *tradeDateChooseView;

@property (nonatomic, strong) UPFuturesTradeUIDatePickerView *startDatePicker;
@property (nonatomic, strong) UPFuturesTradeUIDatePickerView *endDatePicker;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;

@end

@implementation UPFuturesTradeTradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBar];
    [self setupTableView];
    [self queryTrades:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavBar {
    self.navigationItem.title = @"成交查询";
}

- (void)setupTableView {
    _table.dataSource = self;
    _table.delegate = self;
    [_table registerNib:[UINib nibWithNibName:UPFuturesTradeOrderHeaderCellReuseId bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FuturesTradeBundle" ofType:@"bundle"]]] forCellReuseIdentifier:UPFuturesTradeOrderHeaderCellReuseId];
    [_table registerNib:[UINib nibWithNibName:UPFuturesTradeOrderCellReuseId bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FuturesTradeBundle" ofType:@"bundle"]]] forCellReuseIdentifier:UPFuturesTradeOrderCellReuseId];
    
    if (_setupHeaderView) {
        [self setupTableHeaderView];
    }
    
    UPFuturesTradeWeakSelf(self)
    _table.UPFuturesTrade_header = [UPFuturesTradeRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself queryTrades:NO];
    }];
}

- (void)setupTableHeaderView {
    [self setupDatePicker];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.frame = CGRectMake(0, 0, kFutursTradeScreenWidth, 70);
    
    UPFuturesTradeWeakSelf(self)
    _tradeDateChooseView = [UPFuturesTradeChooseDateView futuresTradeChooseDateView];
    _tradeDateChooseView.frame = CGRectMake(0, 0, headerView.bounds.size.width, 60);
    _tradeDateChooseView.block = ^(NSInteger dateType) {
        if (0 == dateType) {
            [weakself.startDatePicker showWith];
        } else if (1 == dateType) {
            [weakself.endDatePicker showWith];
        }
    };
    [headerView addSubview:_tradeDateChooseView];
    
    _table.tableHeaderView = headerView;
}

- (void)setupDatePicker {
    _startDatePicker = [[UPFuturesTradeUIDatePickerView alloc] init];
    _startDatePicker.delegate = self;
    [_startDatePicker loadTheDateView:@"选择起始日期" withMaxDate:[NSDate date] withMinDate:nil];
    _startDatePicker.theDatePicker.datePickerMode = UIDatePickerModeDate;
    _startDatePicker.dateFormat = @"yyyy年MM月dd日";
    [self.view addSubview:_startDatePicker];
    
    _endDatePicker = [[UPFuturesTradeUIDatePickerView alloc] init];
    _endDatePicker.delegate = self;
    [_endDatePicker loadTheDateView:@"选择截止日期" withMaxDate:[NSDate date] withMinDate:nil];
    _endDatePicker.theDatePicker.datePickerMode = UIDatePickerModeDate;
    _endDatePicker.dateFormat = @"yyyy年MM月dd日";
    [self.view addSubview:_endDatePicker];
    
    _startDate = [UPBaseDateUtil currentDate:@"yyyyMMdd"];
    _endDate = [_startDate copy];
}

#pragma mark - Getter

- (NSMutableArray *)trades {
    if (!_trades) {
        _trades = [NSMutableArray array];
    }
    return _trades;
}

#pragma mark - Query Trades

- (void)queryTrades:(BOOL)needHint {
    if (_startDate && _endDate) {
        if (NSOrderedDescending == [_startDate compare:_endDate]) {
            if (needHint) {
                [UPHUD showToast:self.view withText:@"起始日期不能晚于截止日期"];
            }
            return;
        }
    }
    
    if (needHint) {
        [UPHUD showHUD:self.view];
    }
    
    UPFuturesTradeWeakSelf(self)
    [self.ctpTradeManager reqQueryTrade:nil timeStart:_startDate timeEnd:_endDate callback:^(id result, NSError *error) {
        [weakself finishQueryingTrades:result error:error];
    }];
}

- (void)finishQueryingTrades:(id)result error:(NSError *)error {
    [UPHUD hideHUD:self.view];
    [self.table.UPFuturesTrade_header endRefreshing];
    [self.trades removeAllObjects];
    NSArray *trades = result;
    if (UPFuturesTradeIsValidateArr(trades)) {
        [self.trades addObjectsFromArray:trades];
    }
    [self reloadTable];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return UPFuturesTradeIsValidateArr(self.trades) ? self.trades.count + 1 : 1;
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
        [cell setupIdentifiers:@[@"成交价/量", @"方向", @"成交时间", @"成交编号"]];
        return cell;
    } else {
        UPFuturesTradeOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:UPFuturesTradeOrderCellReuseId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tradeType = self.tradeType;
        if (self.trades.count > indexPath.row - 1) {
            cell.viewModel = self.trades[indexPath.row - 1];
        }
        [cell setupOperationShowStatus:NO];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)reloadTable {
    [_table reloadData];
}

#pragma mark - UPFuturesTradeUIDatePickerViewDelegate

- (void)datePickerView:(UPFuturesTradeUIDatePickerView *)pickerView didSelectedDate:(NSString *)theDateString {
    if (pickerView == _startDatePicker) {
        _startDate = [self replaceYearMonthDayWithPlaceholder:theDateString];
        [_tradeDateChooseView setupStartDate:theDateString];
        [self queryTrades:YES];
    } else if (pickerView == _endDatePicker) {
        _endDate = [self replaceYearMonthDayWithPlaceholder:theDateString];
        [_tradeDateChooseView setupEndDate:theDateString];
        [self queryTrades:YES];
    }
}

- (NSString *)replaceYearMonthDayWithPlaceholder:(NSString *)date {
    if (date.length > 0) {
        NSString *tmpDate = [date copy];
        tmpDate = [tmpDate stringByReplacingOccurrencesOfString:@"年" withString:@""];
        tmpDate = [tmpDate stringByReplacingOccurrencesOfString:@"月" withString:@""];
        tmpDate = [tmpDate stringByReplacingOccurrencesOfString:@"日" withString:@""];
        return [tmpDate copy];
    }
    return date;
}

#pragma mark - Refresh

- (void)refresh {
    [self queryTrades:NO];
}

@end
