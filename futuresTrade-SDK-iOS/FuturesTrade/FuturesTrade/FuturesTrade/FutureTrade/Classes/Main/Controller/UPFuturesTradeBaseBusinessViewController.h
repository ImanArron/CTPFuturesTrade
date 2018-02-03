//
//  UPFuturesTradeBaseBusinessViewController.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/5.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeBaseViewController.h"
#import <FuturesTradeSDK/UPCTPTradeManager.h>
#import "UPFuturesTradeOrderConfirmAlert.h"
#import <FuturesTradeSDK/UPCTPModelHeader.h>

extern NSString * const SWIPE_TO_ORDER_TAB_NOTIFICATION;
extern NSString * const PLUS_POSITION_NOTIFICATION;
extern NSString * const INVESTOR_POSITION_MODEL_KEY;
extern NSString * const POSITION_OPERATION_KEY;

@interface UPFuturesTradeBaseBusinessViewController : UPFuturesTradeBaseViewController

@property (nonatomic, assign) UPCTPTradeType tradeType;
@property (nonatomic, strong) UPCTPTradeManager *ctpTradeManager;
@property (strong, nonatomic) UPFuturesTradeOrderConfirmAlert *orderConfirmAlert;
@property (nonatomic, strong) UPRspTradingAccountModel *rspTradingAccount;
@property (nonatomic, strong) NSMutableArray *depthMarketDatas;

#pragma mark - Init
- (instancetype)initWithTradeType:(UPCTPTradeType)tradeType;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tradeType:(UPCTPTradeType)tradeType;

#pragma mark - Refresh
- (void)refresh;

#pragma mark - Query Trading Account
- (void)queryTradingAccount:(BOOL)needHint callback:(UPCallback)callback;

#pragma mark - DepthMarketData With InstrumentID
- (UPRspDepthMarketDataModel *)depthMarketDataWithInstrumentID:(NSString *)instrumentID inDepthMarketDatas:(NSArray *)depthMarketDatas;

#pragma mark - Query Market Data
- (void)queryMarketDatas:(NSArray *)investorPositions callback:(UPCallback)callback;

@end
