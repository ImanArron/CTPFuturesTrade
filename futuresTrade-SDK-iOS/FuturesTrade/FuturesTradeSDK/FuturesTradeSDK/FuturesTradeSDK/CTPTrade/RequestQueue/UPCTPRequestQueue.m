//
//  UPCTPRequestQueue.m
//  FuturesTrade
//
//  Created by LiuLian on 17/8/21.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPRequestQueue.h"
#import "UPCTPRequestCode.h"
#import "UPErrorUtil.h"
#import "UPCTPTradeErrorConstants.h"

//static int const MAX_TIMEOUT_COUNT = 20;

@interface UPCTPRequestQueue ()


@end

@implementation UPCTPRequestQueue

static dispatch_time_t timeout = 2.0 * NSEC_PER_SEC;

#pragma mark - dealloc
- (void)dealloc {
    if (_timeoutEventerTimer) {
        [_timeoutEventerTimer invalidate];
        _timeoutEventerTimer = nil;
    }
}

#pragma mark - Init
+ (instancetype)sharedRequestQueue {
    static UPCTPRequestQueue *requestQueue = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        requestQueue = [[UPCTPRequestQueue alloc] init];
        [requestQueue initTimer];
        [requestQueue initThread];
    });
    return requestQueue;
}

- (void)initTimer {
    _timeoutEventerTimer = [NSTimer timerWithTimeInterval:5.f target:self selector:@selector(handleTimeoutEvent) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timeoutEventerTimer forMode:NSRunLoopCommonModes];
    
    /*dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), timeout, 0);
    dispatch_source_set_event_handler(_timer, ^{
        [self handleTimeoutEvent];
        // 关闭定时器
        if (!self.blocks) {
            dispatch_source_cancel(_timer);
        }
    });
    // 开启定时器
    dispatch_resume(_timer);*/
}

- (void)initThread {
    _enqueueThread = [[NSThread alloc] initWithTarget:self selector:@selector(singleThread) object:nil];
    [_enqueueThread start];
    
    _receiveResponseThread = [[NSThread alloc] initWithTarget:self selector:@selector(singleThread) object:nil];
    [_receiveResponseThread start];
    
    _timeoutEventThread = [[NSThread alloc] initWithTarget:self selector:@selector(singleThread) object:nil];
    [_timeoutEventThread start];
}

- (void)singleThread {
    @autoreleasepool {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        CFRunLoopRun();
    }
}

#pragma mark - UPCThostFtdcTraderService

static UPCThostFtdcTraderService *cThostFtdcTraderService;
- (UPCThostFtdcTraderService *)cThostFtdcTraderService {
    if (!cThostFtdcTraderService) {
        cThostFtdcTraderService = [[UPCThostFtdcTraderService alloc] initWithTradeType:UPCTPRealTrade];
    }
    return cThostFtdcTraderService;
}

#pragma mark - User

- (BOOL)isLogedin {
    return [self.cThostFtdcTraderService isLogedin];
}

- (NSArray *)instruments {
    return [self.cThostFtdcTraderService instruments];
}

- (NSMutableArray *)queue {
    if (!_queue) {
        _queue = [NSMutableArray array];
    }
    return _queue;
}

- (NSMutableArray<NSDictionary *> *)blocks {
    if (!_blocks) {
        _blocks = [NSMutableArray array];
    }
    return _blocks;
}

- (dispatch_semaphore_t)requestSemaphore {
    if (!_requestSemaphore) {
        _requestSemaphore = dispatch_semaphore_create(1);
    }
    return _requestSemaphore;
}

- (dispatch_semaphore_t)responseSemaphore {
    if (!_responseSemaphore) {
        _responseSemaphore = dispatch_semaphore_create(1);
    }
    return _responseSemaphore;
}

#pragma mark - Queue
- (void)enqueue:(NSDictionary *)request {
    NSLog(@"Enqueue Thread: %@, MainThread: %@", _enqueueThread, [NSThread mainThread]);
//    [self insertRequestToQueue:request];
    [self performSelector:@selector(insertRequestToQueue:) onThread:self.enqueueThread withObject:request waitUntilDone:NO];
}

