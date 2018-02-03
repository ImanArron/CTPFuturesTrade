//
//  UPFuturesTradeSearchUtil.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/1.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FuturesTradeSDK/UPCTPDefineHeader.h>

@class UPRspInstrumentModel;

@interface UPFuturesTradeSearchUtil : NSObject

+ (NSString *)searchInstrumentName:(NSString *)instrumentId inInstruments:(NSArray *)instruments tradeType:(UPCTPTradeType)tradeType;
+ (UPRspInstrumentModel *)searchInstrument:(NSString *)instrumentId inInstruments:(NSArray *)instruments tradeType:(UPCTPTradeType)tradeType;

@end
