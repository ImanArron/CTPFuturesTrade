//
//  UPRspDepthMarketDataModel.h
//  UPFuturesTrade
//
//  Created by UP-LiuL on 17/9/1.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPModel.h"

@interface UPRspDepthMarketDataModel : UPCTPModel

///交易日
@property (nonatomic, copy) NSString *TradingDay;
///合约代码
@property (nonatomic, copy) NSString *InstrumentID;
///交易所代码
@property (nonatomic, copy) NSString *ExchangeID;
///合约在交易所的代码
@property (nonatomic, copy) NSString *ExchangeInstID;
///最新价
@property (nonatomic, assign) double LastPrice;
///上次结算价
@property (nonatomic, assign) double PreSettlementPrice;
///昨收盘
@property (nonatomic, assign) double PreClosePrice;
///昨持仓量
@property (nonatomic, assign) double PreOpenInterest;
///今开盘
@property (nonatomic, assign) double OpenPrice;
///最高价
@property (nonatomic, assign) double HighestPrice;
///最低价
@property (nonatomic, assign) double LowestPrice;
///数量
@property (nonatomic, assign) int Volume;
///成交金额
@property (nonatomic, assign) double Turnover;
///持仓量
@property (nonatomic, assign) double OpenInterest;
///今收盘
@property (nonatomic, assign) double ClosePrice;
///本次结算价
@property (nonatomic, assign) double SettlementPrice;
///涨停板价
@property (nonatomic, assign) double UpperLimitPrice;
///跌停板价
@property (nonatomic, assign) double LowerLimitPrice;
///昨虚实度
@property (nonatomic, assign) double PreDelta;
///今虚实度
@property (nonatomic, assign) double CurrDelta;
///最后修改时间
@property (nonatomic, copy) NSString *UpdateTime;
///最后修改毫秒
@property (nonatomic, assign) int UpdateMillisec;
///申买价一
@property (nonatomic, assign) double BidPrice1;
///申买量一
@property (nonatomic, assign) int BidVolume1;
///申卖价一
@property (nonatomic, assign) double AskPrice1;
///申卖量一
@property (nonatomic, assign) int AskVolume1;
///申买价二
@property (nonatomic, assign) double BidPrice2;
///申买量二
@property (nonatomic, assign) int BidVolume2;
///申卖价二
@property (nonatomic, assign) double AskPrice2;
///申卖量二
@property (nonatomic, assign) int AskVolume2;
///申买价三
@property (nonatomic, assign) double BidPrice3;
///申买量三
@property (nonatomic, assign) int BidVolume3;
///申卖价三
@property (nonatomic, assign) double AskPrice3;
///申卖量三
@property (nonatomic, assign) int AskVolume3;
///申买价四
@property (nonatomic, assign) double BidPrice4;
///申买量四
@property (nonatomic, assign) int BidVolume4;
///申卖价四
@property (nonatomic, assign) double AskPrice4;
///申卖量四
@property (nonatomic, assign) int AskVolume4;
///申买价五
@property (nonatomic, assign) double BidPrice5;
///申买量五
@property (nonatomic, assign) int BidVolume5;
///申卖价五
@property (nonatomic, assign) double AskPrice5;
///申卖量五
@property (nonatomic, assign) int AskVolume5;
///当日均价
@property (nonatomic, assign) double AveragePrice;
///业务日期
@property (nonatomic, copy) NSString *ActionDay;

@end
