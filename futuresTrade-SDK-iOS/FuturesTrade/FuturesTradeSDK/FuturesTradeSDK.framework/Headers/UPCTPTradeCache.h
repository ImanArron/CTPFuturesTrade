//
//  UPCTPTradeCache.h
//  FuturesTrade
//
//  Created by UP-LiuL on 17/8/23.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPCTPDefineHeader.h"

@class UPRspUserLoginModel;

@interface UPCTPTradeCache : NSObject

#pragma mark - Document Path
+ (NSString *)documentPath;

#pragma mark - Cache UPRspUserLoginModel
+ (BOOL)cacheRspUserLoginModel:(UPRspUserLoginModel *)rspUserLoginModel tradeType:(UPCTPTradeType)tradeType;
+ (UPRspUserLoginModel *)cachedRspUserLoginModel:(UPCTPTradeType)tradeType;

#pragma mark - Instruments
+ (NSArray *)instruments:(UPCTPTradeType)tradeType;

@end
