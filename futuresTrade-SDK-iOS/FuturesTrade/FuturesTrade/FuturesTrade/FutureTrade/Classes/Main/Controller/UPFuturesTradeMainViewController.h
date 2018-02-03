//
//  UPFuturesTradeMainViewController.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/28.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeBaseBusinessViewController.h"

@interface UPFuturesTradeMainViewController : UPFuturesTradeBaseBusinessViewController

// 选中的tab
@property (nonatomic, assign) NSInteger selectedTab;
// instrumentID
@property (nonatomic, copy) NSString *instrumentID;

@end
