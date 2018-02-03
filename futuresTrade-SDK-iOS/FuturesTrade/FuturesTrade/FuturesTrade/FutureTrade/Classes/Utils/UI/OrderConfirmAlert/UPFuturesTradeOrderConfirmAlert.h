//
//  UPFuturesTradeOrderConfirmAlert.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/6.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPFuturesTradeMacros.h"

@class UPFuturesTradeOrderModel;
@class UPRspOrderModel;
@class UPRspInvestorPositionModel;

typedef void(^UPFuturesTradeOrderConfirmAlertBlock)(id model);

@interface UPFuturesTradeOrderConfirmAlert : NSObject

- (void)showOrderConfirmAlert:(UPRspInvestorPositionModel *)positionModel positionOperation:(UPFuturesTradePositionOperation)positionOperation block:(UPFuturesTradeOrderConfirmAlertBlock)block;

- (void)showOrderActionConfirmAlert:(UPRspOrderModel *)orderModel block:(UPFuturesTradeOrderConfirmAlertBlock)block;

@end
