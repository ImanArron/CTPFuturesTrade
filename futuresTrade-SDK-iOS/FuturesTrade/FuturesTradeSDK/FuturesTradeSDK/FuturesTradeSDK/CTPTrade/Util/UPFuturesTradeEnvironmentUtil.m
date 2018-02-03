//
//  UPFuturesTradeEnvironmentUtil.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/18.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeEnvironmentUtil.h"

@implementation UPFuturesTradeEnvironmentUtil

static NSString * const UPFUTURESTRADE_ENVIRONMENT_KEY = @"UPFUTURESTRADE_ENVIRONMENT_KEY";

+ (BOOL)isTestEnvironment {
    BOOL isTest = [[NSUserDefaults standardUserDefaults] boolForKey:UPFUTURESTRADE_ENVIRONMENT_KEY];
    return isTest;
}

+ (void)setTestEnvironment:(BOOL)test {
    [[NSUserDefaults standardUserDefaults] setBool:test forKey:UPFUTURESTRADE_ENVIRONMENT_KEY];
}

@end
