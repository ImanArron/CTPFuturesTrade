//
//  UPRspInvestorPositionModel.h
//  FuturesTrade
//
//  Created by UP-LiuL on 17/8/25.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPModel.h"

@interface UPRspInvestorPositionModel : UPCTPModel

///合约代码
@property (nonatomic, copy) NSString *InstrumentID;
///经纪公司代码
@property (nonatomic, copy) NSString *BrokerID;
///投资者代码
@property (nonatomic, copy) NSString *InvestorID;
///持仓多空方向
@property (nonatomic, assign) char PosiDirection;
///投机套保标志
@property (nonatomic, assign) char HedgeFlag;
///持仓日期
@property (nonatomic, assign) char PositionDate;
///上日持仓
@property (nonatomic, assign) int YdPosition;
///今日持仓
@property (nonatomic, assign) int Position;
///多头冻结
@property (nonatomic, assign) int LongFrozen;
///空头冻结
@property (nonatomic, assign) int ShortFrozen;
///开仓冻结金额
@property (nonatomic, assign) double LongFrozenAmount;
///开仓冻结金额
@property (nonatomic, assign) double ShortFrozenAmount;
///开仓量
@property (nonatomic, assign) int OpenVolume;
///平仓量
@property (nonatomic, assign) int CloseVolume;
///开仓金额
@property (nonatomic, assign) double OpenAmount;
///平仓金额
@property (nonatomic, assign) double CloseAmount;
///持仓成本
@property (nonatomic, assign) double PositionCost;
///上次占用的保证金
@property (nonatomic, assign) double PreMargin;
///占用的保证金
@property (nonatomic, assign) double UseMargin;
///冻结的保证金
@property (nonatomic, assign) double FrozenMargin;
///冻结的资金
@property (nonatomic, assign) double FrozenCash;
///冻结的手续费
@property (nonatomic, assign) double FrozenCommission;
///资金差额
@property (nonatomic, assign) double CashIn;
///手续费
@property (nonatomic, assign) double Commission;
///平仓盈亏
@property (nonatomic, assign) double CloseProfit;
///持仓盈亏
@property (nonatomic, assign) double PositionProfit;
///上次结算价
@property (nonatomic, assign) double PreSettlementPrice;
///本次结算价
@property (nonatomic, assign) double SettlementPrice;
///交易日
@property (nonatomic, copy) NSString *TradingDay;
///结算编号
@property (nonatomic, assign) int SettlementID;
///开仓成本
@property (nonatomic, assign) double OpenCost;
///交易所保证金
@property (nonatomic, assign) double ExchangeMargin;
///组合成交形成的持仓
@property (nonatomic, assign) int CombPosition;
///组合多头冻结
@property (nonatomic, assign) int CombLongFrozen;
///组合空头冻结
@property (nonatomic, assign) int CombShortFrozen;
///逐日盯市平仓盈亏
@property (nonatomic, assign) double CloseProfitByDate;
///逐笔对冲平仓盈亏
@property (nonatomic, assign) double CloseProfitByTrade;
///今日持仓
@property (nonatomic, assign) int TodayPosition;
///保证金率
@property (nonatomic, assign) double MarginRateByMoney;
///保证金率(按手数)
@property (nonatomic, assign) double MarginRateByVolume;

/***** 非接口返回字段，根据业务需求自己添加的字段 *****/
///最新价
@property (nonatomic, assign) double LastPrice;
///申卖价一
@property (nonatomic, assign) double AskPrice1;
///申买价一
@property (nonatomic, assign) double BidPrice1;

@end
