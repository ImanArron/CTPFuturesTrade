//
//  UPCTPSimUserClient.m
//  FuturesTrade
//
//  Created by LiuLian on 17/8/21.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPSimUserClient.h"

@implementation UPCTPSimUserClient

#pragma mark - Init
+ (instancetype)sharedSimUserClient {
    static UPCTPSimUserClient *client = nil;
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
