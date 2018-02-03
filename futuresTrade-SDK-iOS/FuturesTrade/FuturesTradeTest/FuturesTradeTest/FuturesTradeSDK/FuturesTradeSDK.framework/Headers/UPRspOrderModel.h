//
//  UPRspOrderModel.h
//  UPFuturesTrade
//
//  Created by UP-LiuL on 17/9/4.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPModel.h"

@interface UPRspOrderModel : UPCTPModel

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
///报单价格条件
@property (nonatomic, assign) char OrderPriceType;
///买卖方向
@property (nonatomic, assign) char Direction;
///组合开平标志
@property (nonatomic, copy) NSString *CombOffsetFlag;
///组合投机套保标志
@property (nonatomic, copy) NSString *CombHedgeFlag;
///价格
@property (nonatomic, assign) double LimitPrice;
///数量
@property (nonatomic, assign) int VolumeTotalOriginal;
///有效期类型
@property (nonatomic, assign) char TimeCondition;
///GTD日期
@property (nonatomic, copy) NSString *GTDDate;
///成交量类型
@property (nonatomic, assign) char VolumeCondition;
///最小成交量
@property (nonatomic, assign) int MinVolume;
///触发条件
@property (nonatomic, assign) char ContingentCondition;
///止损价
@property (nonatomic, assign) double StopPrice;
///强平原因
@property (nonatomic, assign) char ForceCloseReason;
///自动挂起标志
@property (nonatomic, assign) int IsAutoSuspend;
///业务单元
@property (nonatomic, copy) NSString *BusinessUnit;
///请求编号
@property (nonatomic, assign) int RequestID;
///本地报单编号
@property (nonatomic, copy) NSString *OrderLocalID;
///交易所代码
@property (nonatomic, copy) NSString *ExchangeID;
///会员代码
@property (nonatomic, copy) NSString *ParticipantID;
///客户代码
@property (nonatomic, copy) NSString *ClientID;
///合约在交易所的代码
@property (nonatomic, copy) NSString *ExchangeInstID;
///交易所交易员代码
@property (nonatomic, copy) NSString *TraderID;
///安装编号
@property (nonatomic, assign) int InstallID;
///报单提交状态
@property (nonatomic, assign) char OrderSubmitStatus;
///报单提示序号
@property (nonatomic, assign) int NotifySequence;
///交易日
@property (nonatomic, copy) NSString *TradingDay;
///结算编号
@property (nonatomic, assign) int SettlementID;
///报单编号
@property (nonatomic, copy) NSString *OrderSysID;
///报单来源
@property (nonatomic, assign) char OrderSource;
///报单状态
@property (nonatomic, assign) char OrderStatus;
///报单类型
@property (nonatomic, assign) char OrderType;
///今成交数量
@property (nonatomic, assign) int VolumeTraded;
///剩余数量
@property (nonatomic, assign) int VolumeTotal;
///报单日期
@property (nonatomic, copy) NSString *InsertDate;
///委托时间
@property (nonatomic, copy) NSString *InsertTime;
///激活时间
@property (nonatomic, copy) NSString *ActiveTime;
///挂起时间
@property (nonatomic, copy) NSString *SuspendTime;
///最后修改时间
@property (nonatomic, copy) NSString *UpdateTime;
///撤销时间
@property (nonatomic, copy) NSString *CancelTime;
///最后修改交易所交易员代码
@property (nonatomic, copy) NSString *ActiveTraderID;
///结算会员编号
@property (nonatomic, copy) NSString *ClearingPartID;
///序号
@property (nonatomic, assign) int SequenceNo;
///前置编号
@property (nonatomic, assign) int FrontID;
///会话编号
@property (nonatomic, assign) int SessionID;
///用户端产品信息
@property (nonatomic, copy) NSString *UserProductInfo;
///状态信息
@property (nonatomic, copy) NSString *StatusMsg;
///用户强评标志
@property (nonatomic, assign) int UserForceClose;
///操作用户代码
@property (nonatomic, copy) NSString *ActiveUserID;
///经纪公司报单编号
@property (nonatomic, assign) int BrokerOrderSeq;
///相关报单
@property (nonatomic, copy) NSString *RelativeOrderSysID;
///郑商所成交数量
@property (nonatomic, assign) int ZCETotalTradedVolume;
///互换单标志
@property (nonatomic, assign) int IsSwapOrder;

@end