- (void)insertRequestToQueue:(NSDictionary *)request {
    NSLog(@"Enqueue CurrentThread: %@, isMainThread: %d", [NSThread currentThread], [NSThread isMainThread]);
    dispatch_semaphore_wait(self.requestSemaphore, timeout);
    if (request) {
        [self.queue addObject:request];
    }
    dispatch_semaphore_signal(self.requestSemaphore);
    [self dequeue];
}

- (void)sleep {
    //[NSThread sleepForTimeInterval:1.f];
}

- (void)dequeue {
    NSLog(@"Dequeue self.queue.count: %ld", (long)self.queue.count);
    dispatch_semaphore_wait(self.requestSemaphore, timeout);
    while (self.queue.count > 0) {
        NSDictionary *request = nil;
        if (self.queue.count > 0) {
            request = [self.queue[0] copy];
            [self.queue removeObjectAtIndex:0];
        }
        [self sendRequest:request];
        [self sleep];
    }
    dispatch_semaphore_signal(self.requestSemaphore);
}

#pragma mark - Send Request

static int requestID = 10;
- (int)requestID {
    if (requestID > 65536) {
        requestID = 10;
    }
    requestID++;
    return requestID;
}

- (int)requestIDWithParams:(NSArray *)params requestCode:(NSInteger)requestCode {
    int tmpRequestID = self.requestID;
    if (UPCTPRequestCode_SubscribeMarketData == requestCode) {
        tmpRequestID = SUBSCRIBE_MARKETDATA_REQUESTID;
    }
    UPCTPBlockModel *blockModel = [[UPCTPBlockModel alloc] init];
    blockModel.callback = [params lastObject];
    blockModel.timeInterval = time(NULL);
    blockModel.requestCode = requestCode;
    [self.blocks addObject:[@{@(tmpRequestID):blockModel} copy]];
    return tmpRequestID;
}

- (void)sendRequest:(NSDictionary *)request {
    if (request.count > 0) {
        NSInteger requestCode = [request.allKeys[0] integerValue];
        NSArray *params = request[request.allKeys[0]];
        if (UPCTPRequestCode_Login == requestCode)
        {
            [self sendLoginRequest:params];
        }
        else if (UPCTPRequestCode_Logout == requestCode)
        {
            [self sendLogoutRequest:params];
        }
        else if (UPCTPRequestCode_OrderInsert == requestCode)
        {
            [self sendOrderInsertRequest:params];
        }
        else if (UPCTPRequestCode_TradingAccount == requestCode)
        {
            [self sendTradingAccountRequest:params];
        }
        else if (UPCTPRequestCode_InvestorPosition == requestCode)
        {
            [self sendInvestorPositionRequest:params];
        }
        else if (UPCTPRequestCode_Trade == requestCode)
        {
            [self sendTradeRequest:params];
        }
        else if (UPCTPRequestCode_DepthMarket == requestCode)
        {
            [self sendDepthMarketRequest:params];
        }
        else if (UPCTPRequestCode_InstrumentMarginRate == requestCode)
        {
            [self sendInstrumentMarginRateRequest:params];
        }
        else if (UPCTPRequestCode_InvestorPositionDetail == requestCode)
        {
            [self sendInvestorPositionDetailRequest:params];
        }
        else if (UPCTPRequestCode_Order == requestCode)
        {
            [self sendOrderRequest:params];
        }
        else if (UPCTPRequestCode_OrderAction == requestCode)
        {
            [self sendOrderActionRequest:params];
        }
        else if (UPCTPRequestCode_TransferBank == requestCode)
        {
            [self sendTransferBankRequest:params];
        }
        else if (UPCTPRequestCode_TransferSerial == requestCode)
        {
            [self sendTransferSerialRequest:params];
        }
        else if (UPCTPRequestCode_Accountregister == requestCode)
        {
            [self sendAccountregisterRequest:params];
        }
        else if (UPCTPRequestCode_BetweenBankAndFuture == requestCode)
        {
            [self sendBetweenBankAndFutureRequest:params];
        }
        else if (UPCTPRequestCode_BankAccountMoney == requestCode)
        {
            [self sendBankAccountMoneyRequest:params];
        }
        else if (UPCTPRequestCode_SubscribeMarketData == requestCode)
        {
            [self sendSubScribeMarketDataRequest:params];
        }
        else if (UPCTPRequestCode_UnSubscribeMarketData == requestCode)
        {
            [self sendUnSubScribeMarketDataRequest:params];
        }
    }
}

