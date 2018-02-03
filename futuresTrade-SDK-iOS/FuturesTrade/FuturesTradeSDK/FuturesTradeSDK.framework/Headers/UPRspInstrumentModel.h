//
//  UPRspInstrumentModel.h
//  UPFuturesTrade
//
//  Created by UP-LiuL on 17/9/1.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPModel.h"

@interface UPRspInstrumentModel : UPCTPModel

///合约代码
@property (nonatomic, copy) NSString *InstrumentID;
///交易所代码
@property (nonatomic, copy) NSString *ExchangeID;
///合约名称
@property (nonatomic, copy) NSString *InstrumentName;
///合约在交易所的代码
@property (nonatomic, copy) NSString *ExchangeInstID;
///产品代码
@property (nonatomic, copy) NSString *ProductID;
///产品类型
@property (nonatomic, assign) char ProductClass;
///交割年份
@property (nonatomic, assign) int DeliveryYear;
///交割月
@property (nonatomic, assign) int DeliveryMonth;
///市价单最大下单量
@property (nonatomic, assign) int MaxMarketOrderVolume;
///市价单最小下单量
@property (nonatomic, assign) int MinMarketOrderVolume;
///限价单最大下单量
@property (nonatomic, assign) int MaxLimitOrderVolume;
///限价单最小下单量
@property (nonatomic, assign) int MinLimitOrderVolume;
///合约数量乘数
@property (nonatomic, assign) int VolumeMultiple;
///最小变动价位
@property (nonatomic, assign) double PriceTick;
///创建日
@property (nonatomic, copy) NSString *CreateDate;
///上市日
@property (nonatomic, copy) NSString *OpenDate;
///到期日
@property (nonatomic, copy) NSString *ExpireDate;
///开始交割日
@property (nonatomic, copy) NSString *StartDelivDate;
///结束交割日
@property (nonatomic, copy) NSString *EndDelivDate;
///合约生命周期状态
@property (nonatomic, assign) char InstLifePhase;
///当前是否交易
@property (nonatomic, assign) int IsTrading;
///持仓类型
@property (nonatomic, assign) char PositionType;
///持仓日期类型
@property (nonatomic, assign) char PositionDateType;
///多头保证金率
@property (nonatomic, assign) double LongMarginRatio;
///空头保证金率
@property (nonatomic, assign) double ShortMarginRatio;

/***** 非接口返回字段，根据业务需求自己添加的字段 *****/
///索引
@property (nonatomic, copy) NSString *instrumentIndex;
///中文索引
@property (nonatomic, copy) NSString *instrumentChineseIndex;

@end
