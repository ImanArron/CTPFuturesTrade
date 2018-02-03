//
//  UPFuturesTradeBusinessViewController.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/30.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeBusinessMainViewController.h"
#import "UPFuturesTradeBusinessHeaderView.h"
#import "UPFuturesTradeVarietyInfoView.h"
#import "UPFuturesTradeBusinessView.h"
#import "UPFuturesTradePositionHeaderCell.h"
#import "UPFuturesTradePositionCell.h"
#import <FuturesTradeSDK/UPCTPModelHeader.h>
#import "UPFuturesTradeTransferUtil.h"
#import "UPFuturesTradeVarietyKeyBoard.h"
#import "UPFuturesTradeOrderCell.h"
#import "UPFuturesTradeOrderHeaderCell.h"
#import "UPFuturesTradeSearchUtil.h"
#import "UPFuturesTradeOrderActionModel.h"
#import "UPFuturesTradeTabView.h"

@interface UPFuturesTradeBusinessMainViewController () <UITableViewDataSource, UITableViewDelegate, UPFuturesTradeTabViewDataSource, UPFuturesTradeTabViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) UPFuturesTradeVarietyInfoView *futuresTradeVarietyInfoView;
@property (strong, nonatomic) UPFuturesTradeBusinessView *futuresTradeBusinessView;
@property (strong, nonatomic) NSMutableArray *investorPositions;
@property (strong, nonatomic) NSMutableArray *positionCellFoldStatus;
@property (nonatomic, assign) NSInteger selectedTab;
@property (nonatomic, copy) NSArray *instruments;
@property (nonatomic, strong) UPRspInstrumentModel *instrumentModel;
@property (nonatomic, strong) UPRspDepthMarketDataModel *depthMarketDataModel;
@property (nonatomic, strong) UPRspInstrumentMarginRateModel *instrumentMarginRateModel;
@property (nonatomic, strong) UPFuturesTradeVarietyKeyBoard *varietyBoard;
@property (strong, nonatomic) NSMutableArray *orders;
@property (nonatomic, strong) UPFuturesTradeTabView *upTabView;
@property (nonatomic, strong) UPFuturesTradeBusinessModel *businessModel;
@property (nonatomic, strong) NSMutableArray *depthMarketData;

@end

@implementation UPFuturesTradeBusinessMainViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self unSubScribeMarketData];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_futuresTradeBusinessView hideKeyboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initVars];
    [self setupTabView];
    [self setupTableView];
    [self setupVarietyBoard];
    [self queryTradingAccount:YES];
    if (_instrumentID.length > 0) {
        [self plusPositionWithInstrumentID:_instrumentID positionOperation:OpenPosition];
    } else {
        [self queryMarket:YES needQueryPositionsOrOrders:YES];
    }
    [self addNotifications];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivePlusPositionNotification:) name:PLUS_POSITION_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveOrderActionNotification:) name:ORDER_ACTION_NOTIFICATION object:nil];
}

- (void)initVars {
    _selectedTab = 0;
    _instruments = [self.ctpTradeManager instruments];
}

