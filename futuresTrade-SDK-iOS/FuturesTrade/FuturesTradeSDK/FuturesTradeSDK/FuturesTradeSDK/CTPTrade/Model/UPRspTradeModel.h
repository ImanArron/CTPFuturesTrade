//
//  UPRspTradeModel.h
//  FuturesTrade
//
//  Created by LiuLian on 17/8/25.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPModel.h"

@interface UPRspTradeModel : UPCTPModel

///经纪公司代码
@property (nonatomic, copy) NSString *BrokerID;
///投资者代码
@property (nonatomic, copy) NSString *InvestorID;
///合约代码
@property (nonatomic, copy) NSString *InstrumentID;
///报单引用
@property (nonatomic, copy) NSString *OrderRef;
///用户代码
@property (nonatomic, copy) NSString *UserID;
///交易所代码
@property (nonatomic, copy) NSString *ExchangeID;
///成交编号
@property (nonatomic, copy) NSString *TradeID;
///买卖方向
@property (nonatomic, assign) char Direction;
///报单编号
@property (nonatomic, copy) NSString *OrderSysID;
///会员代码
@property (nonatomic, copy) NSString *ParticipantID;
///客户代码
@property (nonatomic, copy) NSString *ClientID;
///交易角色
@property (nonatomic, assign) char TradingRole;
///合约在交易所的代码
@property (nonatomic, copy) NSString *ExchangeInstID;
///开平标志
@property (nonatomic, assign) char OffsetFlag;
///投机套保标志
@property (nonatomic, assign) char HedgeFlag;
///价格
@property (nonatomic, assign) double Price;
///数量
@property (nonatomic, assign) int Volume;
///成交时期
@property (nonatomic, copy) NSString *TradeDate;
///成交时间
@property (nonatomic, copy) NSString *TradeTime;
///成交类型
@property (nonatomic, assign) char TradeType;
///成交价来源
@property (nonatomic, assign) char PriceSource;
///交易所交易员代码
@property (nonatomic, copy) NSString *TraderID;
///本地报单编号
@property (nonatomic, copy) NSString *OrderLocalID;
///结算会员编号
@property (nonatomic, copy) NSString *ClearingPartID;
///业务单元
@property (nonatomic, copy) NSString *BusinessUnit;
///序号
@property (nonatomic, assign) int SequenceNo;
///交易日
@property (nonatomic, copy) NSString *TradingDay;
///结算编号
@property (nonatomic, assign) int SettlementID;
///经纪公司报单编号
@property (nonatomic, assign) int BrokerOrderSeq;
///成交来源
@property (nonatomic, assign) char TradeSource;

@end
