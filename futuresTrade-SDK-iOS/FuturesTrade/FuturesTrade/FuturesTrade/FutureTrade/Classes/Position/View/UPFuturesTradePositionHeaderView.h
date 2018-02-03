//
//  UPFuturesTradePositionHeaderView.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/6.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeBaseView.h"

@class UPRspTradingAccountModel;

@interface UPFuturesTradePositionHeaderView : UPFuturesTradeBaseView

+ (UPFuturesTradePositionHeaderView *)futuresTradePositionHeaderView;
@property (nonatomic, strong) UPRspTradingAccountModel *tradingAccountModel;

@end
