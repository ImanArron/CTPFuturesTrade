//
//  UPCTPTradeManager.m
//  FuturesTrade
//
//  Created by LiuLian on 17/8/11.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPTradeManager.h"
#import "UPCTPSimUserClient.h"
#import "UPCTPSimTradeClient.h"
#import "UPCTPModelHeader.h"
#import "UPFuturesTradeEnvironmentUtil.h"
#import "UPCTPTradeCache.h"

@interface UPCTPTradeManager ()

@property (nonatomic, assign, readonly) UPCTPTradeType tradeType;
@property (nonatomic, strong) UPCTPUserClient *userClient;
@property (nonatomic, strong) UPCTPTradeClient *tradeClient;

@end

@implementation UPCTPTradeManager

#pragma mark - Init
- (instancetype)initWithTradeType:(UPCTPTradeType)tradeType {
    self = [super init];
    if (self) {
        _tradeType = tradeType;
    }
    return self;
}

#pragma mark - Environment
- (BOOL)isTestEnvironment {
    return [UPFuturesTradeEnvironmentUtil isTestEnvironment];
}

- (void)setTestEnvironment:(BOOL)test {
    [UPFuturesTradeEnvironmentUtil setTestEnvironment:test];
}

#pragma mark - Getter
- (UPCTPUserClient *)userClient {
    if (UPCTPRealTrade == _tradeType) {
        return [UPCTPUserClient sharedUserClient];
    } else {
        return [UPCTPSimUserClient sharedSimUserClient];
    }
}

- (UPCTPTradeClient *)tradeClient {
    if (UPCTPRealTrade == _tradeType) {
        return [UPCTPTradeClient sharedTradeClient];
    } else {
        return [UPCTPSimTradeClient sharedSimTradeClient];
    }
}

#pragma mark - Login
- (void)reqUserLogin:(NSString *)userID password:(NSString *)password brokerID:(NSString *)brokerID callback:(UPCallback)callback {
    [self.userClient reqUserLogin:userID password:password brokerID:brokerID callback:callback];
}

- (BOOL)isLogedin {
    return [self.userClient isLogedin];
}

- (UPRspUserLoginModel *)userInfo {
    return [self.userClient userInfo];
}

- (NSString *)userID {
    return [self userInfo].UserID;
}

- (NSString *)brokerID {
    return [self userInfo].BrokerID;
}

- (NSArray *)instruments {
    return [self.userClient instruments];
}

+ (NSArray *)instruments:(UPCTPTradeType)tradeType {
    return [UPCTPTradeCache instruments:tradeType];
}

#pragma mark - Logout
- (void)reqUserLogout:(NSString *)userID brokerID:(NSString *)brokerID callback:(UPCallback)callback {
    [self.userClient reqUserLogout:userID brokerID:brokerID callback:callback];
}

- (void)reqUserLogout:(UPCallback)callback {
    [self reqUserLogout:[self userID] brokerID:[self brokerID] callback:callback];
}

#pragma mark - Trade
- (void)reqOrderInsert:(NSString *)userID instrumentID:(NSString *)instrumentID price:(double)price volumeTotalOriginal:(int)volumeTotalOriginal direction:(int)direction combOffsetFlag:(int)combOffsetFlag brokerID:(NSString *)brokerID callback:(UPCallback)callback {
    [self.tradeClient reqOrderInsert:userID instrumentID:instrumentID price:price volumeTotalOriginal:volumeTotalOriginal direction:direction combOffsetFlag:combOffsetFlag brokerID:brokerID callback:callback];
}

- (void)reqOrderInsert:(NSString *)instrumentID price:(double)price volumeTotalOriginal:(int)volumeTotalOriginal direction:(int)direction combOffsetFlag:(int)combOffsetFlag callback:(UPCallback)callback {
    [self reqOrderInsert:[self userID] instrumentID:instrumentID price:price volumeTotalOriginal:volumeTotalOriginal direction:direction combOffsetFlag:combOffsetFlag brokerID:[self brokerID] callback:callback];
}

- (void)reqOrderAction:(NSString *)userID instrumentID:(NSString *)instrumentID brokerID:(NSString *)brokerID orderRef:(NSString *)orderRef frontID:(int)frontID sessionID:(int)sessionID exchangeID:(NSString *)exchangeID callback:(UPCallback)callback {
    [self.tradeClient reqOrderAction:userID instrumentID:instrumentID brokerID:brokerID orderRef:orderRef frontID:frontID sessionID:sessionID exchangeID:exchangeID callback:callback];
}

- (void)reqOrderAction:(NSString *)instrumentID orderRef:(NSString *)orderRef frontID:(int)frontID sessionID:(int)sessionID exchangeID:(NSString *)exchangeID callback:(UPCallback)callback {
    [self reqOrderAction:[self userID] instrumentID:instrumentID brokerID:[self brokerID] orderRef:orderRef frontID:frontID sessionID:sessionID exchangeID:exchangeID callback:callback];
}

#pragma mark - Query
- (void)reqQueryTradingAccount:(NSString *)userID brokerID:(NSString *)brokerID callback:(UPCallback)callback {
    [self.tradeClient reqQueryTradingAccount:userID brokerID:brokerID callback:callback];
}

- (void)reqQueryTradingAccount:(UPCallback)callback {
    [self reqQueryTradingAccount:[self userID] brokerID:[self brokerID] callback:callback];
}

- (void)reqQueryInvestorPosition:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID callback:(UPCallback)callback {
    [self.tradeClient reqQueryInvestorPosition:userID brokerID:brokerID instrumentID:instrumentID callback:callback];
}

