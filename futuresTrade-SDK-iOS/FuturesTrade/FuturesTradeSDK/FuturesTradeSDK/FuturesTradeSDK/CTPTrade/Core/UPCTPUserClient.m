//
//  UPCTPUserClient.m
//  FuturesTrade
//
//  Created by LiuLian on 17/8/21.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPUserClient.h"
#import "UPCTPTradeCache.h"

@interface UPCTPUserClient ()

@property (nonatomic, strong) UPCTPRequestQueue *ctpRequestQueue;

@end

@implementation UPCTPUserClient

#pragma mark - Init
+ (instancetype)sharedUserClient {
    static UPCTPUserClient *client = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        client = [[self alloc] init];
    });
    return client;
}

#pragma mark - Getter

- (UPCTPTradeType)tradeType {
    return UPCTPRealTrade;
}

- (UPCTPRequestQueue *)ctpRequestQueue {
    if (UPCTPRealTrade == self.tradeType) {
        return [UPCTPRequestQueue sharedRequestQueue];
    } else {
        return [UPCTPSimRequestQueue sharedSimRequestQueue];
    }
}

#pragma mark - Login
- (void)reqUserLogin:(NSString *)userID password:(NSString *)password brokerID:(NSString *)brokerID callback:(UPCallback)callback {
    NSAssert(userID, @"用户ID为空");
    NSAssert(password, @"用户密码为空");
    NSAssert(callback, @"登录请求的callback为空");
    
    if (callback) {
        NSArray *params = @[
                            userID?userID:@"",
                            password?password:@"",
                            brokerID?brokerID:@"",
                            callback
                            ];
        [self.ctpRequestQueue enqueue:@{@(UPCTPRequestCode_Login):params}];
    }
}

- (BOOL)isLogedin {
    return [self.ctpRequestQueue isLogedin];
}

- (UPRspUserLoginModel *)userInfo {
    return [UPCTPTradeCache cachedRspUserLoginModel:self.tradeType];
}

- (NSArray *)instruments {
    return [self.ctpRequestQueue instruments];
}

#pragma mark - Logout
- (void)reqUserLogout:(NSString *)userID brokerID:(NSString *)brokerID callback:(UPCallback)callback {
    NSAssert(userID, @"用户ID为空");
    NSAssert(callback, @"登出请求的callback为空");
    
    if (callback) {
        NSArray *params = @[
                            userID?userID:@"",
                            brokerID?brokerID:@"",
                            callback
                            ];
        [self.ctpRequestQueue enqueue:@{@(UPCTPRequestCode_Logout):params}];
    }
}

@end
