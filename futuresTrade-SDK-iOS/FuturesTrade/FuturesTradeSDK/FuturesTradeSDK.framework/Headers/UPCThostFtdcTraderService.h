//
//  CTPTradeService.h
//  FuturesTrade
//
//  Created by UP-LiuL on 17/8/11.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UPCTPModelHeader.h"
#import "UPCTPDefineHeader.h"

@class UPCThostFtdcTraderUserLoginModel;
@class UPCTPRequestQueue;

@interface UPCThostFtdcTraderService : NSObject

#pragma mark - Logedin
- (BOOL)isLogedin;

#pragma mark - Init
- (instancetype)initWithTradeType:(UPCTPTradeType)tradeType;
- (void)initVars;
- (void)addNotifications;

#pragma mark - Connect CTP
- (void)connectCTPResult:(BOOL)connected;
- (void)onFrontDisconnected:(int)nReason;
- (void)onHeartBeatWarning:(int)nTimeLapse;

#pragma mark - Login
- (void)reqUserLogin:(NSString *)userID password:(NSString *)password brokerID:(NSString *)brokerID nRequestID:(int)nRequestID;
- (void)userLogin;
- (void)reqUserLoginResult:(UPRspUserLoginModel *)pRspUserLogin pRspInfo:(UPRspInfoModel *)pRspInfo;
- (void)reqSettlementInfoConfirm;
- (void)reqQueryInstruments;
- (void)reqQueryInstrumentsResult:(NSArray *)instruments;

#pragma mark - Instruments
- (NSArray *)instruments;

#pragma mark - Logout
- (void)reqUserLogout:(NSString *)userID brokerID:(NSString *)brokerID nRequestID:(int)nRequestID; // 登出请求
- (void)reqUserLogoutResult:(UPRspInfoModel *)pRspInfo;

#pragma mark - Trade
- (void)reqOrderInsert:(NSString *)userID instrumentID:(NSString *)instrumentID price:(double)price volumeTotalOriginal:(int)volumeTotalOriginal direction:(int)direction combOffsetFlag:(int)combOffsetFlag brokerID:(NSString *)brokerID nRequestID:(int)nRequestID;
- (void)reqOrderInsertResult:(UPRspOrderModel *)pRspOrderInsert pRspInfo:(UPRspInfoModel *)pRspInfo;

- (void)reqOrderAction:(NSString *)userID instrumentID:(NSString *)instrumentID brokerID:(NSString *)brokerID orderRef:(NSString *)orderRef frontID:(int)frontID sessionID:(int)sessionID exchangeID:(NSString *)exchangeID nRequestID:(int)nRequestID;
- (void)reqOrderActionResult:(UPRspOrderActionModel *)pRspOrderAction pRspInfo:(UPRspInfoModel *)pRspInfo;

#pragma mark - Query
- (void)reqQueryTradingAccount:(NSString *)userID brokerID:(NSString *)brokerID nRequestID:(int)nRequestID;
- (void)reqQueryTradingAccountResult:(UPRspTradingAccountModel *)pRspTradingAccount pRspInfo:(UPRspInfoModel *)pRspInfo;

- (void)reqQueryInvestorPosition:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID nRequestID:(int)nRequestID;
- (void)reqQueryInvestorPositionResult:(NSArray<UPRspInvestorPositionModel *> *)pRspInvestorPositions pRspInfo:(UPRspInfoModel *)pRspInfo;

- (void)reqQueryInvestorPositionDetail:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID nRequestID:(int)nRequestID;
- (void)reqQueryInvestorPositionDetailResult:(NSArray<UPRspInvestorPositionDetailModel *> *)pRspInvestorPositions pRspInfo:(UPRspInfoModel *)pRspInfo;

- (void)reqQueryTrade:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID timeStart:(NSString *)timeStart timeEnd:(NSString *)timeEnd nRequestID:(int)nRequestID;
- (void)reqQueryTradeResult:(NSArray<UPRspTradeModel *> *)pRspTrades pRspInfo:(UPRspInfoModel *)pRspInfo;

