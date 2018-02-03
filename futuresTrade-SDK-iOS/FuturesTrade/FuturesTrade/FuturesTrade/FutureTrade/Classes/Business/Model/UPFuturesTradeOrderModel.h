//
//  UPFuturesTradeOrderModel.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/6.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPFuturesTradeMacros.h"

@interface UPFuturesTradeOrderModel : NSObject

// 合约名称
@property (nonatomic, copy) NSString *instrumentName;
// 合约代码
@property (nonatomic, copy) NSString *instrumentID;
// 仓位类型
@property (nonatomic, assign) UPFuturesTradePositionOperation positionOperation;
// 买卖方向
@property (nonatomic, assign) UPFuturesTradeTradeOperation tradeOperation;
// 价格
@property (nonatomic, assign) double price;
// 手数
@property (nonatomic, assign) int num;

@end
