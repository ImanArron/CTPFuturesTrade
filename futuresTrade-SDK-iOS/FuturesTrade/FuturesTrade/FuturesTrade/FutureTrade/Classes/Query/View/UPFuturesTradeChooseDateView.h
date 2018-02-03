//
//  UPFuturesTradeChooseDateView.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/8.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPFuturesTradeBaseView.h"

typedef void(^UPFuturesTradeChooseDateBlock)(NSInteger dateType);

@interface UPFuturesTradeChooseDateView : UPFuturesTradeBaseView

@property (nonatomic, copy) UPFuturesTradeChooseDateBlock block;
+ (UPFuturesTradeChooseDateView *)futuresTradeChooseDateView;
- (void)setupStartDate:(NSString *)date;
- (void)setupEndDate:(NSString *)date;

@end
