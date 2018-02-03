//
//  NSBundle+UPFuturesTradeRefresh.h
//  UPFuturesTradeRefreshExample
//
//  Created by UPFuturesTrade Lee on 16/6/13.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBundle (UPFuturesTradeRefresh)
+ (instancetype)UPFuturesTrade_refreshBundle;
+ (UIImage *)UPFuturesTrade_arrowImage;
+ (NSString *)UPFuturesTrade_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)UPFuturesTrade_localizedStringForKey:(NSString *)key;
@end
