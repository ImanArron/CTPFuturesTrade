//
//  UPCTPTradeClient.m
//  FuturesTrade
//
//  Created by LiuLian on 17/8/21.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPTradeClient.h"
#import "UPCThostFtdcTraderService.h"

@interface UPCTPTradeClient ()

@property (nonatomic, strong) UPCTPRequestQueue *ctpRequestQueue;

@end

@implementation UPCTPTradeClient

#pragma mark - Init
+ (instancetype)sharedTradeClient {
    static UPCTPTradeClient *client = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        client = [[self alloc] init];
    });
    return client;
}

#pragma mark - Getter

- (UPCTPTradeType)tradeType {
    return UPCTPRealTrade;
}

- (UPCTPRequestQueue *)ctpRequestQueue {
    if (UPCTPRealTrade == self.tradeType) {
        return [UPCTPRequestQueue sharedRequestQueue];
    } else {
        return [UPCTPSimRequestQueue sharedSimRequestQueue];
    }
}

#pragma mark - Trade
- (void)reqOrderInsert:(NSString *)userID instrumentID:(NSString *)instrumentID price:(double)price volumeTotalOriginal:(int)volumeTotalOriginal direction:(int)direction combOffsetFlag:(int)combOffsetFlag brokerID:(NSString *)brokerID callback:(UPCallback)callback {
    NSAssert(userID, @"用户ID为空");
    NSAssert(instrumentID, @"合约代码为空");
//    NSAssert(price > 0, @"交易价格小于0");
//    NSAssert(volumeTotalOriginal > 0, @"数量小于0");
    NSAssert(callback, @"报单请求的callback为空");
    
    if (callback) {
        NSArray *params = @[
                            userID?userID:@"",
                            instrumentID?instrumentID:@"",
                            @(price),
                            @(volumeTotalOriginal),
                            @(direction),
                            @(combOffsetFlag),
                            brokerID?brokerID:@"",
                            callback
                            ];
        [self.ctpRequestQueue enqueue:@{@(UPCTPRequestCode_OrderInsert):params}];
    }
}

- (void)reqOrderAction:(NSString *)userID instrumentID:(NSString *)instrumentID brokerID:(NSString *)brokerID orderRef:(NSString *)orderRef frontID:(int)frontID sessionID:(int)sessionID exchangeID:(NSString *)exchangeID callback:(UPCallback)callback {
    NSAssert(userID, @"用户ID为空");
    NSAssert(instrumentID, @"合约代码为空");
    NSAssert(orderRef, @"报单编号为空");
    NSAssert(callback, @"撤单请求的callback为空");
    
    if (callback) {
        NSArray *params = @[
                            userID?userID:@"",
                            instrumentID?instrumentID:@"",
                            brokerID?brokerID:@"",
                            orderRef?orderRef:@"",
                            @(frontID),
                            @(sessionID),
                            exchangeID?exchangeID:@"",
                            callback
                            ];
        [self.ctpRequestQueue enqueue:@{@(UPCTPRequestCode_OrderAction):params}];
    }
}

#pragma mark - Query
- (void)reqQueryTradingAccount:(NSString *)userID brokerID:(NSString *)brokerID callback:(UPCallback)callback {
    NSAssert(userID, @"用户ID为空");
    NSAssert(callback, @"报单请求的callback为空");
    
    if (callback) {
        NSArray *params = @[
                            userID?userID:@"",
                            brokerID?brokerID:@"",
                            callback
                            ];
        [self.ctpRequestQueue enqueue:@{@(UPCTPRequestCode_TradingAccount):params}];
    }
}

- (void)reqQueryInvestorPosition:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID callback:(UPCallback)callback {
    NSAssert(userID, @"用户ID为空");
    NSAssert(callback, @"报单请求的callback为空");
    
    if (callback) {
        NSArray *params = @[
                            userID?userID:@"",
                            brokerID?brokerID:@"",
                            instrumentID?instrumentID:@"",
                            callback
                            ];
        [self.ctpRequestQueue enqueue:@{@(UPCTPRequestCode_InvestorPosition):params}];
    }
}

- (void)reqQueryInvestorPositionDetail:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID callback:(UPCallback)callback {
    NSAssert(userID, @"用户ID为空");
    NSAssert(callback, @"报单请求的callback为空");
    
    if (callback) {
        NSArray *params = @[
                            userID?userID:@"",
                            brokerID?brokerID:@"",
                            instrumentID?instrumentID:@"",
                            callback
                            ];
        [self.ctpRequestQueue enqueue:@{@(UPCTPRequestCode_InvestorPositionDetail):params}];
    }
}

- (void)reqQueryTrade:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID timeStart:(NSString *)timeStart timeEnd:(NSString *)timeEnd callback:(UPCallback)callback {
    NSAssert(userID, @"用户ID为空");
    NSAssert(callback, @"报单请求的callback为空");
    
    if (callback) {
        NSArray *params = @[
                            userID?userID:@"",
                            brokerID?brokerID:@"",
                            instrumentID?instrumentID:@"",
                            timeStart?timeStart:@"",
                            timeEnd?timeEnd:@"",
                            callback
                            ];
        [self.ctpRequestQueue enqueue:@{@(UPCTPRequestCode_Trade):params}];
    }
}

