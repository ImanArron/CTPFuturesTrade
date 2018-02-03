//
//  UPCTPDefineHeader.h
//  FuturesTrade
//
//  Created by LiuLian on 17/8/14.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#ifndef UPCTPDefineHeader_h
#define UPCTPDefineHeader_h

typedef void(^UPCallback)(id result, NSError *error);
typedef void(^UPCompletionBlock)(BOOL successed, NSError *error);

typedef NS_ENUM(NSInteger, UPCTPTradeType) {
    UPCTPRealTrade,                 // 实盘交易
    UPCTPSimulateTrade              // 模拟交易
};

#define REQUEST_TIME_OUT_NOTIFICATION @"REQUEST_TIME_OUT_NOTIFICATION"
#define ORDER_ACTION_NOTIFICATION @"ORDER_ACTION_NOTIFICATION"
#define ON_RTN_DEPTH_MARKETDATA_NOTIFICATION @"ON_RTN_DEPTH_MARKETDATA_NOTIFICATION"
#define SUBSCRIBE_MARKETDATA_REQUESTID 65536

#endif /* UPCTPDefineHeader_h */
