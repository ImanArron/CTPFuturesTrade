//
//  UPCTPTradeManager.h
//  FuturesTrade
//
//  Created by LiuLian on 17/8/11.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPCTPDefineHeader.h"

@class UPRspUserLoginModel;

@interface UPCTPTradeManager : NSObject

#pragma mark - Init
- (instancetype)initWithTradeType:(UPCTPTradeType)tradeType;

#pragma mark - Environment
- (BOOL)isTestEnvironment;
- (void)setTestEnvironment:(BOOL)test;

#pragma mark - Login
- (void)reqUserLogin:(NSString *)userID password:(NSString *)password brokerID:(NSString *)brokerID callback:(UPCallback)callback;
- (BOOL)isLogedin;
- (UPRspUserLoginModel *)userInfo;
- (NSString *)userID;
- (NSString *)brokerID;
- (NSArray *)instruments;
+ (NSArray *)instruments:(UPCTPTradeType)tradeType;

#pragma mark - Logout
- (void)reqUserLogout:(NSString *)userID brokerID:(NSString *)brokerID callback:(UPCallback)callback;
- (void)reqUserLogout:(UPCallback)callback;

#pragma mark - Trade
- (void)reqOrderInsert:(NSString *)userID instrumentID:(NSString *)instrumentID price:(double)price volumeTotalOriginal:(int)volumeTotalOriginal direction:(int)direction combOffsetFlag:(int)combOffsetFlag brokerID:(NSString *)brokerID callback:(UPCallback)callback;
- (void)reqOrderInsert:(NSString *)instrumentID price:(double)price volumeTotalOriginal:(int)volumeTotalOriginal direction:(int)direction combOffsetFlag:(int)combOffsetFlag callback:(UPCallback)callback;

- (void)reqOrderAction:(NSString *)userID instrumentID:(NSString *)instrumentID brokerID:(NSString *)brokerID orderRef:(NSString *)orderRef frontID:(int)frontID sessionID:(int)sessionID exchangeID:(NSString *)exchangeID callback:(UPCallback)callback;
- (void)reqOrderAction:(NSString *)instrumentID orderRef:(NSString *)orderRef frontID:(int)frontID sessionID:(int)sessionID exchangeID:(NSString *)exchangeID callback:(UPCallback)callback;

#pragma mark - Query
- (void)reqQueryTradingAccount:(NSString *)userID brokerID:(NSString *)brokerID callback:(UPCallback)callback;
- (void)reqQueryTradingAccount:(UPCallback)callback;

- (void)reqQueryInvestorPosition:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID callback:(UPCallback)callback;
- (void)reqQueryInvestorPosition:(NSString *)instrumentID callback:(UPCallback)callback;

- (void)reqQueryInvestorPositionDetail:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID callback:(UPCallback)callback;
- (void)reqQueryInvestorPositionDetail:(NSString *)instrumentID callback:(UPCallback)callback;

- (void)reqQueryTrade:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID timeStart:(NSString *)timeStart timeEnd:(NSString *)timeEnd callback:(UPCallback)callback;
- (void)reqQueryTrade:(NSString *)instrumentID timeStart:(NSString *)timeStart timeEnd:(NSString *)timeEnd callback:(UPCallback)callback;

- (void)reqQueryDepthMarket:(NSString *)instrumentID callback:(UPCallback)callback;

- (void)reqQueryInstrumentMarginRate:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID callback:(UPCallback)callback;
- (void)reqQueryInstrumentMarginRate:(NSString *)instrumentID callback:(UPCallback)callback;

- (void)reqQueryOrder:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID callback:(UPCallback)callback;
- (void)reqQueryOrder:(NSString *)instrumentID callback:(UPCallback)callback;

#pragma mark - Transfer
- (void)reqQueryTransferBank:(UPCallback)callback;

- (void)reqQueryTransferSerial:(NSString *)accountID brokerID:(NSString *)brokerID callback:(UPCallback)callback;
- (void)reqQueryTransferSerial:(UPCallback)callback;

- (void)reqQueryAccountregister:(NSString *)accountID brokerID:(NSString *)brokerID callback:(UPCallback)callback;
- (void)reqQueryAccountregister:(UPCallback)callback;

- (void)reqBetweenBankAndFuture:(NSString *)userID brokerID:(NSString *)brokerID accountID:(NSString *)accountID bankID:(NSString *)bankID bankBranchID:(NSString *)bankBranchID amount:(double)amount fundPwd:(NSString *)fundPwd bankPwd:(NSString *)bankPwd transferDirection:(int)transferDirection callback:(UPCallback)callback;
- (void)reqBetweenBankAndFuture:(NSString *)accountID bankID:(NSString *)bankID bankBranchID:(NSString *)bankBranchID amount:(double)amount fundPwd:(NSString *)fundPwd bankPwd:(NSString *)bankPwd transferDirection:(int)transferDirection callback:(UPCallback)callback;

- (void)reqQueryBankAccountMoneyByFuture:(NSString *)accountID brokerID:(NSString *)brokerID callback:(UPCallback)callback;
- (void)reqQueryBankAccountMoneyByFuture:(UPCallback)callback;

#pragma mark - Subscribe MarketData
- (void)subScribeMarketData:(NSArray *)instrumentIDs callback:(UPCallback)callback;
- (void)unSubScribeMarketData:(NSArray *)instrumentIDs;

@end