- (void)reqQueryDepthMarket:(NSString *)instrumentID callback:(UPCallback)callback {
    NSAssert(instrumentID, @"合约代码为空");
    NSAssert(callback, @"深度行情请求的callback为空");
    
    if (callback) {
        NSArray *params = @[
                            instrumentID?instrumentID:@"",
                            callback
                            ];
        [self.ctpRequestQueue enqueue:@{@(UPCTPRequestCode_DepthMarket):params}];
    }
}

- (void)reqQueryInstrumentMarginRate:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID callback:(UPCallback)callback {
    NSAssert(userID, @"用户ID为空");
    NSAssert(instrumentID, @"合约代码为空");
    NSAssert(callback, @"保证金率请求的callback为空");
    
    if (callback) {
        NSArray *params = @[
                            userID?userID:@"",
                            brokerID?brokerID:@"",
                            instrumentID?instrumentID:@"",
                            callback
                            ];
        [self.ctpRequestQueue enqueue:@{@(UPCTPRequestCode_InstrumentMarginRate):params}];
    }
}

- (void)reqQueryOrder:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID callback:(UPCallback)callback {
    NSAssert(userID, @"用户ID为空");
    NSAssert(callback, @"报单请求的callback为空");
    
    if (callback) {
        NSArray *params = @[
                            userID?userID:@"",
                            brokerID?brokerID:@"",
                            instrumentID?instrumentID:@"",
                            callback
                            ];
        [self.ctpRequestQueue enqueue:@{@(UPCTPRequestCode_Order):params}];
    }
}

#pragma mark - Transfer
- (void)reqQueryTransferBank:(UPCallback)callback {
    if (callback) {
        NSArray *params = @[
                            callback
                            ];
        [self.ctpRequestQueue enqueue:@{@(UPCTPRequestCode_TransferBank):params}];
    }
}

- (void)reqQueryTransferSerial:(NSString *)accountID brokerID:(NSString *)brokerID callback:(UPCallback)callback {
    NSAssert(accountID, @"用户ID为空");
    NSAssert(callback, @"转账流水请求的callback为空");
    
    if (callback) {
        NSArray *params = @[
                            accountID?accountID:@"",
                            brokerID?brokerID:@"",
                            callback
                            ];
        [self.ctpRequestQueue enqueue:@{@(UPCTPRequestCode_TransferSerial):params}];
    }
}

- (void)reqQueryAccountregister:(NSString *)accountID brokerID:(NSString *)brokerID callback:(UPCallback)callback {
    NSAssert(accountID, @"用户ID为空");
    NSAssert(callback, @"银期签约关系请求的callback为空");
    
    if (callback) {
        NSArray *params = @[
                            accountID?accountID:@"",
                            brokerID?brokerID:@"",
                            callback
                            ];
        [self.ctpRequestQueue enqueue:@{@(UPCTPRequestCode_Accountregister):params}];
    }
}

- (void)reqBetweenBankAndFuture:(NSString *)userID brokerID:(NSString *)brokerID accountID:(NSString *)accountID bankID:(NSString *)bankID bankBranchID:(NSString *)bankBranchID amount:(double)amount fundPwd:(NSString *)fundPwd bankPwd:(NSString *)bankPwd transferDirection:(int)transferDirection callback:(UPCallback)callback {
    NSAssert(userID, @"用户ID为空");
    NSAssert(bankID, @"bankID为空");
    NSAssert(accountID, @"银行账号为空");
    NSAssert(bankBranchID, @"bankBranchID为空");
    NSAssert(fundPwd, @"资金密码为空");
    NSAssert(bankPwd, @"银行密码为空");
    NSAssert(amount > 0, @"转账金额小于0");
    NSAssert(callback, @"银期签约关系请求的callback为空");
    
    if (callback) {
        NSArray *params = @[
                            userID?userID:@"",
                            brokerID?brokerID:@"",
                            accountID?accountID:@"",
                            bankID?bankID:@"",
                            bankBranchID?bankBranchID:@"",
                            @(amount),
                            fundPwd?fundPwd:@"",
                            bankPwd?bankPwd:@"",
                            @(transferDirection),
                            callback
                            ];
        [self.ctpRequestQueue enqueue:@{@(UPCTPRequestCode_BetweenBankAndFuture):params}];
    }
}

- (void)reqQueryBankAccountMoneyByFuture:(NSString *)accountID brokerID:(NSString *)brokerID callback:(UPCallback)callback {
    NSAssert(accountID, @"用户ID为空");
    NSAssert(callback, @"银期签约关系请求的callback为空");
    
    if (callback) {
        NSArray *params = @[
                            accountID?accountID:@"",
                            brokerID?brokerID:@"",
                            callback
                            ];
        [self.ctpRequestQueue enqueue:@{@(UPCTPRequestCode_BankAccountMoney):params}];
    }
}

#pragma mark - Subscribe MarketData
- (void)subScribeMarketData:(NSArray *)instrumentIDs callback:(UPCallback)callback {
    NSAssert(instrumentIDs, @"合约ID为空");
    NSAssert(callback, @"订阅行情的callback为空");
    
    NSArray *params = @[
                        instrumentIDs?instrumentIDs:@[],
                        callback
                        ];
    [self.ctpRequestQueue enqueue:@{@(UPCTPRequestCode_SubscribeMarketData):params}];
}

- (void)unSubScribeMarketData:(NSArray *)instrumentIDs {
    NSAssert(instrumentIDs, @"合约ID为空");
    
    NSArray *params = @[
                        instrumentIDs?instrumentIDs:@[]
                        ];
    [self.ctpRequestQueue enqueue:@{@(UPCTPRequestCode_UnSubscribeMarketData):params}];
}

@end
