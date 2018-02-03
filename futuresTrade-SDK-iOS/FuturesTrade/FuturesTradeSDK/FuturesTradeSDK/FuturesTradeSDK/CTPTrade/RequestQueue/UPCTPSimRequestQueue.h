//
//  UPCTPSimRequestQueue.h
//  FuturesTrade
//
//  Created by LiuLian on 17/8/22.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPRequestQueue.h"

@interface UPCTPSimRequestQueue : UPCTPRequestQueue

#pragma mark - Init
+ (instancetype)sharedSimRequestQueue;

@end