- (void)setupTableView {
    _table.dataSource = self;
    _table.delegate = self;
    [_table registerNib:[UINib nibWithNibName:UPFuturesTradePositionHeaderCellReuseId bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FuturesTradeBundle" ofType:@"bundle"]]] forCellReuseIdentifier:UPFuturesTradePositionHeaderCellReuseId];
    [_table registerNib:[UINib nibWithNibName:UPFuturesTradePositionCellReuseId bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FuturesTradeBundle" ofType:@"bundle"]]] forCellReuseIdentifier:UPFuturesTradePositionCellReuseId];
    [_table registerNib:[UINib nibWithNibName:UPFuturesTradeBusinessHeaderViewReuseId bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FuturesTradeBundle" ofType:@"bundle"]]] forHeaderFooterViewReuseIdentifier:UPFuturesTradeBusinessHeaderViewReuseId];
    [_table registerNib:[UINib nibWithNibName:UPFuturesTradeOrderHeaderCellReuseId bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FuturesTradeBundle" ofType:@"bundle"]]] forCellReuseIdentifier:UPFuturesTradeOrderHeaderCellReuseId];
    [_table registerNib:[UINib nibWithNibName:UPFuturesTradeOrderCellReuseId bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FuturesTradeBundle" ofType:@"bundle"]]] forCellReuseIdentifier:UPFuturesTradeOrderCellReuseId];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.frame = CGRectMake(0, 0, kFutursTradeScreenWidth, 306);
    
    UIView *varietyInfoView = [[UIView alloc] init];
    varietyInfoView.backgroundColor = [UIColor clearColor];
    varietyInfoView.frame = CGRectMake(0, 0, kFutursTradeScreenWidth, 80);
    [headerView addSubview:varietyInfoView];
    
    UPFuturesTradeWeakSelf(self)
    _futuresTradeVarietyInfoView = [UPFuturesTradeVarietyInfoView futuresTradeVarietyInfoView];
    _futuresTradeVarietyInfoView.frame = CGRectMake(0, 0, varietyInfoView.bounds.size.width, varietyInfoView.bounds.size.height);
    _futuresTradeVarietyInfoView.searchBlock = ^(void) {
        [weakself.varietyBoard showKeyboard];
    };
    [varietyInfoView addSubview:_futuresTradeVarietyInfoView];
    
    UIView *businessView = [[UIView alloc] init];
    businessView.backgroundColor = [UIColor clearColor];
    businessView.frame = CGRectMake(0, 80, kFutursTradeScreenWidth, 226);
    [headerView addSubview:businessView];
    
    _futuresTradeBusinessView = [UPFuturesTradeBusinessView futuresTradeBusinessView];
    _futuresTradeBusinessView.frame = CGRectMake(0, 0, businessView.bounds.size.width, businessView.bounds.size.height);
    _futuresTradeBusinessView.orderBlock = ^(UPFuturesTradeOrderModel *orderModel) {
        [weakself order:orderModel];
    };
    [businessView addSubview:_futuresTradeBusinessView];
    
    _table.tableHeaderView = headerView;
    
    _table.UPFuturesTrade_header = [UPFuturesTradeRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refresh];
    }];
}

- (void)setupVarietyBoard {
    if (!_varietyBoard) {
        _varietyBoard = [UPFuturesTradeVarietyKeyBoard futuresTradeVarietyKeyBoardWithInstruments:[_instruments copy]];
        UPFuturesTradeWeakSelf(self)
        _varietyBoard.block = ^(UPRspInstrumentModel *model) {
            _instrumentModel = model;
            [weakself queryMarket:YES needQueryPositionsOrOrders:NO];
            [weakself resetPositionCellFoldStatus];
        };
    }
}

- (void)resetPositionCellFoldStatus {
    if (self.positionCellFoldStatus.count > 0) {
        for (NSInteger i = 0; i < self.positionCellFoldStatus.count; i++) {
            [self.positionCellFoldStatus replaceObjectAtIndex:i withObject:@0];
        }
        [self reloadTable];
    }
}

- (void)setupTabView {
    if (!_upTabView) {
        _upTabView = [[UPFuturesTradeTabView alloc] initWithFrame:CGRectMake(0, 0, kFutursTradeScreenWidth, 44) font:[UIFont systemFontOfSize:15] selectedColor:UPColorFromRGB(0xe03633) unselectedColor:UPColorFromRGB(0x333333) selectedTabIdentifierColor:UPColorFromRGB(0xe03633) tabStyle:AverageStyle needHorizontalLine:YES needVerticalLine:NO selectedImageWidth:35];
        _upTabView.backgroundColor = [UIColor whiteColor];
        _upTabView.dataSource = self;
        _upTabView.delegate = self;
        [_upTabView reloadTabView];
    } else {
        [_upTabView setTabBtn:_selectedTab hasDelegate:NO];
    }
}

#pragma mark - UPFuturesTradeTabViewDataSource, UPFuturesTradeTabViewDelegate
-(NSArray *)tabArr {
    return @[
             @"持仓",
             @"可撤"
             ];
}

- (void)didTabSelected:(NSInteger)index {
    _selectedTab = index;
    [self handleTabPressed:index];
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

- (NSMutableArray *)orders {
    if (!_orders) {
        _orders = [NSMutableArray array];
    }
    return _orders;
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
    if (!error) {
        self.rspTradingAccount = result;
    } else {
        if (needHint) {
            [UPHUD showToast:self.view withText:error.domain ? error.domain : @"账户查询失败"];
        }
    }
}

#pragma mark - Query Market
- (void)queryMarket:(BOOL)needHint needQueryPositionsOrOrders:(BOOL)needQueryPositionsOrOrders {
    if (_instrumentModel) {
        if (needHint) {
            [UPHUD showHUD:self.view];
        }
        
        UPRspDepthMarketDataModel *model = [self depthMarketDataWithInstrumentID:_instrumentModel.InstrumentID inDepthMarketDatas:self.depthMarketData];
        if (model) {
            [self finishQueryingDepthMarket:@[model] error:nil needQueryPositionsOrOrders:needQueryPositionsOrOrders];
        } else {
            UPFuturesTradeWeakSelf(self)
            [self.ctpTradeManager reqQueryDepthMarket:_instrumentModel.InstrumentID callback:^(id result, NSError *error) {
                [weakself finishQueryingDepthMarket:result error:error needQueryPositionsOrOrders:needQueryPositionsOrOrders];
            }];
        }
    } else {
        if (needQueryPositionsOrOrders) {
            [self queryPositionsOrOrders];
        }
    }
}

- (void)finishQueryingDepthMarket:(id)result error:(NSError *)error needQueryPositionsOrOrders:(BOOL)needQueryPositionsOrOrders {
    [self finishSubScribingMarketData:result error:error];
    UPFuturesTradeWeakSelf(self)
    [self.ctpTradeManager reqQueryInstrumentMarginRate:_instrumentModel.InstrumentID callback:^(id result, NSError *error) {
        [weakself finishQueryingInstrumentMarginRate:result error:error needQueryPositionsOrOrders:needQueryPositionsOrOrders];
    }];
    
    [self subScribeMarketData:_instrumentModel.InstrumentID];
}

- (void)finishQueryingInstrumentMarginRate:(id)result error:(NSError *)error needQueryPositionsOrOrders:(BOOL)needQueryPositionsOrOrders {
    [UPHUD hideHUD:self.view];
    
    NSArray *instrumentMarginRates = result;
    if (UPFuturesTradeIsValidateArr(instrumentMarginRates)) {
        _instrumentMarginRateModel = instrumentMarginRates[0];
    }
    
    [self refreshFuturesTradeBusinessView];
    
    if (needQueryPositionsOrOrders) {
        [self queryPositionsOrOrders];
    }
}

#pragma mark - Query Position
- (void)queryPositions:(BOOL)needHint {
    if (needHint) {
        [UPHUD showHUD:self.view];
    }
    UPFuturesTradeWeakSelf(self)
    [self.ctpTradeManager reqQueryInvestorPosition:nil callback:^(id result, NSError *error) {
        [weakself finishQueryingPositions:result error:error];
    }];
}

- (void)finishQueryingPositions:(id)result error:(NSError *)error {
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
}

- (void)queryMarketDatas {
    UPFuturesTradeWeakSelf(self)
    [self queryMarketDatas:self.investorPositions callback:^(id result, NSError *error) {
        [weakself finishQueryingMarketDatas:result error:error];
    }];
}

- (void)finishQueryingMarketDatas:(id)result error:(NSError *)error {
    self.depthMarketDatas = [result mutableCopy];
}

- (void)subScribeMarketData:(NSString *)instrumentID {
    if (instrumentID.length > 0) {
        UPFuturesTradeWeakSelf(self)
        [self.ctpTradeManager subScribeMarketData:@[instrumentID] callback:^(id result, NSError *error) {
            [weakself finishSubScribingMarketData:result error:error];
        }];
    }
}

- (void)finishSubScribingMarketData:(id)result error:(NSError *)error {
    NSArray *marketDatas = result;
    if (UPFuturesTradeIsValidateArr(marketDatas)) {
        for (UPRspDepthMarketDataModel *marketDataModel in marketDatas) {
            if ([marketDataModel.InstrumentID isEqual:_instrumentModel.InstrumentID]) {
                _depthMarketDataModel = marketDataModel;
                break;
            }
        }
        [self refreshFuturesTradeVarietyInfoView];
    }
}

- (void)unSubScribeMarketData {
    NSString *instrumentID = _instrumentModel.InstrumentID;
    if (instrumentID.length > 0) {
        [self.ctpTradeManager unSubScribeMarketData:@[instrumentID]];
    }
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
            [weakself finishSubScribingMarketDatas:result];
        }];
    }
}

- (void)finishSubScribingMarketDatas:(NSArray *)marketData {
    if (UPFuturesTradeIsValidateArr(marketData)) {
        [self addMarketDataToDepthMarketDatas:marketData[0]];
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
        for (UPRspOrderModel *orderModel in orders) {
            if ([orderModel isKindOfClass:[UPRspOrderModel class]] &&
                [UPFuturesTradeStringUtil canDeletedOrder:orderModel.OrderStatus]) {
                [self.orders addObject:orderModel];
            }
        }
    }
    [self reloadTable];
}

#pragma mark - Query Positions Or Orders
- (void)queryPositionsOrOrders {
    if (0 == _selectedTab) {
        [self queryPositions:NO];
    } else if (1 == _selectedTab) {
        [self queryOrders:NO];
    }
}

#pragma mark - Operate Position
- (void)operatePosition:(NSInteger)type index:(NSInteger)index {
    UPRspInvestorPositionModel *positionModel = self.investorPositions[index];
    UPRspDepthMarketDataModel *depthMarketDataModel = [self depthMarketDataWithInstrumentID:positionModel.InstrumentID inDepthMarketDatas:self.depthMarketDatas];
    if (!depthMarketDataModel && [positionModel.InstrumentID isEqual:_depthMarketDataModel.InstrumentID]) {
        depthMarketDataModel = _depthMarketDataModel;
    }
    positionModel.LastPrice = depthMarketDataModel.LastPrice;
    positionModel.AskPrice1 = depthMarketDataModel.AskPrice1;
    positionModel.BidPrice1 = depthMarketDataModel.BidPrice1;
    if (0 == type) {            // 强平
        [self showOrderConfirmAlert:positionModel positionOperation:ForceClose];
    } else if (1 == type) {     // 平今
        [self showOrderConfirmAlert:positionModel positionOperation:CloseTodayPosition];
    } else if (2 == type) {     // 平仓
        [self showOrderConfirmAlert:positionModel positionOperation:ClosePosition];
    } else if (3 == type) {     // 加仓
        [self plusPosition:positionModel positionOperation:PlusPosition];
    }
}

- (void)plusPosition:(UPRspInvestorPositionModel *)investorPositionModel positionOperation:(UPFuturesTradePositionOperation)positionOperation {
    if ([investorPositionModel isKindOfClass:[UPRspInvestorPositionModel class]]) {
        UPRspInstrumentModel *instrumentModel = [UPFuturesTradeSearchUtil searchInstrument:investorPositionModel.InstrumentID inInstruments:[_instruments copy] tradeType:self.tradeType];
        if (instrumentModel) {
            _businessModel = [[UPFuturesTradeBusinessModel alloc] init];
            NSInteger selectedSegment = 0;
            NSInteger canCloseNum = 0;
            if (ClosePosition == positionOperation) {
                selectedSegment = 1;
                canCloseNum = investorPositionModel.Position;
            } else if (CloseTodayPosition == positionOperation) {
                selectedSegment = 2;
                canCloseNum = investorPositionModel.TodayPosition;
            }
            _businessModel.selectedSegment = selectedSegment;
            _businessModel.num = canCloseNum;
            if (investorPositionModel.PosiDirection == '2') {
                _businessModel.canBuyNum = 0;
                _businessModel.canSellNum = investorPositionModel.Position;
                _businessModel.canBuyTodayNum = 0;
                _businessModel.canSellTodayNum = investorPositionModel.TodayPosition;
            } else {
                _businessModel.canBuyNum = investorPositionModel.Position;
                _businessModel.canSellNum = 0;
                _businessModel.canBuyTodayNum = investorPositionModel.TodayPosition;
                _businessModel.canSellTodayNum = 0;
            }
            _instrumentModel = instrumentModel;
            [self queryMarket:YES needQueryPositionsOrOrders:NO];
            [_table setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

- (void)plusPositionWithInstrumentID:(NSString *)instrumentID positionOperation:(UPFuturesTradePositionOperation)positionOperation {
    UPRspInstrumentModel *instrumentModel = [UPFuturesTradeSearchUtil searchInstrument:instrumentID inInstruments:[_instruments copy] tradeType:self.tradeType];
    if (instrumentModel) {
        _instrumentModel = instrumentModel;
        [self queryMarket:YES needQueryPositionsOrOrders:NO];
        [_table setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)showOrderConfirmAlert:(UPRspInvestorPositionModel *)positionModel positionOperation:(UPFuturesTradePositionOperation)positionOperation {
    UPFuturesTradeWeakSelf(self)
    [self.orderConfirmAlert showOrderConfirmAlert:positionModel positionOperation:positionOperation block:^(UPFuturesTradeOrderModel *tradeOrderModel) {
        [weakself order:tradeOrderModel];
        /*if (ForceClose == positionOperation) {
            [weakself order:tradeOrderModel];
        } else {
            [weakself plusPosition:positionModel positionOperation:positionOperation];
        }*/
    }];
}

#pragma mark - Order

- (void)order:(UPFuturesTradeOrderModel *)orderModel {
    if (orderModel) {
        if (orderModel.price <= 0) {
            [UPHUD showToast:self.view withText:@"价格不能为0"];
            return;
        }
        
        if (orderModel.num <= 0) {
            [UPHUD showToast:self.view withText:@"数量不能为0"];
            return;
        }
        
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
        [self queryOrders:YES];
    } else {
        [UPHUD showToast:self.view withText:UPFuturesTradeIsValidateString(error.domain)?error.domain:@"撤单失败"];
    }
}

#pragma mark - Refresh View

- (void)refreshFuturesTradeVarietyInfoView {
    _futuresTradeVarietyInfoView.viewModel = [UPFuturesTradeTransferUtil UPRspDepthMarketDataModel2UPFuturesTradeVarietyInfoViewModel:_depthMarketDataModel instrumnets:_instruments tradeType:self.tradeType];
}

- (void)refreshFuturesTradeBusinessView {
    _futuresTradeBusinessView.businessModel = _businessModel;
    _futuresTradeBusinessView.rspTradingAccount = self.rspTradingAccount;
    _futuresTradeBusinessView.instrumentModel = _instrumentModel;
    _futuresTradeBusinessView.instrumentMarginRateModel = _instrumentMarginRateModel;
    _futuresTradeBusinessView.depthMarketDataModel = _depthMarketDataModel;
    _businessModel = nil;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == _selectedTab) {
        return UPFuturesTradeIsValidateArr(self.investorPositions) ? self.investorPositions.count + 1 : 1;
    } else if (1 == _selectedTab) {
        return UPFuturesTradeIsValidateArr(self.orders) ? self.orders.count + 1 : 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == _selectedTab) {
        if (0 == indexPath.row) {
            return 30;
        } else {
            BOOL folded = NO;
            if (self.positionCellFoldStatus.count > indexPath.row - 1) {
                folded = [self.positionCellFoldStatus[indexPath.row - 1] boolValue];
            }
            return folded ? 85 : 50;
        }
    } else if (1 == _selectedTab) {
        if (0 == indexPath.row) {
            return 30;
        } else {
            return 50;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == _selectedTab) {
        if (0 == indexPath.row) {
            UPFuturesTradePositionHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:UPFuturesTradePositionHeaderCellReuseId forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            UPFuturesTradePositionCell *cell = [tableView dequeueReusableCellWithIdentifier:UPFuturesTradePositionCellReuseId forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.tradeType = self.tradeType;
            if (self.investorPositions.count > indexPath.row - 1) {
                cell.rspInvestorPositionModel = self.investorPositions[indexPath.row - 1];
                if (self.positionCellFoldStatus.count > indexPath.row - 1) {
                    BOOL folded = [self.positionCellFoldStatus[indexPath.row - 1] boolValue];
                    [cell setupOperationShowStatus:folded];
                }
                UPFuturesTradeWeakSelf(self)
                cell.block = ^(NSInteger type) {
                    [weakself operatePosition:type index:indexPath.row - 1];
                };
            }
            return cell;
        }
    } else if (1 == _selectedTab) {
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
    } else {
        static NSString *reuseIdentifier = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UPFuturesTradeBusinessHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:UPFuturesTradeBusinessHeaderViewReuseId];
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9) {
        if (!UPFuturesTradeIsValidateArr(headerView.subviews)) {
            [headerView addSubview:_upTabView];
        }
        
        if (0 != _selectedTab) {
            [_upTabView setTabBtn:_selectedTab hasDelegate:NO];
        }
    } else {
        [headerView addSubview:_upTabView];
    }
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == _selectedTab) {
        if (indexPath.row > 0) {
            for (NSInteger i = 0; i < self.positionCellFoldStatus.count; i++) {
                if (i == indexPath.row - 1) {
                    BOOL folded = [self.positionCellFoldStatus[i] boolValue];
                    [self.positionCellFoldStatus replaceObjectAtIndex:i withObject:folded ? @0 : @1];
                } else {
                    [self.positionCellFoldStatus replaceObjectAtIndex:i withObject:@0];
                }
            }
            [self reloadTable];
            
            UPRspInvestorPositionModel *positionModel = self.investorPositions[indexPath.row - 1];
           [self plusPosition:positionModel positionOperation:PlusPosition];
        }
    } else if (1 == _selectedTab) {
        if (indexPath.row > 0) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self orderAction:indexPath.row - 1];
        }
    }
}

- (void)reloadTable {
    [_table reloadData];
}

#pragma mark - Handle Tab Pressed

- (void)handleTabPressed:(NSInteger)index {
    _selectedTab = index;
    [self reloadTable];
    if (0 == _selectedTab) {
        if (!UPFuturesTradeIsValidateArr(self.investorPositions)) {
            [self queryPositions:YES];
        } else {
            [self reloadTable];
        }
    } else if (1 == _selectedTab) {
        if (!UPFuturesTradeIsValidateArr(self.orders)) {
            [self queryOrders:YES];
        } else {
            [self reloadTable];
        }
    }
}

#pragma mark - Notification

- (void)didReceivePlusPositionNotification:(NSNotification *)noti {
    NSDictionary *dict = noti.object;
    if (UPFuturesTradeIsValidateDic(dict)) {
        UPRspInvestorPositionModel *investorPositionModel = dict[INVESTOR_POSITION_MODEL_KEY];
        UPFuturesTradePositionOperation positionOperation = [dict[POSITION_OPERATION_KEY] intValue];
        [self plusPosition:investorPositionModel positionOperation:positionOperation];
    }
}

- (void)didReceiveOrderActionNotification:(NSNotification *)noti {
    id object = noti.object;
    NSString *hint = [UPFuturesTradeStringUtil orderHint:object];
    if (UPFuturesTradeIsValidateString(hint)) {
        [UPHUD showToast:self.view withText:hint];
    }
    [self queryPositions:NO];
}

#pragma mark - Refresh

- (void)refresh {
    [self queryTradingAccount:NO];
    [self queryPositionsOrOrders];
}

@end
