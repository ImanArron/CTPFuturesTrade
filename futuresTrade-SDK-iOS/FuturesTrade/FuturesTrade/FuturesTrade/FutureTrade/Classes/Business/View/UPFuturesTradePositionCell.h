//
//  UPFuturesTradePositionCell.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/30.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPFuturesTradeBaseTableViewCell.h"
#import <FuturesTradeSDK/UPCTPDefineHeader.h>

@class UPRspInvestorPositionModel;

extern NSString * const UPFuturesTradePositionCellReuseId;

@interface UPFuturesTradePositionCell : UPFuturesTradeBaseTableViewCell

@property (nonatomic, copy) PositionOperateBlock block;
@property (nonatomic, strong) UPRspInvestorPositionModel *rspInvestorPositionModel;
@property (nonatomic, assign) UPCTPTradeType tradeType;

- (void)setupOperationShowStatus:(BOOL)show;

@end