- (void)sendLoginRequest:(NSArray *)params {
    NSLog(@"SendLoginRequest: %@", params);
    [self.cThostFtdcTraderService reqUserLogin:params[0] password:params[1] brokerID:params[2] nRequestID:[self requestIDWithParams:params requestCode:UPCTPRequestCode_Login]];
}

- (void)sendLogoutRequest:(NSArray *)params {
    NSLog(@"SendLogoutRequest: %@", params);
    [self.cThostFtdcTraderService reqUserLogout:params[0] brokerID:params[1] nRequestID:[self requestIDWithParams:params requestCode:UPCTPRequestCode_Logout]];
}

- (void)sendOrderInsertRequest:(NSArray *)params {
    NSLog(@"SendOrderInsertRequest: %@", params);
    [self.cThostFtdcTraderService reqOrderInsert:params[0] instrumentID:params[1] price:[params[2] doubleValue] volumeTotalOriginal:[params[3] intValue] direction:[params[4] intValue] combOffsetFlag:[params[5] intValue] brokerID:params[6] nRequestID:[self requestIDWithParams:params requestCode:UPCTPRequestCode_OrderInsert]];
}

- (void)sendOrderActionRequest:(NSArray *)params {
    NSLog(@"SendOrderActionRequest: %@", params);
    [self.cThostFtdcTraderService reqOrderAction:params[0] instrumentID:params[1] brokerID:params[2] orderRef:params[3] frontID:[params[4] intValue] sessionID:[params[5] intValue] exchangeID:params[6] nRequestID:[self requestIDWithParams:params requestCode:UPCTPRequestCode_OrderAction]];
}

- (void)sendTradingAccountRequest:(NSArray *)params {
    NSLog(@"SendTradingAccountRequest: %@", params);
    [self.cThostFtdcTraderService reqQueryTradingAccount:params[0] brokerID:params[1] nRequestID:[self requestIDWithParams:params requestCode:UPCTPRequestCode_TradingAccount]];
}

- (void)sendInvestorPositionRequest:(NSArray *)params {
    NSLog(@"SendInvestorPositionRequest: %@", params);
    [self.cThostFtdcTraderService reqQueryInvestorPosition:params[0] brokerID:params[1] instrumentID:params[2] nRequestID:[self requestIDWithParams:params requestCode:UPCTPRequestCode_InvestorPosition]];
}

- (void)sendTradeRequest:(NSArray *)params {
    NSLog(@"SendTradeRequest: %@", params);
    [self.cThostFtdcTraderService reqQueryTrade:params[0] brokerID:params[1] instrumentID:params[2] timeStart:params[3] timeEnd:params[4] nRequestID:[self requestIDWithParams:params requestCode:UPCTPRequestCode_Trade]];
}

- (void)sendDepthMarketRequest:(NSArray *)params {
    NSLog(@"SendDepthMarketRequest: %@", params);
    [self.cThostFtdcTraderService reqQueryDepthMarket:params[0] nRequestID:[self requestIDWithParams:params requestCode:UPCTPRequestCode_DepthMarket]];
}

- (void)sendInstrumentMarginRateRequest:(NSArray *)params {
    NSLog(@"SendInstrumentMarginRateRequest: %@", params);
    [self.cThostFtdcTraderService reqQueryInstrumentMarginRate:params[0] brokerID:params[1] instrumentID:params[2] nRequestID:[self requestIDWithParams:params requestCode:UPCTPRequestCode_InstrumentMarginRate]];
}

- (void)sendInvestorPositionDetailRequest:(NSArray *)params {
    NSLog(@"SendInvestorPositionDetailRequest: %@", params);
    [self.cThostFtdcTraderService reqQueryInvestorPositionDetail:params[0] brokerID:params[1] instrumentID:params[2] nRequestID:[self requestIDWithParams:params requestCode:UPCTPRequestCode_InvestorPositionDetail]];
}

