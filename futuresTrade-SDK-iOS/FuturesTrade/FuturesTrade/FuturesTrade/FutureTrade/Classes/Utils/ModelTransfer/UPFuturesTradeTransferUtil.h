//
//  ModelTransferUtil.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/1.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FuturesTradeSDK/UPCTPModelHeader.h>
#import <UIKit/UIKit.h>
#import <FuturesTradeSDK/UPCTPDefineHeader.h>

@class UPFuturesTradeVarietyInfoViewModel;

@interface UPFuturesTradeTransferUtil : NSObject

+ (UPFuturesTradeVarietyInfoViewModel *)UPRspDepthMarketDataModel2UPFuturesTradeVarietyInfoViewModel:(UPRspDepthMarketDataModel *)depthMarketDataModel instrumnets:(NSArray *)instrumnets tradeType:(UPCTPTradeType)tradeType;
+ (NSString *)bankName:(NSString *)bankID;
+ (UIImage *)bankImage:(NSString *)bankID;
+ (NSString *)transferDirection:(NSString *)tradeCode;

@end
