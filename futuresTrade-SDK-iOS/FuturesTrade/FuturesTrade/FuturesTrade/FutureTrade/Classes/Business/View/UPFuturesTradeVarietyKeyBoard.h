//
//  UPFuturesTradeVarietyKeyBoard.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/4.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPRspInstrumentModel;

typedef void(^UPFuturesTradeVarietyKeyBoardBlock)(UPRspInstrumentModel *instrumentModel);

@interface UPFuturesTradeVarietyKeyBoard : UIView

@property (nonatomic, copy) UPFuturesTradeVarietyKeyBoardBlock block;
+ (UPFuturesTradeVarietyKeyBoard *)futuresTradeVarietyKeyBoardWithInstruments:(NSArray *)instruments;
// 显示键盘
- (void)showKeyboard;

@end
