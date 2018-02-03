//
//  UPCTPRequestCode.h
//  FuturesTrade
//
//  Created by LiuLian on 17/8/21.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPCTPRequestCode : NSObject

extern const NSInteger UPCTPRequestCode_Login;
extern const NSInteger UPCTPRequestCode_Logout;
extern const NSInteger UPCTPRequestCode_OrderInsert;
extern const NSInteger UPCTPRequestCode_TradingAccount;
extern const NSInteger UPCTPRequestCode_InvestorPosition;
extern const NSInteger UPCTPRequestCode_Trade;
extern const NSInteger UPCTPRequestCode_DepthMarket;
extern const NSInteger UPCTPRequestCode_InvestorPositionDetail;
extern const NSInteger UPCTPRequestCode_Order;
extern const NSInteger UPCTPRequestCode_OrderAction;
extern const NSInteger UPCTPRequestCode_TransferBank;
extern const NSInteger UPCTPRequestCode_TransferSerial;
extern const NSInteger UPCTPRequestCode_Accountregister;
extern const NSInteger UPCTPRequestCode_BetweenBankAndFuture;
extern const NSInteger UPCTPRequestCode_BankAccountMoney;
extern const NSInteger UPCTPRequestCode_InstrumentMarginRate;
extern const NSInteger UPCTPRequestCode_SubscribeMarketData;
extern const NSInteger UPCTPRequestCode_UnSubscribeMarketData;

@end
