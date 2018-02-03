//
//  UPCTPRequestQueue.h
//  FuturesTrade
//
//  Created by LiuLian on 17/8/21.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPCTPModelHeader.h"
#import "UPCTPBlockModel.h"
#import "UPCTPRequestCode.h"
#import "UPCThostFtdcTraderService.h"

@class UPCTPResponseModel;

@interface UPCTPRequestQueue : NSObject

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *queue;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *blocks;
@property (nonatomic, strong) NSTimer *timeoutEventerTimer;
@property (atomic) int timeoutCount;

@property (nonatomic, strong) NSThread *enqueueThread;
@property (nonatomic, strong) NSThread *receiveResponseThread;
@property (nonatomic, strong) NSThread *timeoutEventThread;
@property (strong, nonatomic) dispatch_semaphore_t requestSemaphore;
@property (strong, nonatomic) dispatch_semaphore_t responseSemaphore;

#pragma mark - Init
+ (instancetype)sharedRequestQueue;
- (void)initTimer;
- (void)initThread;

#pragma mark - UPCThostFtdcTraderService
- (UPCThostFtdcTraderService *)cThostFtdcTraderService;

#pragma mark - User 
- (BOOL)isLogedin;
- (NSArray *)instruments;

#pragma mark - Enqueue
- (void)enqueue:(NSDictionary *)request;
- (void)insertRequestToQueue:(NSDictionary *)request;

#pragma mark - Receive Response
- (void)receiveResponse:(id)rspModel error:(NSError *)error nRequestID:(int)nRequestID;
- (void)handleResponse:(UPCTPResponseModel *)responseModel;

@end

@interface UPCTPResponseModel : NSObject

@property (nonatomic, strong) id rspModel;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) int nRequestID;

@end
