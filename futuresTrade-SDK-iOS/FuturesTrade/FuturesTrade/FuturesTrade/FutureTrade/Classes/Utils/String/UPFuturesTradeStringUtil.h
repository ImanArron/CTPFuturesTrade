//
//  UPFuturesTradeStringUtil.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/31.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPFuturesTradeStringUtil : NSObject

+ (NSString *)posiDirection:(char)posiDirection;
+ (BOOL)isMultipleWarehouse:(char)posiDirection;
+ (NSString *)posiDetailDirection:(char)posiDetailDirection;
+ (NSString *)tradeDirection:(char)direction;
+ (NSString *)trimWhiteSpace:(const NSString *)str;
+ (NSString *)orderStatus:(char)orderStatus;
+ (NSString *)orderStatusForDisplay:(char)orderStatus;
+ (BOOL)canDeletedOrder:(char)orderStatus;
+ (NSString *)transferAvailabilityFlag:(char)availabilityFlag;
+ (NSString *)orderSubmitStatus:(char)orderSubmitStatus;
+ (NSString *)orderHint:(id)object;

@end
