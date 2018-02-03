//
//  UPFuturesTradeNumberUtil.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/28.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPFuturesTradeNumberUtil : NSObject

+ (NSString *)double2String:(double)value;
+ (NSString *)long2String:(long)value;
+ (NSInteger)numberOfDotInString:(NSString *)string;
+ (NSInteger)numberAfterDotInString:(NSString *)string;
+ (BOOL)containsOnlyNumberAndPoint:(NSString *)string;

@end
