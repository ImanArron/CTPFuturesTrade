//
//  UPCTPSimRequestQueue.m
//  FuturesTrade
//
//  Created by LiuLian on 17/8/22.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPSimRequestQueue.h"

@interface UPCTPSimRequestQueue ()

@end

@implementation UPCTPSimRequestQueue

#pragma mark - Init
+ (instancetype)sharedSimRequestQueue {
    static UPCTPSimRequestQueue *requestQueue = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        requestQueue = [[UPCTPSimRequestQueue alloc] init];
        [requestQueue initTimer];
        [requestQueue initThread];
    });
    return requestQueue;
}

#pragma mark - UPCThostFtdcTraderService

static UPCThostFtdcTraderService *cSimThostFtdcTraderService;
- (UPCThostFtdcTraderService *)cThostFtdcTraderService {
    if (!cSimThostFtdcTraderService) {
        cSimThostFtdcTraderService = [[UPCThostFtdcTraderService alloc] initWithTradeType:UPCTPSimulateTrade];
    }
    return cSimThostFtdcTraderService;
}

@end
