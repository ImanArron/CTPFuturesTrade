//
//  UPFuturesTradeCaculateUtil.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/11.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FuturesTradeSDK/UPCTPDefineHeader.h>

@class UPRspTradingAccountModel;
@class UPRspInvestorPositionModel;

@interface UPFuturesTradeCaculateUtil : NSObject

+ (double)staticEquity:(UPRspTradingAccountModel *)tradingAccountModel;
+ (double)dynamicEquity:(UPRspTradingAccountModel *)tradingAccountModel;
+ (double)profit:(UPRspTradingAccountModel *)tradingAccountModel;
+ (double)risky:(UPRspTradingAccountModel *)tradingAccountModel;
+ (double)openAmount:(UPRspInvestorPositionModel *)investorPositionModel tradeType:(UPCTPTradeType)tradeType;
+ (int)canUseNum:(UPRspInvestorPositionModel *)rspInvestorPositionModel;

@end
