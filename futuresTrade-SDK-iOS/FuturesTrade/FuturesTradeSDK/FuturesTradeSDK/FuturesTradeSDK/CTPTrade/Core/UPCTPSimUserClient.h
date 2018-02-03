//
//  UPCTPSimUserClient.h
//  FuturesTrade
//
//  Created by LiuLian on 17/8/21.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPUserClient.h"

@interface UPCTPSimUserClient : UPCTPUserClient

#pragma mark - Init
+ (instancetype)sharedSimUserClient;

@end