- (void)sendOrderRequest:(NSArray *)params {
    NSLog(@"SendOrderRequest: %@", params);
    [self.cThostFtdcTraderService reqQueryOrder:params[0] brokerID:params[1] instrumentID:params[2] nRequestID:[self requestIDWithParams:params requestCode:UPCTPRequestCode_Order]];
}

- (void)sendTransferBankRequest:(NSArray *)params {
    NSLog(@"SendTransferBankRequest: %@", params);
    [self.cThostFtdcTraderService reqQueryTransferBank:[self requestIDWithParams:params requestCode:UPCTPRequestCode_TransferBank]];
}

- (void)sendTransferSerialRequest:(NSArray *)params {
    NSLog(@"SendTransferSerialRequest: %@", params);
    [self.cThostFtdcTraderService reqQueryTransferSerial:params[0] brokerID:params[1] nRequestID:[self requestIDWithParams:params requestCode:UPCTPRequestCode_TransferSerial]];
}

- (void)sendAccountregisterRequest:(NSArray *)params {
    NSLog(@"SendAccountregisterRequest: %@", params);
    [self.cThostFtdcTraderService reqQueryAccountregister:params[0] brokerID:params[1] nRequestID:[self requestIDWithParams:params requestCode:UPCTPRequestCode_Accountregister]];
}

- (void)sendBetweenBankAndFutureRequest:(NSArray *)params {
    NSLog(@"sendBetweenBankAndFutureRequest: %@", params);
    [self.cThostFtdcTraderService reqBetweenBankAndFuture:params[0] brokerID:params[1] accountID:params[2] bankID:params[3] bankBranchID:params[4] amount:[params[5] doubleValue] fundPwd:params[6] bankPwd:params[7] transferDirection:[params[8] intValue] nRequestID:[self requestIDWithParams:params requestCode:UPCTPRequestCode_BetweenBankAndFuture]];
}

- (void)sendBankAccountMoneyRequest:(NSArray *)params {
    NSLog(@"SendBankAccountMoneyRequest: %@", params);
    [self.cThostFtdcTraderService reqQueryBankAccountMoneyByFuture:params[0] brokerID:params[1] nRequestID:[self requestIDWithParams:params requestCode:UPCTPRequestCode_BankAccountMoney]];
}

- (void)sendSubScribeMarketDataRequest:(NSArray *)params {
    NSLog(@"SendSubScribeMarketDataRequest: %@", params);
    [self.cThostFtdcTraderService subScribeMarketData:params[0] nRequestID:[self requestIDWithParams:params requestCode:UPCTPRequestCode_SubscribeMarketData]];
}

- (void)sendUnSubScribeMarketDataRequest:(NSArray *)params {
    NSLog(@"SendUnSubScribeMarketDataRequest: %@", params);
    [self.cThostFtdcTraderService unSubScribeMarketData:params[0]];
}

#pragma mark - Contains Dict

- (BOOL)containsDict:(NSDictionary *)dict inArray:(NSArray *)array {
    if (dict.count > 0 && array.count > 0) {
        for (NSDictionary *tmpDict in array) {
            if ([dict.allKeys[0] intValue] == [tmpDict.allKeys[0] intValue]) {
                return YES;
            }
        }
    }
    
    return NO;
}

#pragma mark - Receive Response
static const NSTimeInterval MAX_TIME_DIFFERENCE = 5.f;
- (void)receiveResponse:(id)rspModel error:(NSError *)error nRequestID:(int)nRequestID {
    UPCTPResponseModel *responseModel = [[UPCTPResponseModel alloc] init];
    responseModel.rspModel = rspModel;
    responseModel.error = error;
    responseModel.nRequestID = nRequestID;
//    [self handleResponse:responseModel];
    [self performSelector:@selector(handleResponse:) onThread:_receiveResponseThread withObject:responseModel waitUntilDone:NO];
}

