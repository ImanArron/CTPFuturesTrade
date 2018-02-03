//
//  UPFuturesTradeManager.m
//  FuturesTradeDemo
//
//  Created by LiuLian on 17/8/25.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeManager.h"
#import "UPFuturesTradeLoginViewController.h"
#import "UPFuturesTradeAccountViewController.h"
#import "UPFuturesTradeMainViewController.h"

@implementation UPFuturesTradeManager

#pragma mark - Start Trade
+ (void)startFuturesTrade:(UIViewController *)viewController instrumentID:(NSString *)instrumentID tradeType:(UPCTPTradeType)tradeType {
    if (viewController.navigationController) {
        UPCTPTradeManager *ctpTradeManager = [[UPCTPTradeManager alloc] initWithTradeType:tradeType];
        [ctpTradeManager setTestEnvironment:UPCTPSimulateTrade == tradeType];
        if ([ctpTradeManager isLogedin]) {
            if (instrumentID.length > 0) {
                UPFuturesTradeMainViewController *tradeMainVC = [[UPFuturesTradeMainViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeMainViewController" bundle:nil tradeType:tradeType];
                tradeMainVC.selectedTab = 0;
                tradeMainVC.hidesBottomBarWhenPushed = YES;
                tradeMainVC.instrumentID = [instrumentID copy];
                [viewController.navigationController pushViewController:tradeMainVC animated:YES];
            } else {
                UPFuturesTradeAccountViewController *futuresTradeAccountVC = [[UPFuturesTradeAccountViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeAccountViewController" bundle:nil tradeType:tradeType];
                futuresTradeAccountVC.hidesBottomBarWhenPushed = NO;
                futuresTradeAccountVC.needHideBackBtn = instrumentID.length > 0 ? NO : YES;
                [viewController.navigationController pushViewController:futuresTradeAccountVC animated:NO];
            }
        } else {
            UPFuturesTradeLoginViewController *futuresTradeLoginVC = [[UPFuturesTradeLoginViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeLoginViewController" bundle:nil tradeType:tradeType];
            futuresTradeLoginVC.hidesBottomBarWhenPushed = instrumentID.length > 0 ? YES : NO;
            futuresTradeLoginVC.needHideBackBtn = instrumentID.length > 0 ? NO : YES;
            [viewController.navigationController pushViewController:futuresTradeLoginVC animated:instrumentID.length > 0 ? YES : NO];
        }
    }
}

+ (void)viewFuturesTradePosition:(UIViewController *)viewController tradeType:(UPCTPTradeType)tradeType {
    [self viewFuturesTradeInfo:viewController index:3 tradeType:tradeType];
}

+ (void)viewFuturesTradeInfo:(UIViewController *)viewController index:(NSInteger)index tradeType:(UPCTPTradeType)tradeType {
    UPCTPTradeManager *ctpTradeManager = [[UPCTPTradeManager alloc] initWithTradeType:tradeType];
    [ctpTradeManager setTestEnvironment:UPCTPSimulateTrade == tradeType];
    if ([ctpTradeManager isLogedin]) {
        if (index >= 0 && index <= 3) {
            UPFuturesTradeMainViewController *tradeMainVC = [[UPFuturesTradeMainViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeMainViewController" bundle:nil tradeType:tradeType];
            tradeMainVC.selectedTab = index;
            tradeMainVC.hidesBottomBarWhenPushed = YES;
            [viewController.navigationController pushViewController:tradeMainVC animated:YES];
        }
    } else {
        UPFuturesTradeLoginViewController *futuresTradeLoginVC = [[UPFuturesTradeLoginViewController alloc] initWithNibName:@"FuturesTradeBundle.bundle/UPFuturesTradeLoginViewController" bundle:nil tradeType:tradeType];
        futuresTradeLoginVC.hidesBottomBarWhenPushed = YES;
        futuresTradeLoginVC.needHideBackBtn = NO;
        futuresTradeLoginVC.infoIndex = @(index);
        [viewController.navigationController pushViewController:futuresTradeLoginVC animated:YES];
    }
}

#pragma mark - User ID
+ (NSString *)userID:(UPCTPTradeType)tradeType {
    UPCTPTradeManager *ctpTradeManager = [[UPCTPTradeManager alloc] initWithTradeType:tradeType];
    if ([ctpTradeManager isLogedin]) {
        UPRspUserLoginModel *userLoginModel = [ctpTradeManager userInfo];
        return userLoginModel.UserID;
    }
    
    return nil;
}

#pragma mark - Environment
+ (BOOL)isTestEnvironment {
    UPCTPTradeManager *ctpTradeManager = [[UPCTPTradeManager alloc] initWithTradeType:UPCTPRealTrade];
    return [ctpTradeManager isTestEnvironment];
}

+ (void)setTestEnvironment:(BOOL)test {
    UPCTPTradeManager *ctpTradeManager = [[UPCTPTradeManager alloc] initWithTradeType:UPCTPRealTrade];
    [ctpTradeManager setTestEnvironment:test];
}

@end
