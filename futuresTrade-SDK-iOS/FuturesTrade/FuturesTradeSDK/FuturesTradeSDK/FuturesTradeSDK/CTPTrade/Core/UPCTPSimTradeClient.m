//
//  UPCTPSimTradeClient.m
//  FuturesTrade
//
//  Created by LiuLian on 17/8/23.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPSimTradeClient.h"

@implementation UPCTPSimTradeClient

#pragma mark - Init
+ (instancetype)sharedSimTradeClient {
    static UPCTPSimTradeClient *client = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        client = [[self alloc] init];
    });
    return client;
}

#pragma mark - Getter

- (UPCTPTradeType)tradeType {
    return UPCTPSimulateTrade;
}

@end
