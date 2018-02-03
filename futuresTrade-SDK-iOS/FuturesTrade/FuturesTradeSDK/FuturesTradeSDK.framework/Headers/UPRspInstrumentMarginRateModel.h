//
//  UPRspInstrumentMarginRateModel.h
//  UPFuturesTrade
//
//  Created by UP-LiuL on 17/9/18.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPModel.h"

@interface UPRspInstrumentMarginRateModel : UPCTPModel

///合约代码
@property (nonatomic, copy) NSString *InstrumentID;
///投资者范围
@property (nonatomic, assign) char InvestorRange;
///经纪公司代码
@property (nonatomic, copy) NSString *BrokerID;
///投资者代码
@property (nonatomic, copy) NSString *InvestorID;
///投机套保标志
@property (nonatomic, assign) char HedgeFlag;
///多头保证金率
@property (nonatomic, assign) double LongMarginRatioByMoney;
///多头保证金费
@property (nonatomic, assign) double LongMarginRatioByVolume;
///空头保证金率
@property (nonatomic, assign) double ShortMarginRatioByMoney;
///空头保证金费
@property (nonatomic, assign) double ShortMarginRatioByVolume;
///是否相对交易所收取
@property (nonatomic, assign) int IsRelative;

@end
