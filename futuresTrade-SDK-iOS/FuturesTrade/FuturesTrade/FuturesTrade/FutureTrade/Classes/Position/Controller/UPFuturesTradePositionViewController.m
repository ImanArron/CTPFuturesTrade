//
//  UPFuturesTradePositionViewController.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/6.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradePositionViewController.h"
#import "UPFuturesTradePositionHeaderView.h"
#import "UPFuturesTradePositionTableViewCell.h"
#import "UPFuturesTradeOrderModel.h"

@interface UPFuturesTradePositionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) UPFuturesTradePositionHeaderView *positionHeaderView;
@property (nonatomic, strong) NSMutableArray *investorPositions;
@property (nonatomic, strong) NSMutableArray *positionCellFoldStatus;

@end

@implementation UPFuturesTradePositionViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self unSubScribeMarketDatas];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableView];
    [self queryTradingAccount:YES isRefresh:NO];
    [self addNotifications];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveOrderActionNotification:) name:ORDER_ACTION_NOTIFICATION object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTableView {
    _table.dataSource = self;
    _table.delegate = self;
    [_table registerNib:[UINib nibWithNibName:UPFuturesTradePositionTableViewCellReuseId bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FuturesTradeBundle" ofType:@"bundle"]]] forCellReuseIdentifier:UPFuturesTradePositionTableViewCellReuseId];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.frame = CGRectMake(0, 0, kFutursTradeScreenWidth, 140);
    
    _positionHeaderView = [UPFuturesTradePositionHeaderView futuresTradePositionHeaderView];
    _positionHeaderView.frame = CGRectMake(0, 0, headerView.bounds.size.width, headerView.bounds.size.height);
    [headerView addSubview:_positionHeaderView];
    
    _table.tableHeaderView = headerView;
    
    UPFuturesTradeWeakSelf(self)
    _table.UPFuturesTrade_header = [UPFuturesTradeRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself queryTradingAccount:NO isRefresh:NO];
    }];
}

#pragma mark - Query Trading Account

- (void)queryTradingAccount:(BOOL)needHint isRefresh:(BOOL)isRefresh {
    UPFuturesTradeWeakSelf(self)
    [self queryTradingAccount:needHint callback:^(id result, NSError *error) {
        [weakself finishQueryingTradingAccount:result error:error needHint:needHint isRefresh:isRefresh];
    }];
}

- (void)finishQueryingTradingAccount:(id)result error:(NSError *)error needHint:(BOOL)needHint isRefresh:(BOOL)isRefresh {
    [UPHUD hideHUD:self.view];
    if (!error) {
        self.rspTradingAccount = result;
    } else {
        
    }
    _positionHeaderView.tradingAccountModel = self.rspTradingAccount;
    [self queryPositions:needHint isRefresh:isRefresh];
}

#pragma mark - Getter
- (NSMutableArray *)investorPositions {
    if (!_investorPositions) {
        _investorPositions = [NSMutableArray array];
    }
    return _investorPositions;
}

- (NSMutableArray *)positionCellFoldStatus {
    if (!_positionCellFoldStatus) {
        _positionCellFoldStatus = [NSMutableArray array];
    }
    return _positionCellFoldStatus;
}

#pragma mark - Query Position
- (void)queryPositions:(BOOL)needHint isRefresh:(BOOL)isRefresh {
    if (needHint) {
        [UPHUD showHUD:self.view];
    }
    UPFuturesTradeWeakSelf(self)
    [self.ctpTradeManager reqQueryInvestorPosition:nil callback:^(id result, NSError *error) {
        [weakself finishQueryingPositions:result error:error isRefresh:isRefresh];
    }];
}

- (void)finishQueryingPositions:(id)result error:(NSError *)error isRefresh:(BOOL)isRefresh {
    [UPHUD hideHUD:self.view];
    [_table.UPFuturesTrade_header endRefreshing];
    [self.investorPositions removeAllObjects];
    NSArray *positions = result;
    if (UPFuturesTradeIsValidateArr(positions)) {
        [self.investorPositions addObjectsFromArray:positions];
        if (self.positionCellFoldStatus.count < 1) {
            for (NSInteger i = 0; i < self.investorPositions.count; i++) {
                [self.positionCellFoldStatus addObject:@0];
            }
        } else {
            if (self.investorPositions.count > self.positionCellFoldStatus.count) {
                NSInteger positionCellFoldStatusCount = self.positionCellFoldStatus.count;
                for (NSInteger i = 0; i < self.investorPositions.count - positionCellFoldStatusCount; i++) {
                    [self.positionCellFoldStatus insertObject:@0 atIndex:0];
                }
            }
        }
    } else {
        [self.positionCellFoldStatus removeAllObjects];
    }
    [self reloadTable];
    
    if (!isRefresh) {
        [self queryMarketDatas];
    }
}

