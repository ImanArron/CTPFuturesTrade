//
//  UPRspOrderInsertModel.h
//  FuturesTrade
//
//  Created by LiuLian on 17/8/23.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPModel.h"

@interface UPRspOrderInsertModel : UPCTPModel

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
///用户强评标志
@property (nonatomic, assign) int UserForceClose;
///互换单标志
@property (nonatomic, assign) int IsSwapOrder;

@end
