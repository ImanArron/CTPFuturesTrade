//
//  UPFuturesTradeManager.h
//  FuturesTradeDemo
//
//  Created by UP-LiuL on 17/8/25.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FuturesTradeSDK/UPCTPTradeManager.h>

@interface UPFuturesTradeManager : NSObject

#pragma mark - Start Trade
+ (void)startFuturesTrade:(UIViewController *)viewController instrumentID:(NSString *)instrumentID tradeType:(UPCTPTradeType)tradeType;
+ (void)viewFuturesTradePosition:(UIViewController *)viewController tradeType:(UPCTPTradeType)tradeType;
+ (void)viewFuturesTradeInfo:(UIViewController *)viewController index:(NSInteger)index tradeType:(UPCTPTradeType)tradeType;

#pragma mark - User ID
+ (NSString *)userID:(UPCTPTradeType)tradeType;

#pragma mark - Environment
+ (BOOL)isTestEnvironment;
+ (void)setTestEnvironment:(BOOL)test;

@end
