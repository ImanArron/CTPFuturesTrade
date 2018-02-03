//
//  UPRspInvestorPositionDetailModel.h
//  UPFuturesTrade
//
//  Created by UP-LiuL on 17/9/4.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPModel.h"

@interface UPRspInvestorPositionDetailModel : UPCTPModel

///合约代码
@property (nonatomic, copy) NSString *InstrumentID;
///经纪公司代码
@property (nonatomic, copy) NSString *BrokerID;
///投资者代码
@property (nonatomic, copy) NSString *InvestorID;
///投机套保标志
@property (nonatomic, assign) char HedgeFlag;
///买卖
@property (nonatomic, assign) char Direction;
///开仓日期
@property (nonatomic, copy) NSString *OpenDate;
///成交编号
@property (nonatomic, copy) NSString *TradeID;
///数量
@property (nonatomic, assign) int Volume;
///开仓价
@property (nonatomic, assign) double OpenPrice;
///交易日
@property (nonatomic, copy) NSString *TradingDay;
///结算编号
@property (nonatomic, assign) int SettlementID;
///成交类型
@property (nonatomic, assign) char TradeType;
///组合合约代码
@property (nonatomic, copy) NSString *CombInstrumentID;
///交易所代码
@property (nonatomic, copy) NSString *ExchangeID;
///逐日盯市平仓盈亏
@property (nonatomic, assign) double CloseProfitByDate;
///逐笔对冲平仓盈亏
@property (nonatomic, assign) double CloseProfitByTrade;
///逐日盯市持仓盈亏
@property (nonatomic, assign) double PositionProfitByDate;
///逐笔对冲持仓盈亏
@property (nonatomic, assign) double PositionProfitByTrade;
///投资者保证金
@property (nonatomic, assign) double Margin;
///交易所保证金
@property (nonatomic, assign) double ExchMargin;
///保证金率
@property (nonatomic, assign) double MarginRateByMoney;
///保证金率(按手数)
@property (nonatomic, assign) double MarginRateByVolume;
///昨结算价
@property (nonatomic, assign) double LastSettlementPrice;
///结算价
@property (nonatomic, assign) double SettlementPrice;
///平仓量
@property (nonatomic, assign) int CloseVolume;
///平仓金额
@property (nonatomic, assign) double CloseAmount;

@end
