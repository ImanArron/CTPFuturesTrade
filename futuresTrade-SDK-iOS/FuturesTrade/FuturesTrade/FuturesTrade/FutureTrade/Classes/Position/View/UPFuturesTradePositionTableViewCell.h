//
//  UPFuturesTradePositionTableViewCell.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/6.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPFuturesTradeBaseTableViewCell.h"
#import <FuturesTradeSDK/UPCTPDefineHeader.h>

@class UPRspInvestorPositionModel;

extern NSString * const UPFuturesTradePositionTableViewCellReuseId;

@interface UPFuturesTradePositionTableViewCell : UPFuturesTradeBaseTableViewCell

@property (nonatomic, strong) UPRspInvestorPositionModel *rspInvestorPositionModel;
@property (nonatomic, copy) PositionOperateBlock block;
@property (nonatomic, assign) UPCTPTradeType tradeType;
- (void)setupOperationShowStatus:(BOOL)show;

@end
