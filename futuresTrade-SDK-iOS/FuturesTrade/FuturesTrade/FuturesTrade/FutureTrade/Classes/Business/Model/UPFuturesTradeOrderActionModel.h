//
//  UPFuturesTradeOrderActionModel.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/6.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPFuturesTradeOrderActionModel : NSObject

// 合约代码
@property (nonatomic, copy) NSString *instrumentID;
// 报单引用
@property (nonatomic, copy) NSString *orderRef;
@property (nonatomic, assign) int frontID;
@property (nonatomic, assign) int sessionID;
///交易所代码
@property (nonatomic, copy) NSString *exchangeID;

@end
