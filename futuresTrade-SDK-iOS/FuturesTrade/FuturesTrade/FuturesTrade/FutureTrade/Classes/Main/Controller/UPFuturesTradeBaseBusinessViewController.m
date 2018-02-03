//
//  UPFuturesTradeBaseBusinessViewController.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/5.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeBaseBusinessViewController.h"

NSString * const SWIPE_TO_ORDER_TAB_NOTIFICATION = @"SWIPE_TO_ORDER_TAB_NOTIFICATION";
NSString * const PLUS_POSITION_NOTIFICATION = @"PLUS_POSITION_NOTIFICATION";
NSString * const INVESTOR_POSITION_MODEL_KEY = @"INVESTOR_POSITION_MODEL_KEY";
NSString * const POSITION_OPERATION_KEY = @"POSITION_OPERATION_KEY";

static const NSTimeInterval REFRESH_TIME_INTERVAL = 15.f;

@interface UPFuturesTradeBaseBusinessViewController ()

@property (nonatomic, strong) NSTimer *refreshTimer;

@end

@implementation UPFuturesTradeBaseBusinessViewController

#pragma mark - dealloc

- (void)dealloc {
   [self invalidateTimer];
}

#pragma mark - ReceiveMemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

- (instancetype)initWithTradeType:(UPCTPTradeType)tradeType {
    self = [super init];
    if (self) {
        _tradeType = tradeType;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tradeType:(UPCTPTradeType)tradeType {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tradeType = tradeType;
    }
    return self;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self stopTimer];
}

#pragma mark - Getter

- (UPCTPTradeManager *)ctpTradeManager {
    if (!_ctpTradeManager) {
        _ctpTradeManager = [[UPCTPTradeManager alloc] initWithTradeType:_tradeType];
    }
    return _ctpTradeManager;
}

- (UPFuturesTradeOrderConfirmAlert *)orderConfirmAlert {
    if (!_orderConfirmAlert) {
        _orderConfirmAlert = [[UPFuturesTradeOrderConfirmAlert alloc] init];
    }
    return _orderConfirmAlert;
}

- (NSTimer *)refreshTimer {
    if (!_refreshTimer) {
        _refreshTimer =  [NSTimer timerWithTimeInterval:REFRESH_TIME_INTERVAL target:self selector:@selector(refresh) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_refreshTimer forMode:NSRunLoopCommonModes];
    }
    return _refreshTimer;
}

- (NSMutableArray *)depthMarketDatas {
    if (!_depthMarketDatas) {
        _depthMarketDatas = [NSMutableArray array];
    }
    return _depthMarketDatas;
}

#pragma mark - Refresh
- (void)refresh {
    
}

#pragma mark - Timer

- (void)startTimer {
    [self.refreshTimer setFireDate:[NSDate distantPast]];
}

- (void)stopTimer {
    [self.refreshTimer setFireDate:[NSDate distantFuture]];
    [self invalidateTimer];
}

- (void)invalidateTimer {
    [self.refreshTimer invalidate];
    _refreshTimer = nil;
}

#pragma mark - Query Trading Account

- (void)queryTradingAccount:(BOOL)needHint callback:(UPCallback)callback {
    if (needHint) {
        [UPHUD showHUD:self.view];
    }
    [self.ctpTradeManager reqQueryTradingAccount:callback];
}

#pragma mark - Notifications

- (void)addNotifications:(id)observer selector:(SEL)aSelector {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:ON_RTN_DEPTH_MARKETDATA_NOTIFICATION object:nil];
}

- (void)removeNotifications:(id)observer {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:ON_RTN_DEPTH_MARKETDATA_NOTIFICATION object:nil];
}

#pragma mark - DepthMarketData With InstrumentID

- (UPRspDepthMarketDataModel *)depthMarketDataWithInstrumentID:(NSString *)instrumentID inDepthMarketDatas:(NSArray *)depthMarketDatas {
    if (depthMarketDatas.count > 0 && UPFuturesTradeIsValidateString(instrumentID)) {
        for (UPRspDepthMarketDataModel *model in depthMarketDatas) {
            if ([model.InstrumentID isEqual:instrumentID]) {
                return model;
            }
        }
    }
    
    return nil;
}

#pragma mark - Query Market Data
- (void)queryMarketDatas:(NSArray *)investorPositions callback:(UPCallback)callback {
    if (investorPositions.count > 0) {
        for (UPRspInvestorPositionModel *positionModel in investorPositions) {
            UPFuturesTradeWeakSelf(self)
            [self.ctpTradeManager reqQueryDepthMarket:positionModel.InstrumentID callback:^(id result, NSError *error) {
                [weakself finishQueryingMarketData:result error:error callback:callback];
            }];
        }
    }
}

- (NSInteger)indexOfModelInDepthMarketData:(UPRspDepthMarketDataModel *)model {
    for (NSInteger i = 0; i < self.depthMarketDatas.count; i++) {
        UPRspDepthMarketDataModel *tmpModel = self.depthMarketDatas[i];
        if ([tmpModel.InstrumentID isEqual:model.InstrumentID]) {
            return i;
        }
    }
    
    return -1;
}

- (void)finishQueryingMarketData:(id)result error:(NSError *)error callback:(UPCallback)callback {
    NSArray *marketDatas = result;
    if (UPFuturesTradeIsValidateArr(marketDatas)) {
        UPRspDepthMarketDataModel *model = marketDatas[0];
        NSInteger index = [self indexOfModelInDepthMarketData:model];
        if (index >= 0 && index < self.depthMarketDatas.count) {
            [self.depthMarketDatas replaceObjectAtIndex:index withObject:model];
        } else {
            [self.depthMarketDatas addObject:model];
        }
    }
    
    if (callback) {
        callback([self.depthMarketDatas copy], nil);
    }
}

@end