- (void)handleResponse:(UPCTPResponseModel *)responseModel {
    NSLog(@"ReceiveResponse CurrentThread: %@, isMainThread: %d", [NSThread currentThread], [NSThread isMainThread]);
    dispatch_semaphore_wait(self.responseSemaphore, timeout);
    if (self.blocks.count > 0) {
        NSMutableArray<NSDictionary *> *tmpBlocks = [NSMutableArray array];
        NSMutableArray<NSDictionary *> *permanentBlocks = [NSMutableArray array];
        for (NSInteger index = 0; index < self.blocks.count; index++) {
            NSDictionary *dict = [self.blocks[index] copy];
            UPCTPBlockModel *blockModel = dict[dict.allKeys[0]];
            if ([dict.allKeys[0] intValue] == responseModel.nRequestID) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    blockModel.callback(responseModel.rspModel, responseModel.error);
                });
            } else {
                [tmpBlocks addObject:dict];
            }
            
            if ([dict.allKeys[0] intValue] >= SUBSCRIBE_MARKETDATA_REQUESTID &&
                ![self containsDict:dict inArray:[permanentBlocks copy]]) {
                [permanentBlocks addObject:dict];
            }
        }
        [self.blocks removeAllObjects];
        if (tmpBlocks.count > 0) {
            [self.blocks addObjectsFromArray:tmpBlocks];
        }
        if (permanentBlocks.count > 0) {
            [self.blocks addObjectsFromArray:permanentBlocks];
        }
        tmpBlocks = nil;
        permanentBlocks = nil;
    }
    dispatch_semaphore_signal(self.responseSemaphore);
}

#pragma mark - Timeout Event

- (void)handleTimeoutEvent {
//    [self removeTimeoutBlock];
    [self performSelector:@selector(removeTimeoutBlock) onThread:_timeoutEventThread withObject:nil waitUntilDone:NO];
}

- (void)removeTimeoutBlock {
    dispatch_semaphore_wait(self.responseSemaphore, timeout);
    if (self.blocks.count > 0) {
        NSMutableArray<NSDictionary *> *tmpBlocks = [NSMutableArray array];
        NSMutableArray<NSDictionary *> *permanentBlocks = [NSMutableArray array];
        for (NSInteger index = 0; index < self.blocks.count; index++) {
            NSDictionary *dict = [self.blocks[index] copy];
            UPCTPBlockModel *blockModel = dict[dict.allKeys[0]];
            NSTimeInterval timeInterval = time(NULL);
            NSLog(@"TimeIntervalDifference: %.f", timeInterval - blockModel.timeInterval);
            if (fabs(timeInterval - blockModel.timeInterval) > MAX_TIME_DIFFERENCE) {
                if ([dict.allKeys[0] intValue] < SUBSCRIBE_MARKETDATA_REQUESTID) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        blockModel.callback(nil, [UPErrorUtil errorWithDomain:UPCTPTradeError_RequestTimeout code:UPCTPTradeErrorCode_RequestTimeout]);
                        [[NSNotificationQueue defaultQueue] enqueueNotification:[NSNotification notificationWithName:REQUEST_TIME_OUT_NOTIFICATION object:@(blockModel.requestCode)] postingStyle:NSPostWhenIdle];
                    });
                }
            } else {
                [tmpBlocks addObject:dict];
            }
            
            if ([dict.allKeys[0] intValue] >= SUBSCRIBE_MARKETDATA_REQUESTID &&
                ![self containsDict:dict inArray:[permanentBlocks copy]]) {
                [permanentBlocks addObject:dict];
            }
        }
        [self.blocks removeAllObjects];
        if (tmpBlocks.count > 0) {
            [self.blocks addObjectsFromArray:tmpBlocks];
        }
        if (permanentBlocks.count > 0) {
            [self.blocks addObjectsFromArray:permanentBlocks];
        }
        tmpBlocks = nil;
        permanentBlocks = nil;
    }
    dispatch_semaphore_signal(self.responseSemaphore);
}

#pragma mark - Start & Stop timer

- (void)startTimer {
    [_timeoutEventerTimer setFireDate:[NSDate distantPast]];
}

- (void)stopTimer {
    [_timeoutEventerTimer setFireDate:[NSDate distantFuture]];
}

@end

@implementation UPCTPResponseModel

@end
