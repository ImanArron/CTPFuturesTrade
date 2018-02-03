//
//  UPFuturesTradeEnvironmentUtil.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/18.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPFuturesTradeEnvironmentUtil : NSObject

+ (BOOL)isTestEnvironment;
+ (void)setTestEnvironment:(BOOL)test;

@end
