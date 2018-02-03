//
//  UPFuturesTradeTransferSerialViewController.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/8.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeTransferSerialViewController.h"
#import "UPFuturesTradeTransferSerialCell.h"
#import "UPFuturesTradeTransferSerialSectionHeaderView.h"
#import "UPBaseDateUtil.h"

@interface UPFuturesTradeTransferSerialViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) NSMutableArray *serials;
@property (nonatomic, strong) NSMutableArray *tradeDates;

@end

@implementation UPFuturesTradeTransferSerialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableView];
    [self queryTransferSerial:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTableView {
    _table.dataSource = self;
    _table.delegate = self;
    [_table registerNib:[UINib nibWithNibName:UPFuturesTradeTransferSerialCellReuseId bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FuturesTradeBundle" ofType:@"bundle"]]] forCellReuseIdentifier:UPFuturesTradeTransferSerialCellReuseId];
    [_table registerNib:[UINib nibWithNibName:UPFuturesTradeTransferSerialSectionHeaderViewReuseId bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FuturesTradeBundle" ofType:@"bundle"]]] forHeaderFooterViewReuseIdentifier:UPFuturesTradeTransferSerialSectionHeaderViewReuseId];
    
    UPFuturesTradeWeakSelf(self)
    _table.UPFuturesTrade_header = [UPFuturesTradeRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself queryTransferSerial:NO];
    }];
}

#pragma mark - Getter
- (NSMutableArray *)serials {
    if (!_serials) {
        _serials = [NSMutableArray array];
    }
    return _serials;
}

- (NSMutableArray *)tradeDates {
    if (!_tradeDates) {
        _tradeDates = [NSMutableArray array];
    }
    return _tradeDates;
}

#pragma mark - Load Data
- (void)queryTransferSerial:(BOOL)needHint {
    if (needHint) {
        [UPHUD showHUD:self.view];
    }
    
    UPFuturesTradeWeakSelf(self)
    [self.ctpTradeManager reqQueryTransferSerial:^(id result, NSError *error) {
        [weakself finishQueryingTransferSerial:result error:error needHint:needHint];
    }];
}

- (void)finishQueryingTransferSerial:(id)result error:(NSError *)error needHint:(BOOL)needHint {
    [UPHUD hideHUD:self.view];
    [_table.UPFuturesTrade_header endRefreshing];
    if (!error) {
        NSArray<UPRspTransferSerialModel *> *serialModels = result;
        [self assembleSerialData:[serialModels copy]];
        [self reloadTable];
    } else {
        if (needHint) {
            [UPHUD showToast:self.view withText:UPFuturesTradeIsValidateString(error.domain)?error.domain:@"查询转账流水失败"];
        }
    }
}

- (void)assembleSerialData:(NSArray *)serialModels {
    if (serialModels.count > 0) {
        [self.tradeDates removeAllObjects];
        [self.serials removeAllObjects];
        NSArray *sortedSerialModels = [serialModels sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            UPRspTransferSerialModel *transferSerialModel1 = obj1;
            UPRspTransferSerialModel *transferSerialModel2 = obj2;
            return [[transferSerialModel2.TradeDate stringByAppendingString:transferSerialModel2.TradeTime] compare:[transferSerialModel1.TradeDate stringByAppendingString:transferSerialModel1.TradeTime]];
        }];
        
        for (UPRspTransferSerialModel *transferSerialModel in sortedSerialModels) {
            NSString *tradeDate = transferSerialModel.TradeDate;
            if (![self containsTheMonth:tradeDate]) {
                [self.tradeDates addObject:tradeDate];
            }
        }
        
        NSInteger index = 0;
        for (NSInteger i = 0; i < self.tradeDates.count; i++) {
            NSMutableArray *tmpArr = [NSMutableArray array];
            for (; index < sortedSerialModels.count; index++) {
                UPRspTransferSerialModel *transferSerialModel = sortedSerialModels[index];
                if (transferSerialModel) {
                    [tmpArr addObject:transferSerialModel];
                }
            }
            [self.serials addObject:[tmpArr copy]];
        }
    }
}

- (BOOL)containsTheMonth:(NSString *)tradeDate {
    if (tradeDate) {
        for (NSString *date in self.tradeDates) {
            if ([self isSameMonth:date destinateDate:tradeDate]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)isSameMonth:(NSString *)sourceDate destinateDate:(NSString *)destinateDate {
    if (8 == sourceDate.length && sourceDate.length == destinateDate.length) {
        NSString *month = [sourceDate substringToIndex:6];
        NSString *tradeMonth = [destinateDate substringToIndex:6];
        if ([month isEqual:tradeMonth]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.serials.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.serials[section];
    return [arr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UPFuturesTradeTransferSerialCell *cell = [tableView dequeueReusableCellWithIdentifier:UPFuturesTradeTransferSerialCellReuseId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.serials.count > indexPath.section) {
        NSArray *arr = self.serials[indexPath.section];
        if (arr.count > indexPath.row) {
            cell.serialModel = arr[indexPath.row];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UPFuturesTradeTransferSerialSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:UPFuturesTradeTransferSerialSectionHeaderViewReuseId];
    headerView.contentView.backgroundColor = UPColorFromRGB(0xF4F4F4);
    if (self.tradeDates.count > section) {
        NSString *tradeDate = self.tradeDates[section];
        [headerView setupLabel:[self monthFromTradeDate:tradeDate]];
    } else {
        [headerView setupLabel:EMPTY];
    }
    return headerView;
}

- (void)reloadTable {
    [_table reloadData];
}

#pragma mark - MonthFromTradeDate

- (NSString *)monthFromTradeDate:(NSString *)tradeDate {
    NSString *month = EMPTY;
    NSString *currentDate = [UPBaseDateUtil currentDate:@"yyyyMMdd"];
    if ([self isSameMonth:tradeDate destinateDate:currentDate]) {
        month = @"本月";
    } else {
        if (8 == tradeDate.length) {
            month = [tradeDate substringWithRange:NSMakeRange(4, 2)];
            if ([month hasPrefix:@"0"]) {
                month = [month substringFromIndex:1];
            }
        }
    }
    
    return month;
}

#pragma mark - refresh

- (void)refresh {
    [self queryTransferSerial:NO];
}

@end
