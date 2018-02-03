//
//  GoldTradeKeyBoard.h
//  BoGuTongJin
//
//  Created by LiuLian on 16/4/12.
//  Copyright © 2016年 upchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoldTradeKeyBoardDelegate;
@class GoldTradeKeyBoardModel;

extern NSString * const NEWEST_PRICE;
extern NSString * const QUEUE_PRICE;
extern NSString * const COMPITOR_PRICE;
extern NSString * const MARKET_PRICE;
extern NSString * const OVERMARKET_PRICE;

@interface GoldTradeKeyBoard : UIView

/// 1：价格输入键盘；2、数量输入键盘
@property (nonatomic, assign, setter=setKeyBoardType:) NSInteger keyBoardType;
/// 最大可开仓手数
@property (nonatomic, strong, setter=setModel:) GoldTradeKeyBoardModel *model;

// 键盘点击回调
@property (nonatomic, weak) id<GoldTradeKeyBoardDelegate> keyBoardDelegate;

#pragma mark - showKeyboard
/// 显示键盘，调用此方法前需要先设置keyBoardType和positionNum
- (void)showKeyboard;
// 隐藏键盘
- (void)hideKeyboard;
// 销毁键盘
- (void)destroyKeyboard;
// 键盘是否在显示
- (BOOL)isShowing;

@end

@protocol GoldTradeKeyBoardDelegate <NSObject>

@optional
/// 0~9，代表点击了数字0~9，10为"."，11为"-"，12为"+"
- (void)pressNumber:(NSInteger)num;
// 0为收起键盘，1为删除
- (void)pressImage:(NSInteger)num;
// 0为对手价、1为排队价、2为最新价
- (void)pressText:(NSInteger)num;
// 长按删除按钮
- (void)longPressDeleteButton;
// 键盘即将隐藏
- (void)keyboardWillHide:(GoldTradeKeyBoard *)keyboard;
// 键盘已经隐藏
- (void)keyboardDidHide:(GoldTradeKeyBoard *)keyboard;
// 键盘即将显示
- (void)keyboardWillShow:(GoldTradeKeyBoard *)keyboard;
// 键盘已经显示
- (void)keyboardDidShow:(GoldTradeKeyBoard *)keyboard;

@end

@interface GoldTradeKeyBoardModel : NSObject

@property (nonatomic, copy) NSString *mixChange;
@property (nonatomic, copy) NSString *riseLimit;
@property (nonatomic, copy) NSString *downLimit;

@end
