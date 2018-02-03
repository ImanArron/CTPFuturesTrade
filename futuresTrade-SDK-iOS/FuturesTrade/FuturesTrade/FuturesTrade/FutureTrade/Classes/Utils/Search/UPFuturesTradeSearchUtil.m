//
//  UPFuturesTradeSearchUtil.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/1.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeSearchUtil.h"
#import <FuturesTradeSDK/UPCTPModelHeader.h>
#import "UPFuturesTradeMacros.h"
#import <FuturesTradeSDK/UPCTPTradeCache.h>
#import "UPFuturesTradeStringUtil.h"

@implementation UPFuturesTradeSearchUtil

+ (NSString *)searchInstrumentName:(NSString *)instrumentId inInstruments:(NSArray *)instruments  tradeType:(UPCTPTradeType)tradeType {
    if (!instruments) {
        instruments = [UPCTPTradeCache instruments:tradeType];
    }
    
    if (UPFuturesTradeIsValidateString(instrumentId) && UPFuturesTradeIsValidateArr(instruments)) {
        for (UPRspInstrumentModel *instrumentModel in instruments) {
            if ([instrumentId isEqual:instrumentModel.InstrumentID]) {
                NSString *instrumentName = [UPFuturesTradeStringUtil trimWhiteSpace:[instrumentModel.InstrumentName copy]];
                if (instrumentName.length > 0) {
                    return instrumentName;
                }
                break;
            }
        }
    }
    return instrumentId;
}

+ (UPRspInstrumentModel *)searchInstrument:(NSString *)instrumentId inInstruments:(NSArray *)instruments tradeType:(UPCTPTradeType)tradeType {
    if (!instruments) {
        instruments = [UPCTPTradeCache instruments:tradeType];
    }
    
    if (UPFuturesTradeIsValidateString(instrumentId) && UPFuturesTradeIsValidateArr(instruments)) {
        for (UPRspInstrumentModel *instrumentModel in instruments) {
            if ([instrumentId isEqual:instrumentModel.InstrumentID]) {
                return instrumentModel;
            }
        }
    }
    
    return nil;
}

@end