- (void)queryMarketDatas {
    UPFuturesTradeWeakSelf(self)
    [self queryMarketDatas:self.investorPositions callback:^(id result, NSError *error) {
        [weakself finishQueryingMarketDatas:result error:error];
    }];
}

- (void)finishQueryingMarketDatas:(id)result error:(NSError *)error {
    self.depthMarketDatas = [result mutableCopy];
    [self reloadTable];
    [self subScribeMarketDatas];
}

- (void)subScribeMarketDatas {
    if (self.investorPositions.count > 0) {
        NSMutableArray *instrumentIDs = [NSMutableArray array];
        for (UPRspInvestorPositionModel *positionModel in self.investorPositions) {
            if (positionModel.InstrumentID) {
                [instrumentIDs addObject:positionModel.InstrumentID];
            }
        }
        
        UPFuturesTradeWeakSelf(self)
        [self.ctpTradeManager subScribeMarketData:[instrumentIDs copy] callback:^(id result, NSError *error) {
            NSLog(@"SubScribeMarketDatas Successed In UPFuturesTradePositionViewController");
            NSArray *marketData = result;
            [weakself finishSubScribingMarketData:marketData];
        }];
    }
}

- (void)finishSubScribingMarketData:(NSArray *)marketData {
    if (UPFuturesTradeIsValidateArr(marketData)) {
        [self addMarketDataToDepthMarketDatas:marketData[0]];
        [self reloadTable];
    }
}

- (void)addMarketDataToDepthMarketDatas:(UPRspDepthMarketDataModel *)depthMarketDataModel {
    if ([depthMarketDataModel isKindOfClass:[UPRspDepthMarketDataModel class]]) {
        NSInteger index = [self indexOfDepthMarketDataModel:depthMarketDataModel];
        if (index >= 0) {
            [self.depthMarketDatas replaceObjectAtIndex:index withObject:depthMarketDataModel];
        } else {
            [self.depthMarketDatas addObject:depthMarketDataModel];
        }
    }
}

- (NSInteger)indexOfDepthMarketDataModel:(UPRspDepthMarketDataModel *)depthMarketDataModel {
    for (NSInteger i = 0; i < self.depthMarketDatas.count; i++) {
        UPRspDepthMarketDataModel *tmpDepthMarketDataModel = self.depthMarketDatas[i];
        if ([tmpDepthMarketDataModel.InstrumentID isEqual:depthMarketDataModel.InstrumentID]) {
            return i;
        }
    }
    return -1;
}

