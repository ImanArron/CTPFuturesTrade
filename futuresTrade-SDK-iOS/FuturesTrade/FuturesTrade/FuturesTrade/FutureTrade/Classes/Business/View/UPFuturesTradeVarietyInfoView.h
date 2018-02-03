//
//  UPFuturesTradeVarietyInfoView.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/28.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPFuturesTradeBaseView.h"

@class UPFuturesTradeVarietyInfoViewModel;

typedef void(^UPFuturesTradeVarietyInfoBlock)(void);

@interface UPFuturesTradeVarietyInfoView : UPFuturesTradeBaseView

@property (nonatomic, copy) UPFuturesTradeVarietyInfoBlock searchBlock;
@property (nonatomic, strong) UPFuturesTradeVarietyInfoViewModel *viewModel;

+ (UPFuturesTradeVarietyInfoView *)futuresTradeVarietyInfoView;

@end

@interface UPFuturesTradeVarietyInfoViewModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double riseAndFall;
@property (nonatomic, assign) double amplitude;
@property (nonatomic, assign) double buyPrice;
@property (nonatomic, assign) long buyNum;
@property (nonatomic, assign) double sellPrice;
@property (nonatomic, assign) long sellNum;

@end
