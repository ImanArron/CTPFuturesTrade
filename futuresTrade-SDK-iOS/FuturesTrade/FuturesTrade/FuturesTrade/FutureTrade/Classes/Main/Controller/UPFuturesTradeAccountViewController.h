//
//  UPFuturesTradeAccountViewController.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/28.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeBaseBusinessViewController.h"

@class UPRspUserLoginModel;

@interface UPFuturesTradeAccountViewController : UPFuturesTradeBaseBusinessViewController

@property (nonatomic, strong) UPRspUserLoginModel *rspUserLoginModel;
@property (nonatomic, assign) BOOL needHideBackBtn;

@end
