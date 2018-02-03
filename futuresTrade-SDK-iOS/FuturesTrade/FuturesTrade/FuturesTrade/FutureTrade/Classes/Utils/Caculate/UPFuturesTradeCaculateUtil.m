//
//  UPFuturesTradeCaculateUtil.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/11.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeCaculateUtil.h"
#import <FuturesTradeSDK/UPCTPModelHeader.h>
#import "UPFuturesTradeSearchUtil.h"

@implementation UPFuturesTradeCaculateUtil

+ (double)staticEquity:(UPRspTradingAccountModel *)tradingAccountModel {
    return tradingAccountModel.PreBalance - tradingAccountModel.Withdraw + tradingAccountModel.Deposit;
}

+ (double)dynamicEquity:(UPRspTradingAccountModel *)tradingAccountModel {
    return [self staticEquity:tradingAccountModel] + tradingAccountModel.CloseProfit + tradingAccountModel.PositionProfit - tradingAccountModel.Commission;
}

+ (double)profit:(UPRspTradingAccountModel *)tradingAccountModel {
    return tradingAccountModel.CloseProfit + tradingAccountModel.PositionProfit;
}

+ (double)risky:(UPRspTradingAccountModel *)tradingAccountModel {
    double dynamicEquity = [self dynamicEquity:tradingAccountModel];
    if (dynamicEquity > 0) {
        return tradingAccountModel.CurrMargin/dynamicEquity;
    }
    
    return 0.f;
}

+ (double)openAmount:(UPRspInvestorPositionModel *)investorPositionModel tradeType:(UPCTPTradeType)tradeType {
    if (investorPositionModel.Position > 0) {
        UPRspInstrumentModel *instrumentModel = [UPFuturesTradeSearchUtil searchInstrument:investorPositionModel.InstrumentID inInstruments:nil tradeType:tradeType];
        if (instrumentModel.VolumeMultiple > 0) {
            return (investorPositionModel.OpenCost/investorPositionModel.Position)/instrumentModel.VolumeMultiple;
        }
    }
    return 0.f;
}

+ (int)canUseNum:(UPRspInvestorPositionModel *)rspInvestorPositionModel {
    if (rspInvestorPositionModel.PosiDirection == '2') {
        return rspInvestorPositionModel.Position - rspInvestorPositionModel.LongFrozen;
    } else {
        return rspInvestorPositionModel.Position - rspInvestorPositionModel.ShortFrozen;
    }
}

@end
