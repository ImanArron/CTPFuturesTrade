//
//  UPFuturesTradeFundStatusCell.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/8.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPFuturesTradeBaseTableViewCell.h"

@class UPFuturesTradeFundStatusCellModel;

extern NSString * const UPFuturesTradeFundStatusCellReuseId;

@interface UPFuturesTradeFundStatusCell : UPFuturesTradeBaseTableViewCell

@property (nonatomic, strong) UPFuturesTradeFundStatusCellModel *viewModel;

@end

@interface UPFuturesTradeFundStatusCellModel : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;

@end