- (void)reqQueryInvestorPosition:(NSString *)instrumentID callback:(UPCallback)callback {
    [self reqQueryInvestorPosition:[self userID] brokerID:[self brokerID] instrumentID:instrumentID callback:callback];
}

- (void)reqQueryInvestorPositionDetail:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID callback:(UPCallback)callback {
    [self.tradeClient reqQueryInvestorPositionDetail:userID brokerID:brokerID instrumentID:instrumentID callback:callback];
}

- (void)reqQueryInvestorPositionDetail:(NSString *)instrumentID callback:(UPCallback)callback {
    [self reqQueryInvestorPositionDetail:[self userID] brokerID:[self brokerID] instrumentID:instrumentID callback:callback];
}

- (void)reqQueryTrade:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID timeStart:(NSString *)timeStart timeEnd:(NSString *)timeEnd callback:(UPCallback)callback {
    [self.tradeClient reqQueryTrade:userID brokerID:brokerID instrumentID:instrumentID timeStart:timeStart timeEnd:timeEnd callback:callback];
}

- (void)reqQueryTrade:(NSString *)instrumentID timeStart:(NSString *)timeStart timeEnd:(NSString *)timeEnd callback:(UPCallback)callback {
    [self reqQueryTrade:[self userID] brokerID:[self brokerID] instrumentID:instrumentID timeStart:timeStart timeEnd:timeEnd callback:callback];
}

- (void)reqQueryDepthMarket:(NSString *)instrumentID callback:(UPCallback)callback {
    [self.tradeClient reqQueryDepthMarket:instrumentID callback:callback];
}

- (void)reqQueryInstrumentMarginRate:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID callback:(UPCallback)callback {
    [self.tradeClient reqQueryInstrumentMarginRate:userID brokerID:brokerID instrumentID:instrumentID callback:callback];
}

- (void)reqQueryInstrumentMarginRate:(NSString *)instrumentID callback:(UPCallback)callback {
    [self reqQueryInstrumentMarginRate:[self userID] brokerID:[self brokerID] instrumentID:instrumentID callback:callback];
}

- (void)reqQueryOrder:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID callback:(UPCallback)callback {
    [self.tradeClient reqQueryOrder:userID brokerID:brokerID instrumentID:instrumentID callback:callback];
}

- (void)reqQueryOrder:(NSString *)instrumentID callback:(UPCallback)callback {
    [self reqQueryOrder:[self userID] brokerID:[self brokerID] instrumentID:instrumentID callback:callback];
}

#pragma mark - Transfer
- (void)reqQueryTransferBank:(UPCallback)callback {
    [self.tradeClient reqQueryTransferBank:callback];
}

- (void)reqQueryTransferSerial:(NSString *)accountID brokerID:(NSString *)brokerID callback:(UPCallback)callback {
    [self.tradeClient reqQueryTransferSerial:accountID brokerID:brokerID callback:callback];
}

- (void)reqQueryTransferSerial:(UPCallback)callback {
    [self reqQueryTransferSerial:[self userID] brokerID:[self brokerID] callback:callback];
}

- (void)reqQueryAccountregister:(NSString *)accountID brokerID:(NSString *)brokerID callback:(UPCallback)callback {
    [self.tradeClient reqQueryAccountregister:accountID brokerID:brokerID callback:callback];
}

- (void)reqQueryAccountregister:(UPCallback)callback {
    [self reqQueryAccountregister:[self userID] brokerID:[self brokerID] callback:callback];
}

- (void)reqBetweenBankAndFuture:(NSString *)userID brokerID:(NSString *)brokerID accountID:(NSString *)accountID bankID:(NSString *)bankID bankBranchID:(NSString *)bankBranchID amount:(double)amount fundPwd:(NSString *)fundPwd bankPwd:(NSString *)bankPwd transferDirection:(int)transferDirection callback:(UPCallback)callback {
    [self.tradeClient reqBetweenBankAndFuture:userID brokerID:brokerID accountID:accountID bankID:bankID bankBranchID:bankBranchID amount:amount fundPwd:fundPwd bankPwd:bankPwd transferDirection:transferDirection callback:callback];
}

- (void)reqBetweenBankAndFuture:(NSString *)accountID bankID:(NSString *)bankID bankBranchID:(NSString *)bankBranchID amount:(double)amount fundPwd:(NSString *)fundPwd bankPwd:(NSString *)bankPwd transferDirection:(int)transferDirection callback:(UPCallback)callback {
    [self reqBetweenBankAndFuture:[self userID] brokerID:[self brokerID] accountID:accountID bankID:bankID bankBranchID:bankBranchID amount:amount fundPwd:fundPwd bankPwd:bankPwd transferDirection:transferDirection callback:callback];
}

- (void)reqQueryBankAccountMoneyByFuture:(NSString *)accountID brokerID:(NSString *)brokerID callback:(UPCallback)callback {
    [self.tradeClient reqQueryBankAccountMoneyByFuture:accountID brokerID:brokerID callback:callback];
}

- (void)reqQueryBankAccountMoneyByFuture:(UPCallback)callback {
    [self reqQueryBankAccountMoneyByFuture:[self userID] brokerID:[self brokerID] callback:callback];
}

#pragma mark - Subscribe MarketData
- (void)subScribeMarketData:(NSArray *)instrumentIDs callback:(UPCallback)callback {
    [self.tradeClient subScribeMarketData:instrumentIDs callback:callback];
}

- (void)unSubScribeMarketData:(NSArray *)instrumentIDs {
    [self.tradeClient unSubScribeMarketData:instrumentIDs];
}

@end
