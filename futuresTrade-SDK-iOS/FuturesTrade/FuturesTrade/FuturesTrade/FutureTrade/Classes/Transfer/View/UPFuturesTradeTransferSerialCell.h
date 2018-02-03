//
//  UPFuturesTradeTransferSerialCell.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/9.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPFuturesTradeBaseTableViewCell.h"

@class UPRspTransferSerialModel;

extern NSString * const UPFuturesTradeTransferSerialCellReuseId;

@interface UPFuturesTradeTransferSerialCell : UPFuturesTradeBaseTableViewCell

@property (nonatomic, strong) UPRspTransferSerialModel *serialModel;

@end
