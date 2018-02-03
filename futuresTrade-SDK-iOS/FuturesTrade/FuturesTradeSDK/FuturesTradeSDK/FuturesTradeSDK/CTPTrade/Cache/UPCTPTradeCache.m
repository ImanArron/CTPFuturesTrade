//
//  UPCTPTradeCache.m
//  FuturesTrade
//
//  Created by LiuLian on 17/8/23.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPTradeCache.h"
#import "UPCTPModelHeader.h"
#import "UPCTPTradeManager.h"

@implementation UPCTPTradeCache

#pragma mark - Document Path
+ (NSString *)documentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

#pragma mark - Cache UPRspUserLoginModel
static NSString * const UPRspUserLoginModelStorePath = @"/UPRspUserLoginModelStorePath";
static NSString * const UPRspSimUserLoginModelStorePath = @"/UPRspSimUserLoginModelStorePath";

+ (NSString *)rspUserLoginModelStorePath:(UPCTPTradeType)tradeType {
    NSString *path = [[self documentPath] stringByAppendingString:UPCTPRealTrade == tradeType ? UPRspUserLoginModelStorePath : UPRspSimUserLoginModelStorePath];
    return path;
}

+ (BOOL)cacheRspUserLoginModel:(UPRspUserLoginModel *)rspUserLoginModel tradeType:(UPCTPTradeType)tradeType {
    NSString *path = [self rspUserLoginModelStorePath:tradeType];
    BOOL successed = [NSKeyedArchiver archiveRootObject:rspUserLoginModel toFile:path];
    return successed;
}

+ (UPRspUserLoginModel *)cachedRspUserLoginModel:(UPCTPTradeType)tradeType {
    NSString *path = [self rspUserLoginModelStorePath:tradeType];
    UPRspUserLoginModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return model;
}

#pragma mark - Instruments
+ (NSArray *)instruments:(UPCTPTradeType)tradeType {
    UPCTPTradeManager *manager = [[UPCTPTradeManager alloc] initWithTradeType:tradeType];
    return [manager instruments];
}

@end
