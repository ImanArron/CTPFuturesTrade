//
//  UPFuturesTradeOrderConfirmAlert.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/6.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeOrderConfirmAlert.h"
#import <UIKit/UIKit.h>
#import <FuturesTradeSDK/UPCTPModelHeader.h>
#import "UPFuturesTradeStringUtil.h"
#import "UPFuturesTradeOrderModel.h"
#import "UPFuturesTradeOrderActionModel.h"
#import "UPFuturesTradeNumberUtil.h"

static const NSInteger OrderConfirmAlertTag = 9999;
static const NSInteger OrderActionConfirmAlertTag = 9998;

@interface UPFuturesTradeOrderConfirmAlert () <UIAlertViewDelegate>

@property (nonatomic, copy) UPFuturesTradeOrderConfirmAlertBlock orderBlock;
@property (nonatomic, copy) UPFuturesTradeOrderConfirmAlertBlock orderActionBlock;
@property (nonatomic, strong) UPFuturesTradeOrderModel *tradeOrderModel;
@property (nonatomic, strong) UPFuturesTradeOrderActionModel *tradeOrderActionModel;

@end

@implementation UPFuturesTradeOrderConfirmAlert

- (void)showOrderConfirmAlert:(UPRspInvestorPositionModel *)positionModel positionOperation:(UPFuturesTradePositionOperation)positionOperation block:(UPFuturesTradeOrderConfirmAlertBlock)block {
    _orderBlock = [block copy];
    [self setupTradeOrderModel:positionModel positionOperation:positionOperation];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self titleForPositionOperation:positionOperation]
                                                    message:[self messageForPositionModel:positionModel positionOperation:positionOperation]
                                                    delegate:self
                                                    cancelButtonTitle:@"取消"
                                                    otherButtonTitles:@"确定", nil];
    alert.tag = OrderConfirmAlertTag;
    [alert show];
}

- (void)showOrderActionConfirmAlert:(UPRspOrderModel *)orderModel block:(UPFuturesTradeOrderConfirmAlertBlock)block {
    _orderActionBlock = [block copy];
    [self setupTradeOrderActionModel:orderModel];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"撤单"
                                                    message:[self messageForOrderModel:orderModel]
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = OrderActionConfirmAlertTag;
    [alert show];
}

- (NSString *)titleForPositionOperation:(UPFuturesTradePositionOperation)positionOperation {
    NSString *operatePositionName = @"";
    switch (positionOperation) {
        case OpenPosition:
            operatePositionName = @"开仓";
            break;
        
        case ClosePosition:
            operatePositionName = @"平仓";
            break;
            
        case ForceClose:
            operatePositionName = @"强平";
            break;
            
        case CloseTodayPosition:
            operatePositionName = @"平今";
            break;
            
        case LockPosition:
            operatePositionName = @"锁仓";
            break;
            
        default:
            break;
    }
    
    return operatePositionName;
}

- (NSString *)messageForPositionModel:(UPRspInvestorPositionModel *)positionModel positionOperation:(UPFuturesTradePositionOperation)positionOperation {
    NSMutableString *message = [NSMutableString string];
    [message appendFormat:@"合约代码=%@\r\n", positionModel.InstrumentID];
    [message appendFormat:@"持仓方向=%@\r\n", [UPFuturesTradeStringUtil posiDirection:positionModel.PosiDirection]];
    [message appendFormat:@"总持仓=%@\r\n", @(positionModel.Position)];
    if (ClosePosition == positionOperation) {
        [message appendFormat:@"可平=%@", @(positionModel.Position)];
    } else if (CloseTodayPosition == positionOperation) {
        [message appendFormat:@"可平今=%@", @(positionModel.TodayPosition)];
    } else {
        [message appendFormat:@"总可平=%@", @(positionModel.Position)];
    }
    return [message copy];
}

- (NSString *)messageForOrderModel:(UPRspOrderModel *)orderModel {
    NSMutableString *message = [NSMutableString string];
    [message appendFormat:@"合约代码=%@\r\n", orderModel.InstrumentID];
    [message appendFormat:@"报单方向=%@\r\n", [UPFuturesTradeStringUtil posiDetailDirection:orderModel.Direction]];
    [message appendFormat:@"报单价格=%@\r\n", [UPFuturesTradeNumberUtil double2String:orderModel.LimitPrice]];
    [message appendFormat:@"委托量=%@", @(orderModel.VolumeTotalOriginal)];
    return [message copy];
}

- (void)setupTradeOrderModel:(UPRspInvestorPositionModel *)positionModel positionOperation:(UPFuturesTradePositionOperation)positionOperation {
    _tradeOrderModel = [[UPFuturesTradeOrderModel alloc] init];
    _tradeOrderModel.instrumentID = positionModel.InstrumentID;
    _tradeOrderModel.positionOperation = positionOperation;
    if (OpenPosition == positionOperation || LockPosition == positionOperation) {
        _tradeOrderModel.tradeOperation = Buy;
    } else {
        if ([UPFuturesTradeStringUtil isMultipleWarehouse:positionModel.PosiDirection]) {
            _tradeOrderModel.tradeOperation = Sell;
        } else {
            _tradeOrderModel.tradeOperation = Buy;
        }
    }
    if (Buy == _tradeOrderModel.tradeOperation) {   // 买，取卖一价
        _tradeOrderModel.price = positionModel.AskPrice1;
    } else {                                        // 卖，取买一价
        _tradeOrderModel.price = positionModel.BidPrice1;
    }
    _tradeOrderModel.num = positionModel.Position;
    if (CloseTodayPosition == positionOperation) {
        _tradeOrderModel.num = positionModel.TodayPosition;
    }
}

- (void)setupTradeOrderActionModel:(UPRspOrderModel *)orderModel {
    _tradeOrderActionModel = [[UPFuturesTradeOrderActionModel alloc] init];
    _tradeOrderActionModel.instrumentID = orderModel.InstrumentID;
    _tradeOrderActionModel.orderRef = orderModel.OrderRef;
    _tradeOrderActionModel.frontID = orderModel.FrontID;
    _tradeOrderActionModel.sessionID = orderModel.SessionID;
    _tradeOrderActionModel.exchangeID = orderModel.ExchangeID;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
        if (OrderConfirmAlertTag == alertView.tag) {
            if (_orderBlock) {
                _orderBlock(_tradeOrderModel);
            }
        }
        
        if (OrderActionConfirmAlertTag == alertView.tag) {
            if (_orderActionBlock) {
                _orderActionBlock(_tradeOrderActionModel);
            }
        }
    }
}

@end
