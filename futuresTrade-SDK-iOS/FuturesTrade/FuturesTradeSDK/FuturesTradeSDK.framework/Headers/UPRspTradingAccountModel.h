//
//  UPRspTradingAccountModel.h
//  FuturesTrade
//
//  Created by UP-LiuL on 17/8/25.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPModel.h"

@interface UPRspTradingAccountModel : UPCTPModel

///经纪公司代码
@property (nonatomic, copy) NSString *BrokerID;
///投资者帐号
@property (nonatomic, copy) NSString *AccountID;
///上次质押金额
@property (nonatomic, assign) double PreMortgage;
///上次信用额度
@property (nonatomic, assign) double PreCredit;
///上次存款额
@property (nonatomic, assign) double PreDeposit;
///上次结算准备金
@property (nonatomic, assign) double PreBalance;
///上次占用的保证金
@property (nonatomic, assign) double PreMargin;
///利息基数
@property (nonatomic, assign) double InterestBase;
///利息收入
@property (nonatomic, assign) double Interest;
///入金金额
@property (nonatomic, assign) double Deposit;
///出金金额
@property (nonatomic, assign) double Withdraw;
///冻结的保证金
@property (nonatomic, assign) double FrozenMargin;
///冻结的资金
@property (nonatomic, assign) double FrozenCash;
///冻结的手续费
@property (nonatomic, assign) double FrozenCommission;
///当前保证金总额
@property (nonatomic, assign) double CurrMargin;
///资金差额
@property (nonatomic, assign) double CashIn;
///手续费
@property (nonatomic, assign) double Commission;
///平仓盈亏
@property (nonatomic, assign) double CloseProfit;
///持仓盈亏
@property (nonatomic, assign) double PositionProfit;
///期货结算准备金
@property (nonatomic, assign) double Balance;
///可用资金
@property (nonatomic, assign) double Available;
///可取资金
@property (nonatomic, assign) double WithdrawQuota;
///基本准备金
@property (nonatomic, assign) double Reserve;
///交易日
@property (nonatomic, copy) NSString *TradingDay;
///结算编号
@property (nonatomic, assign) int SettlementID;
///信用额度
@property (nonatomic, assign) double Credit;
///质押金额
@property (nonatomic, assign) double Mortgage;
///交易所保证金
@property (nonatomic, assign) double ExchangeMargin;
///投资者交割保证金
@property (nonatomic, assign) double DeliveryMargin;
///交易所交割保证金
@property (nonatomic, assign) double ExchangeDeliveryMargin;

@end
