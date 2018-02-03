//
//  UPCTPBaseClient.h
//  FuturesTrade
//
//  Created by UP-LiuL on 17/8/21.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPCTPModelHeader.h"
#import "UPCTPDefineHeader.h"
#import "UPCTPRequestCode.h"
#import "UPCTPSimRequestQueue.h"

@interface UPCTPBaseClient : NSObject

@property (nonatomic, assign, readonly) UPCTPTradeType tradeType;

@end