- (void)reqQueryDepthMarket:(NSString *)instrumentID nRequestID:(int)nRequestID;
- (void)reqQueryDepthMarketResult:(NSArray<UPRspDepthMarketDataModel *> *)pRspDepthMarketDatas pRspInfo:(UPRspInfoModel *)pRspInfo;

- (void)reqQueryInstrumentMarginRate:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID nRequestID:(int)nRequestID;
- (void)reqQueryInstrumentMarginRateResult:(NSArray<UPRspInstrumentMarginRateModel *> *)pRspDepthMarketDatas pRspInfo:(UPRspInfoModel *)pRspInfo;

- (void)reqQueryOrder:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID nRequestID:(int)nRequestID;
- (void)reqQueryOrderResult:(NSArray<UPRspOrderModel *> *)pRspOrders pRspInfo:(UPRspInfoModel *)pRspInfo;

#pragma mark - Transfer
- (void)reqQueryTransferBank:(int)nRequestID;
- (void)reqQueryTransferBankResult:(NSArray<UPRspTransferBankModel *> *)banks pRspInfo:(UPRspInfoModel *)pRspInfo;

- (void)reqQueryTransferSerial:(NSString *)accountID brokerID:(NSString *)brokerID nRequestID:(int)nRequestID;
- (void)reqQueryTransferSerialResult:(NSArray<UPRspTransferSerialModel *> *)serials pRspInfo:(UPRspInfoModel *)pRspInfo;

- (void)reqQueryAccountregister:(NSString *)accountID brokerID:(NSString *)brokerID nRequestID:(int)nRequestID;
- (void)reqQueryAccountregisterResult:(NSArray<UPRspAccountregisterModel *> *)accountregisters pRspInfo:(UPRspInfoModel *)pRspInfo;

- (void)reqBetweenBankAndFuture:(NSString *)userID brokerID:(NSString *)brokerID accountID:(NSString *)accountID bankID:(NSString *)bankID bankBranchID:(NSString *)bankBranchID amount:(double)amount fundPwd:(NSString *)fundPwd bankPwd:(NSString *)bankPwd transferDirection:(int)transferDirection nRequestID:(int)nRequestID;
- (void)reqBetweenBankAndFutureResult:(NSArray<UPRspTransferModel *> *)transfers pRspInfo:(UPRspInfoModel *)pRspInfo;

- (void)reqQueryBankAccountMoneyByFuture:(NSString *)accountID brokerID:(NSString *)brokerID nRequestID:(int)nRequestID;
- (void)reqQueryBankAccountMoneyByFutureResult:(UPRspNotifyQueryAccountModel *)accountModel pRspInfo:(UPRspInfoModel *)pRspInfo;

#pragma mark - Connect Md CTP
- (void)connectMdCTPResult:(BOOL)connected;
- (void)onMdFrontDisconnected:(int)nReason;
- (void)onMdHeartBeatWarning:(int)nTimeLapse;

#pragma mark - Md Login
- (void)mdReqUserLoginResult:(UPRspUserLoginModel *)pRspUserLogin pRspInfo:(UPRspInfoModel *)pRspInfo;

#pragma mark - Md Logout
- (void)mdReqUserLogoutResult:(UPRspInfoModel *)pRspInfo;

#pragma mark - Subscribe MarketData
- (void)subScribeMarketData:(NSArray *)instrumentIDs nRequestID:(int)nRequestID;
- (void)subScribeMarketDataResult:(UPRspInfoModel *)pRspInfo;
- (void)onRtnDepthMarketData:(UPRspDepthMarketDataModel *)marketDataModel;
- (void)unSubScribeMarketData:(NSArray *)instrumentIDs;
- (void)unSubScribeMarketDataResult:(UPRspInfoModel *)pRspInfo;

@end

@interface UPCThostFtdcTraderUserLoginModel : NSObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *brokerID;
@property (nonatomic, assign) int nRequestID;

@end
