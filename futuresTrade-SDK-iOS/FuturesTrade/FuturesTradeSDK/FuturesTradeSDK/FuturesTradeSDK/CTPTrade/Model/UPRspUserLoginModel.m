//
//  UPRspUserLoginModel.m
//  FuturesTrade
//
//  Created by LiuLian on 17/8/14.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPRspUserLoginModel.h"

@implementation UPRspUserLoginModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.TradingDay = [aDecoder decodeObjectForKey:@"TradingDay"];
        self.LoginTime = [aDecoder decodeObjectForKey:@"LoginTime"];
        self.BrokerID = [aDecoder decodeObjectForKey:@"BrokerID"];
        self.UserID = [aDecoder decodeObjectForKey:@"UserID"];
        self.SystemName = [aDecoder decodeObjectForKey:@"SystemName"];
        self.FrontID = [[aDecoder decodeObjectForKey:@"FrontID"] integerValue];
        self.SessionID = [[aDecoder decodeObjectForKey:@"SessionID"] integerValue];
        self.MaxOrderRef = [aDecoder decodeObjectForKey:@"MaxOrderRef"];
        self.SHFETime = [aDecoder decodeObjectForKey:@"SHFETime"];
        self.DCETime = [aDecoder decodeObjectForKey:@"DCETime"];
        self.CZCETime = [aDecoder decodeObjectForKey:@"CZCETime"];
        self.FFEXTime = [aDecoder decodeObjectForKey:@"FFEXTime"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.TradingDay forKey:@"TradingDay"];
    [aCoder encodeObject:self.LoginTime forKey:@"LoginTime"];
    [aCoder encodeObject:self.BrokerID forKey:@"BrokerID"];
    [aCoder encodeObject:self.UserID forKey:@"UserID"];
    [aCoder encodeObject:self.SystemName forKey:@"SystemName"];
    [aCoder encodeObject:@(self.FrontID) forKey:@"FrontID"];
    [aCoder encodeObject:@(self.SessionID) forKey:@"SessionID"];
    [aCoder encodeObject:self.MaxOrderRef forKey:@"MaxOrderRef"];
    [aCoder encodeObject:self.SHFETime forKey:@"SHFETime"];
    [aCoder encodeObject:self.DCETime forKey:@"DCETime"];
    [aCoder encodeObject:self.CZCETime forKey:@"CZCETime"];
    [aCoder encodeObject:self.FFEXTime forKey:@"FFEXTime"];
}

@end
