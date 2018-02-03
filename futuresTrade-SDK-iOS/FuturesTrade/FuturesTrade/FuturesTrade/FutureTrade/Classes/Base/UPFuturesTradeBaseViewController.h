//
//  UPCTPTradeBaseViewController.h
//  FuturesTradeDemo
//
//  Created by LiuLian on 17/8/25.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPHUD.h"
#import "UPFuturesTradeMacros.h"
#import "UPFuturesTradeNumberUtil.h"
#import "UPFuturesTradeColorUtil.h"
#import "UPFuturesTradeRefresh.h"

extern NSString * const BROKER_ID;

@interface UPFuturesTradeBaseViewController : UIViewController

#pragma mark - setNavBarTranslucent
- (void)setNavBarTranslucent:(BOOL)isTranslucent;

#pragma mark - Hide Back Button
- (void)hideBackBtn;

@end
