//
//  UPRspOrderActionModel.h
//  UPFuturesTrade
//
//  Created by UP-LiuL on 17/9/6.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPModel.h"

@interface UPRspOrderActionModel : UPCTPModel

///经纪公司代码
@property (nonatomic, copy) NSString *BrokerID;
///投资者代码
@property (nonatomic, copy) NSString *InvestorID;
///报单操作引用
@property (nonatomic, assign) int OrderActionRef;
///报单引用
@property (nonatomic, copy) NSString *OrderRef;
///请求编号
@property (nonatomic, assign) int RequestID;
///前置编号
@property (nonatomic, assign) int FrontID;
///会话编号
@property (nonatomic, assign) int SessionID;
///交易所代码
@property (nonatomic, copy) NSString *ExchangeID;
///报单编号
@property (nonatomic, copy) NSString *OrderSysID;
///操作标志
@property (nonatomic, assign) char ActionFlag;
///价格
@property (nonatomic, assign) double LimitPrice;
///数量变化
@property (nonatomic, assign) int VolumeChange;
///用户代码
@property (nonatomic, copy) NSString *UserID;
///合约代码
@property (nonatomic, copy) NSString *InstrumentID;

@end
