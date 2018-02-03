//
//  UPFuturesTradeWeakStrong.h
//  FuturesTradeDemo
//
//  Created by LiuLian on 17/8/28.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#ifndef UPFuturesTradeWeakStrong_h
#define UPFuturesTradeWeakStrong_h

#define UPFuturesTradeWeakSelf(type)    __weak typeof(type) weak##type = type;
#define UPFuturesTradeStrongSelf(type)  __strong typeof(type) type = weak##type;

#endif /* UPFuturesTradeWeakStrong_h */
