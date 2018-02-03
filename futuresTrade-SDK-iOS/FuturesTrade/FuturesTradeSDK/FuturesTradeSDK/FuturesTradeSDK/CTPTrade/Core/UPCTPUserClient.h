//
//  UPCTPUserClient.h
//  FuturesTrade
//
//  Created by LiuLian on 17/8/21.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPBaseClient.h"

@interface UPCTPUserClient : UPCTPBaseClient

#pragma mark - Init
+ (instancetype)sharedUserClient;

#pragma mark - Login
- (void)reqUserLogin:(NSString *)userID password:(NSString *)password brokerID:(NSString *)brokerID callback:(UPCallback)callback;
- (BOOL)isLogedin;
- (UPRspUserLoginModel *)userInfo;
- (NSArray *)instruments;

#pragma mark - Logout
- (void)reqUserLogout:(NSString *)userID brokerID:(NSString *)brokerID callback:(UPCallback)callback;

@end
