//
//  UPCTPSimTradeClient.h
//  FuturesTrade
//
//  Created by LiuLian on 17/8/23.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPTradeClient.h"

@interface UPCTPSimTradeClient : UPCTPTradeClient

#pragma mark - Init
+ (instancetype)sharedSimTradeClient;

@end
