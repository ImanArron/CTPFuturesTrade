//
//  ModelTransferUtil.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/1.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeTransferUtil.h"
#import "UPFuturesTradeVarietyInfoView.h"
#import "UPFuturesTradeSearchUtil.h"

@implementation UPFuturesTradeTransferUtil

+ (UPFuturesTradeVarietyInfoViewModel *)UPRspDepthMarketDataModel2UPFuturesTradeVarietyInfoViewModel:(UPRspDepthMarketDataModel *)depthMarketDataModel instrumnets:(NSArray *)instrumnets tradeType:(UPCTPTradeType)tradeType {
    UPFuturesTradeVarietyInfoViewModel *viewModel = [[UPFuturesTradeVarietyInfoViewModel alloc] init];
    if (depthMarketDataModel) {
        viewModel.name = [UPFuturesTradeSearchUtil searchInstrumentName:depthMarketDataModel.InstrumentID inInstruments:instrumnets tradeType:tradeType];
        viewModel.price = depthMarketDataModel.LastPrice;
        viewModel.riseAndFall = depthMarketDataModel.LastPrice - depthMarketDataModel.PreSettlementPrice;
        viewModel.amplitude = (0 != depthMarketDataModel.PreSettlementPrice) ? (depthMarketDataModel.LastPrice - depthMarketDataModel.PreSettlementPrice)/depthMarketDataModel.PreSettlementPrice : 0;
        viewModel.buyPrice = depthMarketDataModel.BidPrice1;
        viewModel.buyNum = depthMarketDataModel.BidVolume1;
        viewModel.sellPrice = depthMarketDataModel.AskPrice1;
        viewModel.sellNum = depthMarketDataModel.AskVolume1;
    }
    return viewModel;
}

+ (NSString *)bankName:(NSString *)bankID {
    if ([bankID isEqualToString:@"1"]) {
        return @"招商银行";
    } else if ([bankID isEqualToString:@"2"]) {
        return @"工商银行";
    } else if ([bankID isEqualToString:@"3"]) {
        return @"农业银行";
    } else if ([bankID isEqualToString:@"4"]) {
        return @"中国银行";
    } else if ([bankID isEqualToString:@"5"]) {
        return @"建设银行";
    } else if ([bankID isEqualToString:@"6"]) {
        return @"交通银行";
    } else if ([bankID isEqualToString:@"7"]) {
        return @"合作银行";
    } else if ([bankID isEqualToString:@"8"]) {
        return @"工行全国";
    } else if ([bankID isEqualToString:@"9"]) {
        
    } else if ([bankID isEqualToString:@"10"]) {
        
    } else if ([bankID isEqualToString:@"11"]) {
        
    } else if ([bankID isEqualToString:@"12"]) {
        return @"浦发银行";
    } else if ([bankID isEqualToString:@"13"]) {
        return @"民生银行";
    }
    
    return EMPTY;
}

+ (UIImage *)bankImage:(NSString *)bankID {
    NSString *imageName = nil;
    if ([bankID isEqualToString:@"1"]) {
        imageName = @"bank_03";
    } else if ([bankID isEqualToString:@"2"]) {
        imageName = @"bank_12";
    } else if ([bankID isEqualToString:@"3"]) {
        imageName = @"bank_02";
    } else if ([bankID isEqualToString:@"4"]) {
        imageName = @"bank_04";
    } else if ([bankID isEqualToString:@"5"]) {
        imageName = @"bank_01";
    } else if ([bankID isEqualToString:@"6"]) {
        imageName = @"bank_06";
    } else if ([bankID isEqualToString:@"7"]) {
        
    } else if ([bankID isEqualToString:@"8"]) {
        imageName = @"bank_12";
    } else if ([bankID isEqualToString:@"9"]) {
        
    } else if ([bankID isEqualToString:@"10"]) {
        
    } else if ([bankID isEqualToString:@"11"]) {
        
    } else if ([bankID isEqualToString:@"12"]) {
        imageName = @"bank_09";
    } else if ([bankID isEqualToString:@"13"]) {
        imageName = @"bank_16";
    }
    
    return [UIImage imageNamed:[NSString stringWithFormat:@"FuturesTradeBundle.bundle/%@", imageName]];
}

+ (NSString *)transferDirection:(NSString *)tradeCode {
    if ([tradeCode isEqualToString:@"202001"]) {
        return @"银行转期货";
    } else {
        return @"期货转银行";
    }
}

@end
