//
//  UPRspUserLoginModel.h
//  FuturesTrade
//
//  Created by LiuLian on 17/8/14.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPModel.h"

@interface UPRspUserLoginModel : UPCTPModel <NSCoding>

///交易日
@property (nonatomic, copy) NSString *TradingDay;
///登录成功时间
@property (nonatomic, copy) NSString *LoginTime;
///经纪公司代码
@property (nonatomic, copy) NSString *BrokerID;
///用户代码
@property (nonatomic, copy) NSString *UserID;
///交易系统名称
@property (nonatomic, copy) NSString *SystemName;
///前置编号
@property (nonatomic, assign) NSInteger FrontID;
///会话编号
@property (nonatomic, assign) NSInteger SessionID;
///最大报单引用
@property (nonatomic, copy) NSString *MaxOrderRef;
///上期所时间
@property (nonatomic, copy) NSString *SHFETime;
///大商所时间
@property (nonatomic, copy) NSString *DCETime;
///郑商所时间
@property (nonatomic, copy) NSString *CZCETime;
///中金所时间
@property (nonatomic, copy) NSString *FFEXTime;

@end