- (void)unSubScribeMarketDatas {
    if (self.investorPositions.count > 0) {
        NSMutableArray *instrumentIDs = [NSMutableArray array];
        for (UPRspInvestorPositionModel *positionModel in self.investorPositions) {
            if (positionModel.InstrumentID) {
                [instrumentIDs addObject:positionModel.InstrumentID];
            }
        }
        
        [self.ctpTradeManager unSubScribeMarketData:[instrumentIDs copy]];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return UPFuturesTradeIsValidateArr(self.investorPositions) ? self.investorPositions.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL folded = NO;
    if (self.positionCellFoldStatus.count > indexPath.row) {
        folded = [self.positionCellFoldStatus[indexPath.row] boolValue];
    }
    return folded ? 150 : 115;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UPFuturesTradePositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UPFuturesTradePositionTableViewCellReuseId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tradeType = self.tradeType;
    if (self.investorPositions.count > indexPath.row) {
        UPRspInvestorPositionModel *rspInvestorPositionModel = self.investorPositions[indexPath.row];
        UPRspDepthMarketDataModel *depthMarketDataModel = [self depthMarketDataWithInstrumentID:rspInvestorPositionModel.InstrumentID inDepthMarketDatas:self.depthMarketDatas];
        rspInvestorPositionModel.LastPrice = depthMarketDataModel.LastPrice;
        cell.rspInvestorPositionModel = self.investorPositions[indexPath.row];
        if (self.positionCellFoldStatus.count > indexPath.row) {
            BOOL folded = [self.positionCellFoldStatus[indexPath.row] boolValue];
            [cell setupOperationShowStatus:folded];
        }
        UPFuturesTradeWeakSelf(self)
        cell.block = ^(NSInteger type) {
            [weakself operatePosition:type index:indexPath.row];
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (NSInteger i = 0; i < self.positionCellFoldStatus.count; i++) {
        if (i == indexPath.row) {
            BOOL folded = [self.positionCellFoldStatus[i] boolValue];
            [self.positionCellFoldStatus replaceObjectAtIndex:i withObject:folded ? @0 : @1];
        } else {
            [self.positionCellFoldStatus replaceObjectAtIndex:i withObject:@0];
        }
    }
    [self reloadTable];
}

- (void)reloadTable {
    [_table reloadData];
}

#pragma mark - Operate Position
- (void)operatePosition:(NSInteger)type index:(NSInteger)index {
    UPRspInvestorPositionModel *positionModel = self.investorPositions[index];
    if (0 == type) {            // 强平
        [self showOrderConfirmAlert:positionModel positionOperation:ForceClose];
    } else if (1 == type) {     // 平今
        [self showOrderConfirmAlert:positionModel positionOperation:CloseTodayPosition];
    } else if (2 == type) {     // 平仓
        [self showOrderConfirmAlert:positionModel positionOperation:ClosePosition];
    } else if (3 == type) {     // 加仓
        UPRspInvestorPositionModel *investorPositionModel = self.investorPositions[index];
        [self plusPosition:investorPositionModel positionOperation:PlusPosition];
    }
}

- (void)plusPosition:(UPRspInvestorPositionModel *)investorPositionModel positionOperation:(UPFuturesTradePositionOperation)positionOperation {
    [[NSNotificationCenter defaultCenter] postNotificationName:SWIPE_TO_ORDER_TAB_NOTIFICATION object:@{INVESTOR_POSITION_MODEL_KEY:investorPositionModel?investorPositionModel:@"", POSITION_OPERATION_KEY:@(positionOperation)}];
}

- (void)showOrderConfirmAlert:(UPRspInvestorPositionModel *)positionModel positionOperation:(UPFuturesTradePositionOperation)positionOperation {
    UPFuturesTradeWeakSelf(self)
    [self.orderConfirmAlert showOrderConfirmAlert:positionModel positionOperation:positionOperation block:^(UPFuturesTradeOrderModel *tradeOrderModel) {
        if (ForceClose == positionOperation) {
            [weakself order:tradeOrderModel];
        } else {
            [weakself plusPosition:positionModel positionOperation:positionOperation];
        }
    }];
}

#pragma mark - Order

- (void)order:(UPFuturesTradeOrderModel *)orderModel {
    if (orderModel) {
        [UPHUD showHUD:self.view];
        UPFuturesTradeWeakSelf(self)
        [self.ctpTradeManager reqOrderInsert:orderModel.instrumentID price:orderModel.price volumeTotalOriginal:orderModel.num direction:orderModel.tradeOperation combOffsetFlag:orderModel.positionOperation callback:^(id result, NSError *error) {
            [weakself finishOrdering:result error:error];
        }];
    }
}

- (void)finishOrdering:(id)result error:(NSError *)error {
    [UPHUD hideHUD:self.view];
    if (!error) {
        
    } else {
        [UPHUD showToast:self.view withText:UPFuturesTradeIsValidateString(error.domain)?error.domain:@"下单失败"];
    }
}

#pragma mark - Notification

- (void)didReceiveOrderActionNotification:(NSNotification *)noti {
    id object = noti.object;
    NSString *hint = [UPFuturesTradeStringUtil orderHint:object];
    if (UPFuturesTradeIsValidateString(hint)) {
        [UPHUD showToast:self.view withText:hint];
    }
    [self queryPositions:NO isRefresh:NO];
}

#pragma mark - Refresh

- (void)refresh {
    [self queryTradingAccount:NO isRefresh:YES];
}

@end
