//
//  UPFuturesTradeTypes.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/6.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#ifndef UPFuturesTradeTypes_h
#define UPFuturesTradeTypes_h

typedef NS_ENUM(NSInteger, UPFuturesTradeTradeOperation) {
    Buy = 0,
    Sell
};

typedef NS_ENUM(NSInteger, UPFuturesTradePositionOperation) {
    OpenPosition = 0,
    ClosePosition,
    ForceClose,
    CloseTodayPosition,
    LockPosition,
    PlusPosition
};

#endif /* UPFuturesTradeTypes_h */
