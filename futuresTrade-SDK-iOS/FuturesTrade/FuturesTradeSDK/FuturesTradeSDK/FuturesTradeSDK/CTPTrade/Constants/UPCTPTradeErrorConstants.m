//
//  UPCTPTradeErrorConstants.m
//  FuturesTrade
//
//  Created by LiuLian on 17/8/18.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPTradeErrorConstants.h"

@implementation UPCTPTradeErrorConstants

NSString * const UPCTPTradeError_NetworkConnectFailed = @"建立网络连接失败";
const NSInteger UPCTPTradeErrorCode_NetworkConnectFailed = 10000;

NSString * const UPCTPTradeError_RequestTimeout = @"请求超时";
const NSInteger UPCTPTradeErrorCode_RequestTimeout = 10001;

NSString * const UPCTPTradeError_IsLoging = @"用户正在登录中";
const NSInteger UPCTPTradeErrorCode_IsLoging = 10002;

NSString * const UPCTPTradeError_RepeatedLogin = @"用户已登录，请不要重复登录";
const NSInteger UPCTPTradeErrorCode_RepeatedLogin = 10003;

NSString * const UPCTPTradeError_SendLoginRequestFailed = @"发送登录请求失败";
const NSInteger UPCTPTradeErrorCode_SendLoginRequestFailed = 10004;

NSString * const UPCTPTradeError_SendLogoutRequestFailed = @"发送登出请求失败";
const NSInteger UPCTPTradeErrorCode_SendLogoutRequestFailed = 10005;

NSString * const UPCTPTradeError_SendRequestWhileNotLogedin = @"网络连接已断开，请稍后再发送";
const NSInteger UPCTPTradeErrorCode_SendRequestWhileNotLogedin = 10006;

NSString * const UPCTPTradeError_SendOrderInsertRequestFailed = @"发送报单请求失败";
const NSInteger UPCTPTradeErrorCode_SendOrderInsertRequestFailed = 10007;

NSString * const UPCTPTradeError_SendQueryTradingAccountRequestFailed = @"发送投资者资金账户查询请求失败";
const NSInteger UPCTPTradeErrorCode_SendQueryTradingAccountRequestFailed = 10008;

NSString * const UPCTPTradeError_SendQueryInvestorPositionRequestFailed = @"发送投资者持仓查询请求失败";
const NSInteger UPCTPTradeErrorCode_SendQueryInvestorPositionRequestFailed = 10009;

NSString * const UPCTPTradeError_RepeatedQueryInvestorPosition = @"正在查询持仓，请不要重复提交";
const NSInteger UPCTPTradeErrorCode_RepeatedQueryInvestorPosition = 10010;

NSString * const UPCTPTradeError_RepeatedQueryTrade = @"正在查询成交，请不要重复提交";
const NSInteger UPCTPTradeErrorCode_RepeatedQueryTrade = 10011;

NSString * const UPCTPTradeError_SendQueryTradeRequestFailed = @"发送投资者成交查询请求失败";
const NSInteger UPCTPTradeErrorCode_SendQueryTradeRequestFailed = 10012;

NSString * const UPCTPTradeError_SendQueryDepthMarketRequestFailed = @"发送深度行情查询请求失败";
const NSInteger UPCTPTradeErrorCode_SendQueryDepthMarketRequestFailed = 10013;

NSString * const UPCTPTradeError_RepeatedQueryInvestorPositionDetail = @"正在查询持仓明细，请不要重复提交";
const NSInteger UPCTPTradeErrorCode_RepeatedQueryInvestorPositionDetail = 10014;

NSString * const UPCTPTradeError_RepeatedQueryOrder = @"正在查询报单，请不要重复提交";
const NSInteger UPCTPTradeErrorCode_RepeatedQueryOrder = 10015;

NSString * const UPCTPTradeError_SendQueryOrderRequestFailed = @"发送投资者报单查询请求失败";
const NSInteger UPCTPTradeErrorCode_SendQueryOrderRequestFailed = 10016;

