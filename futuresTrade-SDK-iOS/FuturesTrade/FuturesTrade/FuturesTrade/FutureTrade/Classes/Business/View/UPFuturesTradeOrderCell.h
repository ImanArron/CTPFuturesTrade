//
//  UPFuturesTradeOrderCell.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/5.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPFuturesTradeBaseTableViewCell.h"
#import <FuturesTradeSDK/UPCTPDefineHeader.h>

extern NSString * const UPFuturesTradeOrderCellReuseId;

@interface UPFuturesTradeOrderCell : UPFuturesTradeBaseTableViewCell

@property (nonatomic, copy) OrderOperateBlock block;
@property (nonatomic, strong) id viewModel;
@property (nonatomic, assign) UPCTPTradeType tradeType;

- (void)setupOperationShowStatus:(BOOL)show;

@end
