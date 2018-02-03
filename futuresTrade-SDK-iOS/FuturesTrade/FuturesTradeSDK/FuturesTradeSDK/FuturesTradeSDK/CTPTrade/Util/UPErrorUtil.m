//
//  UPErrorUtil.m
//  FuturesTrade
//
//  Created by LiuLian on 17/8/16.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPErrorUtil.h"
#import "UPCTPModelHeader.h"
#import "UPCTPTradeErrorConstants.h"
#import "UPCTPRequestCode.h"

@implementation UPErrorUtil

+ (NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)code {
    if (domain && 0 != code) {
        return [NSError errorWithDomain:domain code:code userInfo:nil];
    }
    
    return nil;
}

+ (NSError *)errorWithRspInfo:(UPRspInfoModel *)pRspInfo {
    return [self errorWithDomain:pRspInfo.ErrorMsg code:pRspInfo.ErrorID];
}

+ (NSString *)errorDomainWithReqCode:(NSInteger)reqCode {
    NSMutableString *domain = [NSMutableString stringWithString:UPCTPTradeError_SendRequestWhileNotLogedin];
    if (UPCTPRequestCode_Logout == reqCode) {
        [domain appendString:@"登出"];
    } else if (UPCTPRequestCode_OrderInsert == reqCode) {
        [domain appendString:@"报单"];
    } else if (UPCTPRequestCode_TradingAccount == reqCode) {
        [domain appendString:@"查询资金账户"];
    } else if (UPCTPRequestCode_InvestorPosition == reqCode) {
        [domain appendString:@"查询持仓"];
    } else if (UPCTPRequestCode_Trade == reqCode) {
        [domain appendString:@"查询成交"];
    } else if (UPCTPRequestCode_DepthMarket == reqCode) {
        [domain appendString:@"查询深度行情"];
    } else if (UPCTPRequestCode_InvestorPositionDetail == reqCode) {
        [domain appendString:@"查询持仓明细"];
    } else if (UPCTPRequestCode_Order == reqCode) {
        [domain appendString:@"查询报单"];
    } else if (UPCTPRequestCode_OrderAction == reqCode) {
        [domain appendString:@"撤单"];
    } else if (UPCTPRequestCode_TransferBank == reqCode) {
        [domain appendString:@"查询转账银行"];
    } else if (UPCTPRequestCode_TransferSerial == reqCode) {
        [domain appendString:@"查询转账流水"];
    } else if (UPCTPRequestCode_Accountregister == reqCode) {
        [domain appendString:@"查询银期签约关系"];
    } else if (UPCTPRequestCode_BetweenBankAndFuture == reqCode) {
        [domain appendString:@"银行与期货公司转账"];
    } else if (UPCTPRequestCode_BankAccountMoney == reqCode) {
        [domain appendString:@"银行余额"];
    } else if (UPCTPRequestCode_InstrumentMarginRate == reqCode) {
        [domain appendString:@"合约保证金率"];
    }
    [domain appendString:@"请求"];
    return [domain copy];
}

@end
