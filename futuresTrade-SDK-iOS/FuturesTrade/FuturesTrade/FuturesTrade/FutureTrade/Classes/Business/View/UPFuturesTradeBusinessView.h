//
//  UPFuturesTradeBusinessView.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/29.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeBaseView.h"
#import "UPFuturesTradeOrderModel.h"

@class UPRspDepthMarketDataModel;
@class UPRspInstrumentModel;
@class UPFuturesTradeOrderModel;
@class UPRspTradingAccountModel;
@class UPFuturesTradeBusinessModel;
@class UPRspInstrumentMarginRateModel;

typedef void(^UPFuturesTradeBusinessBlock)(UPFuturesTradeOrderModel *orderModel);

@interface UPFuturesTradeBusinessView : UPFuturesTradeBaseView

+ (UPFuturesTradeBusinessView *)futuresTradeBusinessView;

@property (nonatomic, copy) UPFuturesTradeBusinessBlock orderBlock;
@property (nonatomic, strong) UPRspDepthMarketDataModel *depthMarketDataModel;
@property (nonatomic, strong) UPRspInstrumentModel *instrumentModel;
@property (nonatomic, strong) UPRspTradingAccountModel *rspTradingAccount;
@property (nonatomic, strong) UPFuturesTradeBusinessModel *businessModel;
@property (nonatomic, strong) UPRspInstrumentMarginRateModel *instrumentMarginRateModel;

#pragma mark - Show Or Hide Keyboard
- (void)showKeyboard;
- (void)hideKeyboard;

@end

@interface UPFuturesTradeBusinessModel : NSObject

@property (nonatomic, assign) NSInteger selectedSegment;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) int canBuyNum;
@property (nonatomic, assign) int canSellNum;
@property (nonatomic, assign) int canBuyTodayNum;
@property (nonatomic, assign) int canSellTodayNum;

@end