NSString * const UPCTPTradeError_SendQueryInvestorPositionDetailRequestFailed = @"发送投资者持仓明细查询请求失败";
const NSInteger UPCTPTradeErrorCode_SendQueryInvestorPositionDetailRequestFailed = 10017;

NSString * const UPCTPTradeError_SendOrderActionRequestFailed = @"发送撤单请求失败";
const NSInteger UPCTPTradeErrorCode_SendOrderActionRequestFailed = 10018;

NSString * const UPCTPTradeError_SendQueryTransferBankRequestFailed = @"发送转账银行查询请求失败";
const NSInteger UPCTPTradeErrorCode_SendQueryTransferBankRequestFailed = 10019;

NSString * const UPCTPTradeError_RepeatedQueryTransferBank = @"正在查询转账银行，请不要重复提交";
const NSInteger UPCTPTradeErrorCode_RepeatedQueryTransferBank = 10020;

NSString * const UPCTPTradeError_SendQueryTransferSerialRequestFailed = @"发送转账流水查询请求失败";
const NSInteger UPCTPTradeErrorCode_SendQueryTransferSerialRequestFailed = 10021;

NSString * const UPCTPTradeError_RepeatedQueryTransferSerial = @"正在查询转账流水，请不要重复提交";
const NSInteger UPCTPTradeErrorCode_RepeatedQueryTransferSerial = 10022;

NSString * const UPCTPTradeError_SendQueryAccountregisterRequestFailed = @"发送银期签约关系查询请求失败";
const NSInteger UPCTPTradeErrorCode_SendQueryAccountregisterRequestFailed = 10023;

NSString * const UPCTPTradeError_RepeatedQueryAccountregister = @"正在查询银期签约关系，请不要重复提交";
const NSInteger UPCTPTradeErrorCode_RepeatedQueryAccountregister = 10024;

NSString * const UPCTPTradeError_SendBetweenBankAndFutureRequestFailed = @"发送银行与期货公司转账请求失败";
const NSInteger UPCTPTradeErrorCode_SendBetweenBankAndFutureRequestFailed = 10025;

NSString * const UPCTPTradeError_RepeatedQueryBetweenBankAndFuture = @"正在发送银行与期货公司转账请求，请不要重复提交";
const NSInteger UPCTPTradeErrorCode_RepeatedQueryBetweenBankAndFuture = 10026;

NSString * const UPCTPTradeError_SendQueryBankAccountMoneyRequestFailed = @"发送银行余额查询请求失败";
const NSInteger UPCTPTradeErrorCode_SendQueryBankAccountMoneyRequestFailed = 10027;

NSString * const UPCTPTradeError_RepeatedQueryBankAccountMoney = @"正在查询银行余额，请不要重复提交";
const NSInteger UPCTPTradeErrorCode_RepeatedQueryBankAccountMoney = 10028;

NSString * const UPCTPTradeError_SendQueryInstrumentMarginRateRequestFailed = @"发送合约保证金率查询请求失败";
const NSInteger UPCTPTradeErrorCode_SendQueryInstrumentMarginRateRequestFailed = 10029;

NSString * const UPCTPTradeError_SendCTPLoginRequestFailed = @"发送CTP行情登录请求失败";
const NSInteger UPCTPTradeErrorCode_SendCTPLoginRequestFailed = 10030;

NSString * const UPCTPTradeError_SendCTPLogoutRequestFailed = @"发送CTP行情登出请求失败";
const NSInteger UPCTPTradeErrorCode_SendCTPLogoutRequestFailed = 10031;

NSString * const UPCTPTradeError_SendSubscribeMarketDataRequestFailed = @"发送订阅行情请求失败";
const NSInteger UPCTPTradeErrorCode_SendSubscribeMarketDataRequestFailed = 10032;

@end
