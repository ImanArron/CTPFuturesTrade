//
//  CTPTradeService.m
//  FuturesTrade
//
//  Created by LiuLian on 17/8/11.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCThostFtdcTraderService.h"
#include "UPCThostFtdcTraderSpi.h"
#include "UPCThostFtdcMdSpi.h"
#include "KSTraderApiEx.h"
#include "KSMdApiEx.h"
#import "UPErrorUtil.h"
#import "UPCTPTradeErrorConstants.h"
#import "UPCTPRequestQueue.h"
#import "UPCTPSimRequestQueue.h"
#import "UPCTPTradeCache.h"
#import "UPFuturesTradeEnvironmentUtil.h"

typedef NS_ENUM(NSInteger, CTPRequestStatus) {
    Logedin = 0,
    FrontConnecting,
    FrontConnected,
    Logingin,
    QueryingInvestorPosition,
    QueryingInvestorPositionDetail,
    QueryingTrade,
    QueryingOrder,
    QueryingTransferBank,
    QueryingTransferSerial,
    QueryingAccountregister,
    RequestingBetweenBankAndFuture,
    QueryingBankAccountMoney,
    MdFrontConnecting,
    MdFrontConnected,
    MdLogingin,
    MdLogedin
};

@interface UPCThostFtdcTraderService ()

@property (nonatomic, assign) UPCTPTradeType tradeType;
@property (nonatomic, strong) UPCThostFtdcTraderUserLoginModel *userLoginModel;
@property (nonatomic, strong) UPCTPRequestQueue *requestQueue;
@property (nonatomic, copy) NSArray *instruments;
@property (nonatomic, strong) NSMutableArray *status;
@property (nonatomic, strong) NSMutableArray *subScribeMarketDatas;
@property (nonatomic, strong) NSMutableArray *marketDatas;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) NSThread *statusThread;

@end

@implementation UPCThostFtdcTraderService

/// CTP Api
KingstarAPI::CThostFtdcTraderApi *api;
KingstarAPI::CThostFtdcTraderApi *simApi;
UPCThostFtdcTraderSpi *spi;
UPCThostFtdcTraderSpi *simSpi;

// CTP Md Api
KingstarAPI::CThostFtdcMdApi *mdApi;
KingstarAPI::CThostFtdcMdApi *mdSimApi;
UPCThostFtdcMdSpi *mdSpi;
UPCThostFtdcMdSpi *mdSimSpi;

/**
 * 仿真MD网关IP：218.65.95.125
 * 金仕达客户端推送端口：18991，B2B推送端口：18992，B2C推送端口：18993
 
 * 仿真AA网关IP：218.65.95.125
 * 金仕达客户端推送端口：17991，B2B端口：17992，B2C端口：17993
 */
char gTradeFrontAddr[]      = "tcp://218.65.95.123:51803";          // 生产环境
char gSimTradeFrontAddr[]   = "tcp://117.40.241.112:18993";         // 测试环境

#pragma mark - Dealloc
- (void)dealloc {
    [self releaseApi];
    [self releaseSimApi];
    [self releaseMdApi];
    [self releaseMdSimApi];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)releaseApi {
    if (NULL != api) {
        api->Join();
        delete spi;
        api->Release();
    }
}

- (void)releaseSimApi {
    if (NULL != simApi) {
        simApi->Join();
        delete simSpi;
        simApi->Release();
    }
}

- (void)releaseMdApi {
    if (NULL != mdApi) {
        mdApi->Join();
        delete mdSpi;
        mdApi->Release();
    }
}

- (void)releaseMdSimApi {
    if (NULL != mdSimApi) {
        mdSimApi->Join();
        delete mdSimSpi;
        mdSimApi->Release();
    }
}

#pragma mark - Init
- (instancetype)initWithTradeType:(UPCTPTradeType)tradeType {
    self = [super init];
    if (self) {
        self.tradeType = tradeType;
        [self initThread];
        [self addNotifications];
    }
    return self;
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveRequestTimeOutNotification:) name:REQUEST_TIME_OUT_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUIApplicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)initThread {
    _statusThread = [[NSThread alloc] initWithTarget:self selector:@selector(singleThread) object:nil];
    [_statusThread start];
}

- (void)singleThread {
    @autoreleasepool {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        CFRunLoopRun();
    }
}

#pragma mark - REQUEST_TIME_OUT_NOTIFICATION

- (void)didReceiveRequestTimeOutNotification:(NSNotification *)noti {
    if ([self requestStatus:FrontConnected]) {
        NSInteger requestCode = [noti.object integerValue];
        if (UPCTPRequestCode_Login == requestCode)
        {
            [self resetRequestStatus:Logingin];
            [self resetRequestStatus:FrontConnecting];
        }
        else if (UPCTPRequestCode_Logout == requestCode)
        {
            
        }
        else if (UPCTPRequestCode_OrderInsert == requestCode)
        {
            
        }
        else if (UPCTPRequestCode_TradingAccount == requestCode)
        {
            
        }
        else if (UPCTPRequestCode_InvestorPosition == requestCode)
        {
            [self resetRequestStatus:QueryingInvestorPosition];
        }
        else if (UPCTPRequestCode_InvestorPositionDetail == requestCode)
        {
            [self resetRequestStatus:QueryingInvestorPositionDetail];
        }
        else if (UPCTPRequestCode_Trade == requestCode)
        {
            [self resetRequestStatus:QueryingTrade];
        }
        else if (UPCTPRequestCode_DepthMarket == requestCode)
        {
            
        }
        else if (UPCTPRequestCode_Order == requestCode)
        {
            [self resetRequestStatus:QueryingOrder];
        }
        else if (UPCTPRequestCode_TransferBank == requestCode)
        {
            [self resetRequestStatus:QueryingTransferBank];
        }
        else if (UPCTPRequestCode_TransferSerial == requestCode)
        {
            [self resetRequestStatus:QueryingTransferSerial];
        }
        else if (UPCTPRequestCode_Accountregister == requestCode)
        {
            [self resetRequestStatus:QueryingAccountregister];
        }
        else if (UPCTPRequestCode_BetweenBankAndFuture == requestCode)
        {
            [self resetRequestStatus:RequestingBetweenBankAndFuture];
        }
        else if (UPCTPRequestCode_BankAccountMoney == requestCode)
        {
            [self resetRequestStatus:QueryingBankAccountMoney];
        }
    }
}

#pragma mark - UIApplicationDidBecomeActiveNotification

- (void)didUIApplicationBecomeActive:(NSNotification *)noti {
    
}

#pragma mark - Getter

- (UPCTPRequestQueue *)requestQueue {
    if (UPCTPRealTrade == self.tradeType) {
        return [UPCTPRequestQueue sharedRequestQueue];
    } else {
        return [UPCTPSimRequestQueue sharedSimRequestQueue];
    }
}

static dispatch_time_t semaphoreTimeout = 2.0 * NSEC_PER_SEC;
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(1);
    }
    return _semaphore;
}

- (NSMutableArray *)status {
    if (!_status) {
        _status = [@[
                    @0,     // isLogedin
                    @0,     // isFrontConnecting
                    @0,     // isFrontConnected
                    @0,     // isLogingin
                    @0,     // isQueryingInvestorPosition
                    @0,     // isQueryingInvestorPositionDetail
                    @0,     // isQueryingTrade
                    @0,     // isQueryingOrder
                    @0,     // isQueryingTransferBank
                    @0,     // isQueryingTransferSerial
                    @0,     // isQueryingAccountregister
                    @0,     // isRequestingBetweenBankAndFuture
                    @0,     // isQueryingBankAccountMoney
                    @0,     // isMdFrontConnecting
                    @0,     // isMdFrontConnected
                    @0,     // isMdLogingin
                    @0      // isMdLogedin
                    ] mutableCopy];
    }
    return _status;
}

- (NSMutableArray *)subScribeMarketDatas {
    if (!_subScribeMarketDatas) {
        _subScribeMarketDatas = [NSMutableArray array];
    }
    return _subScribeMarketDatas;
}

- (NSMutableArray *)marketDatas {
    if (!_marketDatas) {
        _marketDatas = [NSMutableArray array];
    }
    return _marketDatas;
}

#pragma mark - Logedin

- (BOOL)isLogedin {
    return [self requestStatus:Logedin];
}

#pragma mark - Reset & Set Status

////// Status //////
- (void)resetRequestStatus:(CTPRequestStatus)requestStatus {
    [self performSelector:@selector(resetRequestStatusOnThread:) onThread:_statusThread withObject:@(requestStatus) waitUntilDone:NO];
}

- (void)resetRequestStatusOnThread:(NSNumber *)requestStatus {
    dispatch_semaphore_wait(self.semaphore, semaphoreTimeout);
    [self.status replaceObjectAtIndex:[requestStatus integerValue] withObject:@0];
    dispatch_semaphore_signal(self.semaphore);
}

- (void)setRequestStatus:(CTPRequestStatus)requestStatus {
    [self performSelector:@selector(setRequestStatusOnThread:) onThread:_statusThread withObject:@(requestStatus) waitUntilDone:NO];
}

- (void)setRequestStatusOnThread:(NSNumber *)requestStatus {
    dispatch_semaphore_wait(self.semaphore, semaphoreTimeout);
    [self.status replaceObjectAtIndex:[requestStatus integerValue] withObject:@1];
    dispatch_semaphore_signal(self.semaphore);
}

- (BOOL)requestStatus:(CTPRequestStatus)requestStatus {
    dispatch_semaphore_wait(self.semaphore, semaphoreTimeout);
    BOOL status = [self.status[requestStatus] boolValue];
    dispatch_semaphore_signal(self.semaphore);
    return status;
}

- (void)resetAllStatus {
    [self performSelector:@selector(resetAllStatusOnThread) onThread:_statusThread withObject:nil waitUntilDone:NO];
}

- (void)resetAllStatusOnThread {
    dispatch_semaphore_wait(self.semaphore, semaphoreTimeout);
    for (NSInteger i = 0; i < self.status.count; i++) {
        [self.status replaceObjectAtIndex:i withObject:@0];
    }
    dispatch_semaphore_signal(self.semaphore);
}

- (void)resetAllMdStatus {
    [self performSelector:@selector(resetAllMdStatusOnThread) onThread:_statusThread withObject:nil waitUntilDone:NO];
}

- (void)resetAllMdStatusOnThread {
    dispatch_semaphore_wait(self.semaphore, semaphoreTimeout);
    for (NSInteger i = self.status.count - 4; i < self.status.count; i++) {
        [self.status replaceObjectAtIndex:i withObject:@0];
    }
    dispatch_semaphore_signal(self.semaphore);
}

#pragma mark - Connect CTP
- (const char *)pszFlowPath {
    NSString *path = [[UPCTPTradeCache documentPath] stringByAppendingPathComponent:UPCTPRealTrade == self.tradeType ? @"/CTPTrade" : @"/CTPSimTrade"];
    const char *pszFlowPath = [path UTF8String];
    return pszFlowPath;
}

- (void)connectCTP {
    if ([NSThread isMainThread]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self startConnectCTP];
        });
    } else {
        [self startConnectCTP];
    }
}

- (void)reconnectCTP {
    [self resetRequestStatus:Logedin];
    [self resetRequestStatus:FrontConnected];
    [self resetRequestStatus:FrontConnecting];
    [self resetRequestStatus:MdLogedin];
    [self resetRequestStatus:MdFrontConnected];
    [self resetRequestStatus:MdFrontConnecting];
    [self connectCTP];
}

- (void)startConnectCTP {
    NSLog(@"ConnectCTP FrontConnected: %d", [self requestStatus:FrontConnected]);
    NSLog(@"ConnectCTP FrontConnecting: %d", [self requestStatus:FrontConnecting]);
    const char *pszFlowPath = [self pszFlowPath];
    if (![self requestStatus:FrontConnected] && ![self requestStatus:FrontConnecting]) {
        if (UPCTPRealTrade == self.tradeType) {
            if (NULL == api) {
                api = KingstarAPI::CThostFtdcTraderApi::CreateFtdcTraderApi(pszFlowPath);
                spi = new UPCThostFtdcTraderSpi(0);
                
                api->RegisterSpi(spi);
                // 订阅公共流
                api->SubscribePublicTopic(KingstarAPI::THOST_TERT_QUICK);
                // 订阅私有流
                api->SubscribePrivateTopic(KingstarAPI::THOST_TERT_RESUME);
            }
            
            if (NULL != api) {
                NSLog(@"ConnectCTP");
                [self setRequestStatus:FrontConnecting];
                
                // 设置交易前置地址
                api->RegisterFront(gTradeFrontAddr);
                // 连接运行
                api->Init();
            }
        } else {
            if (NULL == simApi) {
                simApi = KingstarAPI::CThostFtdcTraderApi::CreateFtdcTraderApi(pszFlowPath);
                simSpi = new UPCThostFtdcTraderSpi(1);
                
                simApi->RegisterSpi(simSpi);
                // 订阅公共流
                simApi->SubscribePublicTopic(KingstarAPI::THOST_TERT_RESTART);
                // 订阅私有流
                simApi->SubscribePrivateTopic(KingstarAPI::THOST_TERT_RESTART);
            }
            
            if (NULL != simApi) {
                NSLog(@"ConnectSimCTP");
                [self setRequestStatus:FrontConnecting];
                
                // 设置交易前置地址
                simApi->RegisterFront(gSimTradeFrontAddr);
                // 连接运行
                simApi->Init();
            }
        }
    }
}

- (void)connectCTPResult:(BOOL)connected {
    [self resetRequestStatus:FrontConnecting];
    if (connected) {
        [self setRequestStatus:FrontConnected];
        [self userLogin];
    } else {
        [self handleFailedConnect];
    }
}

- (void)handleFailedConnect {
    [self resetRequestStatus:FrontConnected];
    if ([self requestStatus:Logingin]) {
        UPRspInfoModel *rspInfoModel = [[UPRspInfoModel alloc] init];
        rspInfoModel.ErrorID = UPCTPTradeErrorCode_NetworkConnectFailed;
        rspInfoModel.ErrorMsg = UPCTPTradeError_NetworkConnectFailed;
        [self reqUserLoginResult:nil pRspInfo:rspInfoModel];
    }
    [self resetRequestStatus:Logingin];
}

- (void)onFrontDisconnected:(int)nReason {
    [self resetAllStatus];
}

- (void)onHeartBeatWarning:(int)nTimeLapse {
    
}

#pragma mark - NSString To Char

- (const char *)string2Char:(NSString *)string {
    NSString *charString = [string copy];
    if (charString.length > 0) {
        return [charString UTF8String];
    }
    
    return "";
}

- (NSString *)trimWhiteSpace:(const NSString *)str {
    NSString *result = nil;
    if (str) {
        result = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return result;
}

- (UPRspInfoModel *)rspInfoModel:(NSString *)errorMsg errorID:(NSInteger)errorID nRequestID:(int)nRequestID {
    UPRspInfoModel *rspInfoModel = [[UPRspInfoModel alloc] init];
    rspInfoModel.ErrorMsg = [errorMsg copy];
    rspInfoModel.ErrorID = errorID;
    rspInfoModel.nRequestID = nRequestID;
    return rspInfoModel;
}

#pragma mark - Login
- (void)reqUserLogin:(NSString *)userID password:(NSString *)password brokerID:(NSString *)brokerID nRequestID:(int)nRequestID {
    _userLoginModel = [[UPCThostFtdcTraderUserLoginModel alloc] init];
    _userLoginModel.userID = [userID copy];
    _userLoginModel.password = [password copy];
    _userLoginModel.brokerID = [brokerID copy];
    _userLoginModel.nRequestID = nRequestID;
    if ([self requestStatus:FrontConnected]) {
        [self userLogin];
    } else {
        [self setRequestStatus:Logingin];
        [self connectCTP];
    }
}

- (void)userLogin {
    if (_userLoginModel && ![self isLogedin]) {
        KingstarAPI::CThostFtdcReqUserLoginField loginReq;
        memset(&loginReq, 0, sizeof(loginReq));
        strcpy(loginReq.UserID, [self string2Char:_userLoginModel.userID]);
        strcpy(loginReq.Password, [self string2Char:_userLoginModel.password]);
        strcpy(loginReq.BrokerID, [self string2Char:_userLoginModel.brokerID]);
        int rt;
        if (UPCTPRealTrade == self.tradeType) {
            rt = api->ReqUserLogin(&loginReq, _userLoginModel.nRequestID);
        } else {
            rt = simApi->ReqUserLogin(&loginReq, _userLoginModel.nRequestID);
        }
        if (!rt) {
            NSLog(@">>>>>>发送登录请求成功");
        } else {
            NSLog(@"--->>>发送登录请求失败");
            [self reqUserLoginResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_SendLoginRequestFailed errorID:UPCTPTradeErrorCode_SendLoginRequestFailed nRequestID:_userLoginModel.nRequestID]];
        }
    } else {
        if ([self isLogedin]) {
            [self.requestQueue receiveResponse:[UPCTPTradeCache cachedRspUserLoginModel:self.tradeType] error:nil nRequestID:_userLoginModel.nRequestID];
        }
    }
}

- (void)reqUserLoginResult:(UPRspUserLoginModel *)pRspUserLogin pRspInfo:(UPRspInfoModel *)pRspInfo {
    [self resetRequestStatus:Logingin];
    if (0 == pRspInfo.ErrorID) {
        [self setRequestStatus:Logedin];
        [UPCTPTradeCache cacheRspUserLoginModel:pRspUserLogin tradeType:self.tradeType];
        [self reqSettlementInfoConfirm];
        [self reqQueryInstruments];
        // 连接行情CTP
        [self connectMdCTP];
    } else {
        NSLog(@"ReqUserLoginResult error: %@", [UPErrorUtil errorWithRspInfo:pRspInfo]);
        // ErrorID为-3，表示与前置的连接有问题，需要重新连接前置
        if (-3 == pRspInfo.ErrorID) {
            [self reconnectCTP];
        }
    }
    [self.requestQueue receiveResponse:pRspUserLogin error:[UPErrorUtil errorWithRspInfo:pRspInfo] nRequestID:pRspUserLogin ? pRspUserLogin.nRequestID : pRspInfo.nRequestID];
}

- (void)reqSettlementInfoConfirm {
    UPRspUserLoginModel *model = [UPCTPTradeCache cachedRspUserLoginModel:self.tradeType];
    if (model) {
        KingstarAPI::CThostFtdcSettlementInfoConfirmField settlementConfirmReq;
        memset(&settlementConfirmReq, 0, sizeof(settlementConfirmReq));
        strcpy(settlementConfirmReq.BrokerID, [self string2Char:model.BrokerID]);
        strcpy(settlementConfirmReq.InvestorID, [self string2Char:model.UserID]);
        static int requestID = 0;
        int rt;
        if (UPCTPRealTrade == self.tradeType) {
            rt = api->ReqSettlementInfoConfirm(&settlementConfirmReq, requestID);
        } else {
            rt = simApi->ReqSettlementInfoConfirm(&settlementConfirmReq, requestID);
        }
        if (!rt) {
            NSLog(@">>>>>>发送投资者结算结果确认请求成功");
        } else {
            NSLog(@"--->>>发送投资者结算结果确认请求失败");
        }
    }
}

- (void)reqSettlementInfoConfirmResult {
    
}

- (void)reqQueryInstruments {
    KingstarAPI::CThostFtdcQryInstrumentField instrumentReq;
    memset(&instrumentReq, 0, sizeof(instrumentReq));
    static int requestID = 0;
    int rt;
    if (UPCTPRealTrade == self.tradeType) {
        rt = api->ReqQryInstrument(&instrumentReq, requestID);
    } else {
        rt = simApi->ReqQryInstrument(&instrumentReq, requestID);
    }
    if (!rt) {
        NSLog(@">>>>>>发送请求查询合约成功");
    } else {
        NSLog(@"--->>>发送请求查询合约失败");
    }
}

- (void)reqQueryInstrumentsResult:(NSArray *)instruments {
    //dispatch_semaphore_wait(self.semaphore, semaphoreTimeout);
    _instruments = [instruments copy];
    //dispatch_semaphore_signal(self.semaphore);
}

#pragma mark - Judge Whether Is Logedin
- (BOOL)isLogedin:(NSInteger)reqCode nRequestID:(int)nRequestID {
    BOOL logedin = [self isLogedin];
    if (!logedin) {
        UPRspInfoModel *pRspInfo = [[UPRspInfoModel alloc] init];
        pRspInfo.ErrorID = UPCTPTradeErrorCode_SendRequestWhileNotLogedin;
        pRspInfo.ErrorMsg = [UPErrorUtil errorDomainWithReqCode:reqCode];
        pRspInfo.nRequestID = nRequestID;
        [self.requestQueue receiveResponse:pRspInfo error:[UPErrorUtil errorWithRspInfo:pRspInfo] nRequestID:pRspInfo.nRequestID];
    }
    
    return logedin;
}

#pragma mark - Instruments

- (NSArray *)instruments {
    //dispatch_semaphore_wait(self.semaphore, semaphoreTimeout);
    NSArray *tmpInstruments = [_instruments copy];
    //dispatch_semaphore_signal(self.semaphore);
    return tmpInstruments;
}

#pragma mark - Logout
- (void)reqUserLogout:(NSString *)userID brokerID:(NSString *)brokerID nRequestID:(int)nRequestID {
    if ([self isLogedin:UPCTPRequestCode_Logout nRequestID:nRequestID]) {
        KingstarAPI::CThostFtdcUserLogoutField logoutReq;
        memset(&logoutReq, 0, sizeof(logoutReq));
        strcpy(logoutReq.UserID, [self string2Char:userID]);
        strcpy(logoutReq.BrokerID, [self string2Char:brokerID]);
        int rt;
        if (UPCTPRealTrade == self.tradeType) {
            rt = api->ReqUserLogout(&logoutReq, nRequestID);
        } else {
            rt = simApi->ReqUserLogout(&logoutReq, nRequestID);
        }
        if (!rt) {
            NSLog(@">>>>>>发送登出请求成功");
        } else {
            NSLog(@"--->>>发送登出请求失败");
            [self reqUserLogoutResult:[self rspInfoModel:UPCTPTradeError_SendLogoutRequestFailed errorID:UPCTPTradeErrorCode_SendLogoutRequestFailed nRequestID:nRequestID]];
        }
    }
}

- (void)reqUserLogoutResult:(UPRspInfoModel *)pRspInfo {
    if (0 == pRspInfo.ErrorID) {
    }
    [self resetRequestStatus:Logedin];
    [self.requestQueue receiveResponse:pRspInfo error:[UPErrorUtil errorWithRspInfo:pRspInfo] nRequestID:pRspInfo.nRequestID];
    [self mdReqUserLogout:_userLoginModel.userID brokerID:_userLoginModel.brokerID nRequestID:pRspInfo.nRequestID];
}

#pragma mark - Trade
- (void)reqOrderInsert:(NSString *)userID instrumentID:(NSString *)instrumentID price:(double)price volumeTotalOriginal:(int)volumeTotalOriginal direction:(int)direction combOffsetFlag:(int)combOffsetFlag brokerID:(NSString *)brokerID nRequestID:(int)nRequestID {
    if ([self isLogedin:UPCTPRequestCode_OrderInsert nRequestID:nRequestID]) {
        KingstarAPI::CThostFtdcInputOrderField orderInsertReq;
        memset(&orderInsertReq, 0, sizeof(orderInsertReq));
        ///经纪公司代码
        strcpy(orderInsertReq.BrokerID, [self string2Char:brokerID]);
        ///投资者代码
        strcpy(orderInsertReq.InvestorID, [self string2Char:userID]);
        ///合约代码
        strcpy(orderInsertReq.InstrumentID, [self string2Char:instrumentID]);
        ///报单引用
        strcpy(orderInsertReq.OrderRef, [self string2Char:[NSString stringWithFormat:@"%i", nRequestID]]);
        ///报单价格条件: 限价
        orderInsertReq.OrderPriceType = THOST_FTDC_OPT_LimitPrice;
        ///买卖方向:
        orderInsertReq.Direction = 0 == direction ? THOST_FTDC_D_Buy : THOST_FTDC_D_Sell;
        ///组合开平标志: 开仓
        if (0 == combOffsetFlag || 4 == combOffsetFlag) {
            orderInsertReq.CombOffsetFlag[0] = THOST_FTDC_OF_Open;
        } else if (1 == combOffsetFlag) {
            orderInsertReq.CombOffsetFlag[0] = THOST_FTDC_OF_Close;
        } else if (2 == combOffsetFlag) {
            orderInsertReq.CombOffsetFlag[0] = THOST_FTDC_OF_ForceClose;
        } else if (3 == combOffsetFlag) {
            orderInsertReq.CombOffsetFlag[0] = THOST_FTDC_OF_CloseToday;
        }
        ///组合投机套保标志
        orderInsertReq.CombHedgeFlag[0] = THOST_FTDC_HF_Speculation;
        ///价格
        orderInsertReq.LimitPrice = price;
        ///数量：1
        orderInsertReq.VolumeTotalOriginal = volumeTotalOriginal;
        ///有效期类型: 当日有效
        orderInsertReq.TimeCondition = THOST_FTDC_TC_GFD;
        ///成交量类型: 任何数量
        orderInsertReq.VolumeCondition = THOST_FTDC_VC_AV;
        ///最小成交量: 1
        //orderInsertReq.MinVolume = 1;
        ///触发条件: 立即
        orderInsertReq.ContingentCondition = THOST_FTDC_CC_Immediately;
        if (2 != combOffsetFlag) {
            ///强平原因: 非强平
            orderInsertReq.ForceCloseReason = THOST_FTDC_FCC_NotForceClose;
        }
        ///自动挂起标志: 否
        orderInsertReq.IsAutoSuspend = 0;
        ///用户强评标志: 否
        orderInsertReq.UserForceClose = 0;
        int rt;
        if (UPCTPRealTrade == self.tradeType) {
            rt = api->ReqOrderInsert(&orderInsertReq, nRequestID);
        } else {
            rt = simApi->ReqOrderInsert(&orderInsertReq, nRequestID);
        }
        if (!rt) {
            NSLog(@">>>>>>发送报单录入请求成功");
        } else {
            NSLog(@">>>>>>发送报单录入请求失败");
            [self reqOrderInsertResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_SendOrderInsertRequestFailed errorID:UPCTPTradeErrorCode_SendOrderInsertRequestFailed nRequestID:nRequestID]];
        }
    }
}

- (void)reqOrderInsertResult:(UPRspOrderModel *)pRspOrderInsert pRspInfo:(UPRspInfoModel *)pRspInfo {
    [self.requestQueue receiveResponse:pRspOrderInsert error:[UPErrorUtil errorWithRspInfo:pRspInfo] nRequestID:pRspOrderInsert ? pRspOrderInsert.nRequestID : pRspInfo.nRequestID];
}

- (void)reqOrderAction:(NSString *)userID instrumentID:(NSString *)instrumentID brokerID:(NSString *)brokerID orderRef:(NSString *)orderRef frontID:(int)frontID sessionID:(int)sessionID exchangeID:(NSString *)exchangeID nRequestID:(int)nRequestID {
    if ([self isLogedin:UPCTPRequestCode_OrderAction nRequestID:nRequestID]) {
        KingstarAPI::CThostFtdcInputOrderActionField orderActionReq;
        memset(&orderActionReq, 0, sizeof(orderActionReq));
        ///经纪公司代码
        strcpy(orderActionReq.BrokerID, [self string2Char:brokerID]);
        ///投资者代码
        strcpy(orderActionReq.InvestorID, [self string2Char:userID]);
        ///报单引用
        strcpy(orderActionReq.OrderRef, [self string2Char:orderRef]);
        ///操作标志
        orderActionReq.ActionFlag = THOST_FTDC_AF_Delete;
        ///合约代码
        strcpy(orderActionReq.InstrumentID, [self string2Char:instrumentID]);
        ///前置编号
        orderActionReq.FrontID = frontID;
        ///会话编号
        orderActionReq.SessionID = sessionID;
        ///交易所代码
        strcpy(orderActionReq.ExchangeID, [self string2Char:exchangeID]);
        ///报单编号
//        strcpy(orderActionReq.OrderSysID, [self string2Char:orderSysID]);
        int rt;
        if (UPCTPRealTrade == self.tradeType) {
            rt = api->ReqOrderAction(&orderActionReq, nRequestID);
        } else {
            rt = simApi->ReqOrderAction(&orderActionReq, nRequestID);
        }
        if (!rt) {
            NSLog(@">>>>>>发送撤单请求成功");
        } else {
            NSLog(@">>>>>>发送撤单请求失败");
            [self reqOrderActionResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_SendOrderActionRequestFailed errorID:UPCTPTradeErrorCode_SendOrderActionRequestFailed nRequestID:nRequestID]];
        }
    }
}

- (void)reqOrderActionResult:(UPRspOrderActionModel *)pRspOrderAction pRspInfo:(UPRspInfoModel *)pRspInfo {
    [self.requestQueue receiveResponse:pRspOrderAction error:[UPErrorUtil errorWithRspInfo:pRspInfo] nRequestID:pRspOrderAction ? pRspOrderAction.nRequestID : pRspInfo.nRequestID];
}

#pragma mark - Query
- (void)sleep {
    //[NSThread sleepForTimeInterval:1.f];
}

- (void)reqQueryTradingAccount:(NSString *)userID brokerID:(NSString *)brokerID nRequestID:(int)nRequestID {
    if ([self isLogedin:UPCTPRequestCode_TradingAccount nRequestID:nRequestID]) {
        KingstarAPI::CThostFtdcQryTradingAccountField tradingAccountReq;
        memset(&tradingAccountReq, 0, sizeof(tradingAccountReq));
        strcpy(tradingAccountReq.BrokerID, [self string2Char:brokerID]);
        strcpy(tradingAccountReq.InvestorID, [self string2Char:userID]);
        // 有时候需要停顿一会才能查询成功
        [self sleep];
        int rt;
        if (UPCTPRealTrade == self.tradeType) {
            rt = api->ReqQryTradingAccount(&tradingAccountReq, nRequestID);
        } else {
            rt = simApi->ReqQryTradingAccount(&tradingAccountReq, nRequestID);
        }
        if (!rt) {
            NSLog(@">>>>>>发送投资者资金账户查询请求成功");
        } else {
            NSLog(@">>>>>>发送投资者资金账户查询请求失败");
            [self reqQueryTradingAccountResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_SendQueryTradingAccountRequestFailed errorID:UPCTPTradeErrorCode_SendQueryTradingAccountRequestFailed nRequestID:nRequestID]];
        }
    }
}

- (void)reqQueryTradingAccountResult:(UPRspTradingAccountModel *)pRspTradingAccount pRspInfo:(UPRspInfoModel *)pRspInfo {
    [self.requestQueue receiveResponse:pRspTradingAccount error:[UPErrorUtil errorWithRspInfo:pRspInfo] nRequestID:pRspTradingAccount ? pRspTradingAccount.nRequestID : pRspInfo.nRequestID];
}

- (void)reqQueryInvestorPosition:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID nRequestID:(int)nRequestID {
    if ([self isLogedin:UPCTPRequestCode_InvestorPosition nRequestID:nRequestID]) {
        if (![self requestStatus:QueryingInvestorPosition]) {
            KingstarAPI::CThostFtdcQryInvestorPositionField postionReq;
            memset(&postionReq, 0, sizeof(postionReq));
            strcpy(postionReq.BrokerID, [self string2Char:brokerID]);
            strcpy(postionReq.InvestorID, [self string2Char:userID]);
            if (instrumentID.length > 0) {
                strcpy(postionReq.InstrumentID, [self string2Char:instrumentID]);
            }
            [self sleep];
            int rt;
            if (UPCTPRealTrade == self.tradeType) {
                rt = api->ReqQryInvestorPosition(&postionReq, nRequestID);
            } else {
                rt = simApi->ReqQryInvestorPosition(&postionReq, nRequestID);
            }
            if (!rt) {
                [self setRequestStatus:QueryingInvestorPosition];
                NSLog(@">>>>>>发送投资者持仓查询请求成功");
            } else {
                NSLog(@">>>>>>发送投资者持仓查询请求失败");
                [self reqQueryInvestorPositionResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_SendQueryInvestorPositionRequestFailed errorID:UPCTPTradeErrorCode_SendQueryInvestorPositionRequestFailed nRequestID:nRequestID]];
            }
        } else {
            [self reqQueryInvestorPositionResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_RepeatedQueryInvestorPosition errorID:UPCTPTradeErrorCode_RepeatedQueryInvestorPosition nRequestID:nRequestID]];
        }
    }
}

- (void)reqQueryInvestorPositionResult:(NSArray<UPRspInvestorPositionModel *> *)pRspInvestorPositions pRspInfo:(UPRspInfoModel *)pRspInfo {
    [self resetRequestStatus:QueryingInvestorPosition];
    [self.requestQueue receiveResponse:pRspInvestorPositions error:[UPErrorUtil errorWithRspInfo:pRspInfo] nRequestID:pRspInfo.nRequestID];
}

- (void)reqQueryInvestorPositionDetail:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID nRequestID:(int)nRequestID {
    if ([self isLogedin:UPCTPRequestCode_InvestorPositionDetail nRequestID:nRequestID]) {
        if (![self requestStatus:QueryingInvestorPositionDetail]) {
            KingstarAPI::CThostFtdcQryInvestorPositionDetailField postionReq;
            memset(&postionReq, 0, sizeof(postionReq));
            strcpy(postionReq.BrokerID, [self string2Char:brokerID]);
            strcpy(postionReq.InvestorID, [self string2Char:userID]);
            if (instrumentID.length > 0) {
                strcpy(postionReq.InstrumentID, [self string2Char:instrumentID]);
            }
            [self sleep];
            int rt;
            if (UPCTPRealTrade == self.tradeType) {
                rt = api->ReqQryInvestorPositionDetail(&postionReq, nRequestID);
            } else {
                rt = simApi->ReqQryInvestorPositionDetail(&postionReq, nRequestID);
            }
            if (!rt) {
                [self setRequestStatus:QueryingInvestorPositionDetail];
                NSLog(@">>>>>>发送投资者持仓明细查询请求成功");
            } else {
                NSLog(@">>>>>>发送投资者持仓明细查询请求失败");
                [self reqQueryInvestorPositionDetailResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_SendQueryInvestorPositionDetailRequestFailed errorID:UPCTPTradeErrorCode_SendQueryInvestorPositionDetailRequestFailed nRequestID:nRequestID]];
            }
        } else {
            [self reqQueryInvestorPositionDetailResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_RepeatedQueryInvestorPositionDetail errorID:UPCTPTradeErrorCode_RepeatedQueryInvestorPositionDetail nRequestID:nRequestID]];
        }
    }
}

- (void)reqQueryInvestorPositionDetailResult:(NSArray<UPRspInvestorPositionDetailModel *> *)pRspInvestorPositions pRspInfo:(UPRspInfoModel *)pRspInfo {
    [self resetRequestStatus:QueryingInvestorPositionDetail];
    [self.requestQueue receiveResponse:pRspInvestorPositions error:[UPErrorUtil errorWithRspInfo:pRspInfo] nRequestID:pRspInfo.nRequestID];
}

- (void)reqQueryTrade:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID timeStart:(NSString *)timeStart timeEnd:(NSString *)timeEnd nRequestID:(int)nRequestID {
    if ([self isLogedin:UPCTPRequestCode_Trade nRequestID:nRequestID]) {
        if (![self requestStatus:QueryingTrade]) {
            KingstarAPI::CThostFtdcQryTradeField tradeReq;
            memset(&tradeReq, 0, sizeof(tradeReq));
            strcpy(tradeReq.BrokerID, [self string2Char:brokerID]);
            strcpy(tradeReq.InvestorID, [self string2Char:userID]);
            if (instrumentID.length > 0) {
                strcpy(tradeReq.InstrumentID, [self string2Char:instrumentID]);
            }
            if (timeStart.length > 0) {
                strcpy(tradeReq.TradeTimeStart, [self string2Char:timeStart]);
            }
            if (timeEnd.length > 0) {
                strcpy(tradeReq.TradeTimeEnd, [self string2Char:timeEnd]);
            }
            [self sleep];
            int rt;
            if (UPCTPRealTrade == self.tradeType) {
                rt = api->ReqQryTrade(&tradeReq, nRequestID);
            } else {
                rt = simApi->ReqQryTrade(&tradeReq, nRequestID);
            }
            if (!rt) {
                [self setRequestStatus:QueryingTrade];
                NSLog(@">>>>>>发送投资者成交查询请求成功");
            } else {
                NSLog(@">>>>>>发送投资者成交查询请求失败");
                [self reqQueryTradeResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_SendQueryTradeRequestFailed errorID:UPCTPTradeErrorCode_SendQueryTradeRequestFailed nRequestID:nRequestID]];
            }
        } else {
            [self reqQueryTradeResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_RepeatedQueryTrade errorID:UPCTPTradeErrorCode_RepeatedQueryTrade nRequestID:nRequestID]];
        }
    }
}

- (void)reqQueryTradeResult:(NSArray<UPRspTradeModel *> *)pRspTrades pRspInfo:(UPRspInfoModel *)pRspInfo {
    [self resetRequestStatus:QueryingTrade];
    [self.requestQueue receiveResponse:pRspTrades error:[UPErrorUtil errorWithRspInfo:pRspInfo] nRequestID:pRspInfo.nRequestID];
}

- (void)reqQueryDepthMarket:(NSString *)instrumentID nRequestID:(int)nRequestID {
    if ([self isLogedin:UPCTPRequestCode_DepthMarket nRequestID:nRequestID]) {
        KingstarAPI::CThostFtdcQryDepthMarketDataField depthMarketDataReq;
        memset(&depthMarketDataReq, 0, sizeof(depthMarketDataReq));
        if (instrumentID) {
            strcpy(depthMarketDataReq.InstrumentID, [self string2Char:instrumentID]);
        }
        int rt;
        if (UPCTPRealTrade == self.tradeType) {
            rt = api->ReqQryDepthMarketData(&depthMarketDataReq, nRequestID);
        } else {
            rt = simApi->ReqQryDepthMarketData(&depthMarketDataReq, nRequestID);
        }
        if (!rt) {
            NSLog(@">>>>>>发送深度行情查询请求成功");
        } else {
            NSLog(@">>>>>>发送深度行情查询请求失败");
            [self reqQueryDepthMarketResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_SendQueryDepthMarketRequestFailed errorID:UPCTPTradeErrorCode_SendQueryDepthMarketRequestFailed nRequestID:nRequestID]];
        }
    }
}

- (void)reqQueryDepthMarketResult:(NSArray<UPRspDepthMarketDataModel *> *)pRspDepthMarketDatas pRspInfo:(UPRspInfoModel *)pRspInfo {
    [self.requestQueue receiveResponse:pRspDepthMarketDatas error:[UPErrorUtil errorWithRspInfo:pRspInfo] nRequestID:pRspInfo.nRequestID];
}

- (void)reqQueryInstrumentMarginRate:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID nRequestID:(int)nRequestID {
    if ([self isLogedin:UPCTPRequestCode_InstrumentMarginRate nRequestID:nRequestID]) {
        KingstarAPI::CThostFtdcQryInstrumentMarginRateField marginRateReq;
        memset(&marginRateReq, 0, sizeof(marginRateReq));
        strcpy(marginRateReq.BrokerID, [self string2Char:brokerID]);
        strcpy(marginRateReq.InvestorID, [self string2Char:userID]);
        if (instrumentID) {
            strcpy(marginRateReq.InstrumentID, [self string2Char:instrumentID]);
        }
        int rt;
        if (UPCTPRealTrade == self.tradeType) {
            rt = api->ReqQryInstrumentMarginRate(&marginRateReq, nRequestID);
        } else {
            rt = simApi->ReqQryInstrumentMarginRate(&marginRateReq, nRequestID);
        }
        if (!rt) {
            NSLog(@">>>>>>发送合约保证金率查询请求成功");
        } else {
            NSLog(@">>>>>>发送合约保证金率查询请求失败");
            [self reqQueryInstrumentMarginRateResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_SendQueryInstrumentMarginRateRequestFailed errorID:UPCTPTradeErrorCode_SendQueryInstrumentMarginRateRequestFailed nRequestID:nRequestID]];
        }
    }
}

- (void)reqQueryInstrumentMarginRateResult:(NSArray<UPRspInstrumentMarginRateModel *> *)pRspDepthMarketDatas pRspInfo:(UPRspInfoModel *)pRspInfo {
    [self.requestQueue receiveResponse:pRspDepthMarketDatas error:[UPErrorUtil errorWithRspInfo:pRspInfo] nRequestID:pRspInfo.nRequestID];
}

- (void)reqQueryOrder:(NSString *)userID brokerID:(NSString *)brokerID instrumentID:(NSString *)instrumentID nRequestID:(int)nRequestID {
    if ([self isLogedin:UPCTPRequestCode_Order nRequestID:nRequestID]) {
        if (![self requestStatus:QueryingOrder]) {
            KingstarAPI::CThostFtdcQryOrderField orderReq;
            memset(&orderReq, 0, sizeof(orderReq));
            strcpy(orderReq.BrokerID, [self string2Char:brokerID]);
            strcpy(orderReq.InvestorID, [self string2Char:userID]);
            if (instrumentID) {
                strcpy(orderReq.InstrumentID, [self string2Char:instrumentID]);
            }
            [self sleep];
            int rt;
            if (UPCTPRealTrade == self.tradeType) {
                rt = api->ReqQryOrder(&orderReq, nRequestID);
            } else {
                rt = simApi->ReqQryOrder(&orderReq, nRequestID);
            }
            if (!rt) {
                [self setRequestStatus:QueryingOrder];
                NSLog(@">>>>>>发送投资者报单查询请求成功");
            } else {
                NSLog(@">>>>>>发送投资者报单查询请求失败");
                [self reqQueryTradeResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_SendQueryOrderRequestFailed errorID:UPCTPTradeErrorCode_SendQueryOrderRequestFailed nRequestID:nRequestID]];
            }
        } else {
            [self reqQueryTradeResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_RepeatedQueryOrder errorID:UPCTPTradeErrorCode_RepeatedQueryOrder nRequestID:nRequestID]];
        }
    }
}

- (void)reqQueryOrderResult:(NSArray<UPRspOrderModel *> *)pRspOrders pRspInfo:(UPRspInfoModel *)pRspInfo {
    [self resetRequestStatus:QueryingOrder];
    [self.requestQueue receiveResponse:pRspOrders error:[UPErrorUtil errorWithRspInfo:pRspInfo] nRequestID:pRspInfo.nRequestID];
}

#pragma mark - Transfer

- (void)reqQueryTransferBank:(int)nRequestID {
    if ([self isLogedin:UPCTPRequestCode_TransferBank nRequestID:nRequestID]) {
        if (![self requestStatus:QueryingTransferBank]) {
            KingstarAPI::CThostFtdcQryTransferBankField transferBankReq;
            memset(&transferBankReq, 0, sizeof(transferBankReq));
            int rt;
            if (UPCTPRealTrade == self.tradeType) {
                rt = api->ReqQryTransferBank(&transferBankReq, nRequestID);
            } else {
                rt = simApi->ReqQryTransferBank(&transferBankReq, nRequestID);
            }
            if (!rt) {
                [self setRequestStatus:QueryingTransferBank];
                NSLog(@">>>>>>发送转账银行查询请求成功");
            } else {
                NSLog(@">>>>>>发送转账银行查询请求失败");
                [self reqQueryTransferBankResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_SendQueryTransferBankRequestFailed errorID:UPCTPTradeErrorCode_SendQueryTransferBankRequestFailed nRequestID:nRequestID]];
            }
        } else {
            [self reqQueryTransferBankResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_RepeatedQueryTransferBank errorID:UPCTPTradeErrorCode_RepeatedQueryTransferBank nRequestID:nRequestID]];
        }
    }
}

- (void)reqQueryTransferBankResult:(NSArray<UPRspTransferBankModel *> *)banks pRspInfo:(UPRspInfoModel *)pRspInfo {
    [self resetRequestStatus:QueryingTransferBank];
    [self.requestQueue receiveResponse:banks error:[UPErrorUtil errorWithRspInfo:pRspInfo] nRequestID:pRspInfo.nRequestID];
}

- (void)reqQueryTransferSerial:(NSString *)accountID brokerID:(NSString *)brokerID nRequestID:(int)nRequestID {
    if ([self isLogedin:UPCTPRequestCode_TransferSerial nRequestID:nRequestID]) {
        if (![self requestStatus:QueryingTransferSerial]) {
            KingstarAPI::CThostFtdcQryTransferSerialField transferSerialReq;
            memset(&transferSerialReq, 0, sizeof(transferSerialReq));
            strcpy(transferSerialReq.BrokerID, [self string2Char:brokerID]);
            strcpy(transferSerialReq.AccountID, [self string2Char:accountID]);
            int rt;
            if (UPCTPRealTrade == self.tradeType) {
                rt = api->ReqQryTransferSerial(&transferSerialReq, nRequestID);
            } else {
                rt = simApi->ReqQryTransferSerial(&transferSerialReq, nRequestID);
            }
            if (!rt) {
                [self setRequestStatus:QueryingTransferSerial];
                NSLog(@">>>>>>发送转账流水查询请求成功");
            } else {
                NSLog(@">>>>>>发送转账流水查询请求失败");
                [self reqQueryTransferSerialResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_SendQueryTransferSerialRequestFailed errorID:UPCTPTradeErrorCode_SendQueryTransferSerialRequestFailed nRequestID:nRequestID]];
            }
        } else {
            [self reqQueryTransferSerialResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_RepeatedQueryTransferSerial errorID:UPCTPTradeErrorCode_RepeatedQueryTransferSerial nRequestID:nRequestID]];
        }
    }
}

- (void)reqQueryTransferSerialResult:(NSArray<UPRspTransferSerialModel *> *)serials pRspInfo:(UPRspInfoModel *)pRspInfo {
    [self resetRequestStatus:QueryingTransferSerial];
    [self.requestQueue receiveResponse:serials error:[UPErrorUtil errorWithRspInfo:pRspInfo] nRequestID:pRspInfo.nRequestID];
}

- (void)reqQueryAccountregister:(NSString *)accountID brokerID:(NSString *)brokerID nRequestID:(int)nRequestID {
    if ([self isLogedin:UPCTPRequestCode_Accountregister nRequestID:nRequestID]) {
        if (![self requestStatus:QueryingAccountregister]) {
            KingstarAPI::CThostFtdcQryAccountregisterField accountregisterReq;
            memset(&accountregisterReq, 0, sizeof(accountregisterReq));
            strcpy(accountregisterReq.BrokerID, [self string2Char:brokerID]);
            strcpy(accountregisterReq.AccountID, [self string2Char:accountID]);
            int rt;
            if (UPCTPRealTrade == self.tradeType) {
                rt = api->ReqQryAccountregister(&accountregisterReq, nRequestID);
            } else {
                rt = simApi->ReqQryAccountregister(&accountregisterReq, nRequestID);
            }
            if (!rt) {
                [self setRequestStatus:QueryingAccountregister];
                NSLog(@">>>>>>发送银期签约关系查询请求成功");
            } else {
                NSLog(@">>>>>>发送银期签约关系查询请求失败");
                [self reqQueryAccountregisterResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_SendQueryAccountregisterRequestFailed errorID:UPCTPTradeErrorCode_SendQueryAccountregisterRequestFailed nRequestID:nRequestID]];
            }
        } else {
            [self reqQueryAccountregisterResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_RepeatedQueryAccountregister errorID:UPCTPTradeErrorCode_RepeatedQueryAccountregister nRequestID:nRequestID]];
        }
    }
}

- (void)reqQueryAccountregisterResult:(NSArray<UPRspAccountregisterModel *> *)accountregisters pRspInfo:(UPRspInfoModel *)pRspInfo {
    [self resetRequestStatus:QueryingAccountregister];
    [self.requestQueue receiveResponse:accountregisters error:[UPErrorUtil errorWithRspInfo:pRspInfo] nRequestID:pRspInfo.nRequestID];
}

- (void)reqBetweenBankAndFuture:(NSString *)userID brokerID:(NSString *)brokerID accountID:(NSString *)accountID bankID:(NSString *)bankID bankBranchID:(NSString *)bankBranchID amount:(double)amount fundPwd:(NSString *)fundPwd bankPwd:(NSString *)bankPwd transferDirection:(int)transferDirection nRequestID:(int)nRequestID {
    if ([self isLogedin:UPCTPRequestCode_BetweenBankAndFuture nRequestID:nRequestID]) {
        if (![self requestStatus:RequestingBetweenBankAndFuture]) {
            KingstarAPI::CThostFtdcReqTransferField transferReq;
            memset(&transferReq, 0, sizeof(transferReq));
            strcpy(transferReq.BankAccount, [self string2Char:accountID]);
            strcpy(transferReq.BrokerID, [self string2Char:brokerID]);
            strcpy(transferReq.BankID, [self string2Char:bankID]);
            strcpy(transferReq.BankBranchID, [self string2Char:bankBranchID]);
            strcpy(transferReq.Password, [self string2Char:fundPwd]);
            strcpy(transferReq.BankPassWord, [self string2Char:bankPwd]);
            strcpy(transferReq.AccountID, [self string2Char:userID]);
            transferReq.TradeAmount = amount;
            transferReq.SecuPwdFlag = THOST_FTDC_BPWDF_BlankCheck;
            int rt;
            if (UPCTPRealTrade == self.tradeType) {
                if (0 == transferDirection) {
                    rt = api->ReqFromBankToFutureByFuture(&transferReq, nRequestID);
                } else {
                    rt = api->ReqFromFutureToBankByFuture(&transferReq, nRequestID);
                }
            } else {
                if (0 == transferDirection) {
                    rt = simApi->ReqFromBankToFutureByFuture(&transferReq, nRequestID);
                } else {
                    rt = simApi->ReqFromFutureToBankByFuture(&transferReq, nRequestID);
                }
            }
            if (!rt) {
                [self setRequestStatus:RequestingBetweenBankAndFuture];
                if (0 == transferDirection) {
                    NSLog(@">>>>>>发送银行资金转期货请求成功");
                } else {
                    NSLog(@">>>>>>发送期货资金转银行请求成功");
                }
            } else {
                if (0 == transferDirection) {
                    NSLog(@">>>>>>发送银行资金转期货请求失败");
                } else {
                    NSLog(@">>>>>>发送期货资金转银行请求失败");
                }
                [self reqBetweenBankAndFutureResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_SendBetweenBankAndFutureRequestFailed errorID:UPCTPTradeErrorCode_SendBetweenBankAndFutureRequestFailed nRequestID:nRequestID]];
            }
        } else {
            [self reqBetweenBankAndFutureResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_RepeatedQueryBetweenBankAndFuture errorID:UPCTPTradeErrorCode_RepeatedQueryBetweenBankAndFuture nRequestID:nRequestID]];
        }
    }
}

- (void)reqBetweenBankAndFutureResult:(NSArray<UPRspTransferModel *> *)transfers pRspInfo:(UPRspInfoModel *)pRspInfo {
    [self resetRequestStatus:RequestingBetweenBankAndFuture];
    [self.requestQueue receiveResponse:transfers error:[UPErrorUtil errorWithRspInfo:pRspInfo] nRequestID:pRspInfo.nRequestID];
}

- (void)reqQueryBankAccountMoneyByFuture:(NSString *)accountID brokerID:(NSString *)brokerID nRequestID:(int)nRequestID {
    if ([self isLogedin:UPCTPRequestCode_BankAccountMoney nRequestID:nRequestID]) {
        if (![self requestStatus:QueryingBankAccountMoney]) {
            KingstarAPI::CThostFtdcReqQueryAccountField queryAccountReq;
            memset(&queryAccountReq, 0, sizeof(queryAccountReq));
            strcpy(queryAccountReq.AccountID, [self string2Char:accountID]);
            strcpy(queryAccountReq.BrokerID, [self string2Char:brokerID]);
            //strcpy(queryAccountReq.BankID, [self string2Char:@"5"]);
            //strcpy(queryAccountReq.Password, [self string2Char:@"084517"]);
            //strcpy(queryAccountReq.BankPassWord, [self string2Char:@"084517"]);
            int rt;
            if (UPCTPRealTrade == self.tradeType) {
                rt = api->ReqQueryBankAccountMoneyByFuture(&queryAccountReq, nRequestID);
            } else {
                rt = simApi->ReqQueryBankAccountMoneyByFuture(&queryAccountReq, nRequestID);
            }
            if (!rt) {
                [self setRequestStatus:QueryingBankAccountMoney];
                NSLog(@">>>>>>发送银行余额查询请求成功");
            } else {
                NSLog(@">>>>>>发送银行余额查询请求失败");
                [self reqQueryBankAccountMoneyByFutureResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_SendQueryBankAccountMoneyRequestFailed errorID:UPCTPTradeErrorCode_SendQueryBankAccountMoneyRequestFailed nRequestID:nRequestID]];
            }
        } else {
            [self reqQueryBankAccountMoneyByFutureResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_RepeatedQueryBankAccountMoney errorID:UPCTPTradeErrorCode_RepeatedQueryBankAccountMoney nRequestID:nRequestID]];
        }
    }
}

- (void)reqQueryBankAccountMoneyByFutureResult:(UPRspNotifyQueryAccountModel *)accountModel pRspInfo:(UPRspInfoModel *)pRspInfo {
    [self resetRequestStatus:QueryingBankAccountMoney];
    [self.requestQueue receiveResponse:accountModel error:[UPErrorUtil errorWithRspInfo:pRspInfo] nRequestID:pRspInfo.nRequestID];
}

#pragma mark - Connect Md CTP
- (const char *)mdPszFlowPath {
    NSString *path = [[UPCTPTradeCache documentPath] stringByAppendingPathComponent:UPCTPRealTrade == self.tradeType ? @"/MdCTPTrade" : @"/MdCTPSimTrade"];
    const char *pszFlowPath = [path UTF8String];
    return pszFlowPath;
}

- (void)connectMdCTP {
    if ([self requestStatus:MdFrontConnected]) {
        [self mdUserLogin];
    } else {
        if ([NSThread isMainThread]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self startConnectMdCTP];
            });
        } else {
            [self startConnectMdCTP];
        }
    }
}

/**
 * 仿真MD网关IP：218.65.95.125
 * 金仕达客户端推送端口：18991，B2B推送端口：18992，B2C推送端口：18993
 
 * 仿真AA网关IP：218.65.95.125
 * 金仕达客户端推送端口：17991，B2B端口：17992，B2C端口：17993
 */
- (void)startConnectMdCTP {
    const char *pszFlowPath = [self mdPszFlowPath];
    if (![self requestStatus:MdFrontConnected] && ![self requestStatus:MdFrontConnecting]) {
        if (UPCTPRealTrade == self.tradeType) {
            if (NULL == mdApi) {
                mdApi = KingstarAPI::CThostFtdcMdApi::CreateFtdcMdApi(pszFlowPath);
                mdSpi = new UPCThostFtdcMdSpi(0);
                mdApi->RegisterSpi(mdSpi);
            }
            
            if (NULL != mdApi) {
                NSLog(@"ConnectMdCTP");
                [self setRequestStatus:MdFrontConnecting];
                
                // 设置交易前置地址
                mdApi->RegisterFront(gTradeFrontAddr);
                // 连接运行
                mdApi->Init();
            }
        } else {
            if (NULL == mdSimApi) {
                mdSimApi = KingstarAPI::CThostFtdcMdApi::CreateFtdcMdApi(pszFlowPath);
                mdSimSpi = new UPCThostFtdcMdSpi(1);
                mdSimApi->RegisterSpi(mdSimSpi);
            }
            
            if (NULL != mdSimApi) {
                NSLog(@"ConnectMdSimCTP");
                [self setRequestStatus:MdFrontConnecting];
                
                // 设置交易前置地址
                mdSimApi->RegisterFront(gSimTradeFrontAddr);
                // 连接运行
                mdSimApi->Init();
            }
        }
    }
}

- (void)connectMdCTPResult:(BOOL)connected {
    [self resetRequestStatus:MdFrontConnecting];
    if (connected) {
        [self setRequestStatus:MdFrontConnected];
        [self mdUserLogin];
    } else {
        [self handleMdFailedConnect];
    }
}

- (void)handleMdFailedConnect {
    [self resetRequestStatus:MdFrontConnected];
    [self resetRequestStatus:MdLogingin];
}

- (void)onMdFrontDisconnected:(int)nReason {
    [self resetAllMdStatus];
}

- (void)onMdHeartBeatWarning:(int)nTimeLapse {
    
}

#pragma mark - Md Login

- (void)mdUserLogin {
    if (_userLoginModel && ![self requestStatus:MdLogedin]) {
        KingstarAPI::CThostFtdcReqUserLoginField loginReq;
        memset(&loginReq, 0, sizeof(loginReq));
        strcpy(loginReq.UserID, [self string2Char:_userLoginModel.userID]);
        strcpy(loginReq.Password, [self string2Char:_userLoginModel.password]);
        strcpy(loginReq.BrokerID, [self string2Char:_userLoginModel.brokerID]);
        int rt;
        if (UPCTPRealTrade == self.tradeType) {
            rt = mdApi->ReqUserLogin(&loginReq, _userLoginModel.nRequestID);
        } else {
            rt = mdSimApi->ReqUserLogin(&loginReq, _userLoginModel.nRequestID);
        }
        
        if (!rt) {
            NSLog(@">>>>>>发送行情登录请求成功");
        } else {
            NSLog(@"--->>>发送行情登录请求失败");
            [self mdReqUserLoginResult:nil pRspInfo:[self rspInfoModel:UPCTPTradeError_SendCTPLoginRequestFailed errorID:UPCTPTradeErrorCode_SendCTPLoginRequestFailed nRequestID:_userLoginModel.nRequestID]];
        }
        
        [self.subScribeMarketDatas removeAllObjects];
    }
}

- (void)mdReqUserLoginResult:(UPRspUserLoginModel *)pRspUserLogin pRspInfo:(UPRspInfoModel *)pRspInfo {
    [self resetRequestStatus:MdLogingin];
    if (0 == pRspInfo.ErrorID) {
        [self setRequestStatus:MdLogedin];
    } else {
        NSLog(@"MdReqUserLoginResult error: %@", [UPErrorUtil errorWithRspInfo:pRspInfo]);
    }
    
    if ([self requestStatus:MdLogedin]) {
        NSLog(@"MdReqUserLoginResult Login Successed");
    } else {
        NSLog(@"MdReqUserLoginResult error: %@", [UPErrorUtil errorWithRspInfo:pRspInfo]);
    }
}

#pragma mark - Md Logout

- (void)mdReqUserLogout:(NSString *)userID brokerID:(NSString *)brokerID nRequestID:(int)nRequestID {
    KingstarAPI::CThostFtdcUserLogoutField logoutReq;
    memset(&logoutReq, 0, sizeof(logoutReq));
    strcpy(logoutReq.UserID, [self string2Char:userID]);
    strcpy(logoutReq.BrokerID, [self string2Char:brokerID]);
    int rt;
    if (UPCTPRealTrade == self.tradeType) {
        rt = NULL != mdApi ? mdApi->ReqUserLogout(&logoutReq, nRequestID) : -1;
    } else {
        rt = NULL != mdSimApi ? mdSimApi->ReqUserLogout(&logoutReq, nRequestID) : -1;
    }
    
    if (!rt) {
        NSLog(@">>>>>>发送行情登出请求成功");
    } else {
        NSLog(@"--->>>发送行情登出请求失败");
        [self mdReqUserLogoutResult:[self rspInfoModel:UPCTPTradeError_SendCTPLogoutRequestFailed errorID:UPCTPTradeErrorCode_SendCTPLogoutRequestFailed nRequestID:nRequestID]];
    }
}

- (void)mdReqUserLogoutResult:(UPRspInfoModel *)pRspInfo {
    [self resetRequestStatus:MdLogedin];
}

#pragma mark - Subscribe Market Data

- (BOOL)isInstrumentsArraySameToSubScribeMarketDatas:(NSArray *)instrumentIDs {
    if (self.subScribeMarketDatas.count == 0) {
        return NO;
    }
    
    if (self.subScribeMarketDatas.count == instrumentIDs.count) {
        NSArray *tmpSubScribeDatas = [self.subScribeMarketDatas copy];
        NSArray *tmpInstrumentIDs = [instrumentIDs copy];
        
        tmpSubScribeDatas = [tmpSubScribeDatas sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        
        tmpInstrumentIDs = [tmpInstrumentIDs sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        
        for (NSInteger i = 0; i < tmpSubScribeDatas.count; i++) {
            NSString *instrumentID = tmpSubScribeDatas[i];
            if (![instrumentID isEqual:tmpInstrumentIDs[i]]) {
                return NO;
            }
        }
    }
    
    return YES;
}

- (NSArray *)removeRepeatedInstrumentIDs:(NSArray *)instrumentIDs {
    // 先去重
    if (instrumentIDs.count > 0) {
        NSMutableArray *tmpInstrumentIDs = [NSMutableArray array];
        for (NSString *instrumentID in instrumentIDs) {
            if (![tmpInstrumentIDs containsObject:instrumentID]) {
                [tmpInstrumentIDs addObject:instrumentID];
            }
        }
        return [tmpInstrumentIDs copy];
    }
    
    return nil;
}

- (void)subScribeMarketData:(NSArray *)instrumentIDs nRequestID:(int)nRequestID {
    instrumentIDs = [self removeRepeatedInstrumentIDs:[instrumentIDs copy]];
    if ([self requestStatus:MdLogedin] &&
        instrumentIDs.count > 0 &&
        ![self isInstrumentsArraySameToSubScribeMarketDatas:instrumentIDs]) {
        if (self.subScribeMarketDatas.count > 0) {
            [self unSubScribeMarketData:[self.subScribeMarketDatas copy]];
        }
        [self.subScribeMarketDatas removeAllObjects];
        [self.subScribeMarketDatas addObjectsFromArray:instrumentIDs];
        
        int instrumentsCount = (int)instrumentIDs.count;
        char **ppInstrumentID = NULL;
        ppInstrumentID = (char **)malloc(instrumentsCount*sizeof(char *));
        for (int i = 0; i < instrumentsCount; i++) {
            NSString *instrumentID = instrumentIDs[i];
            int count = (int)[instrumentID length];
            ppInstrumentID[i] = (char *)malloc(count);
            strcpy(ppInstrumentID[i], [self string2Char:instrumentID]);
        }
        
        int rt;
        if (UPCTPRealTrade == self.tradeType) {
            rt = NULL != mdApi ? mdApi->SubscribeMarketData(ppInstrumentID, instrumentsCount) : -1;
        } else {
            rt = NULL != mdSimApi ? mdSimApi->SubscribeMarketData(ppInstrumentID, instrumentsCount) : -1;
        }
        
        // 释放内存
        for (int i = 0; i < instrumentsCount; i++) {
            free(ppInstrumentID[i]);
        }
        free(ppInstrumentID);
        
        if (!rt) {
            NSLog(@">>>>>>发送订阅行情请求成功");
        } else {
            NSLog(@">>>>>>发送订阅行情请求失败");
            [self subScribeMarketDataResult:[self rspInfoModel:UPCTPTradeError_SendSubscribeMarketDataRequestFailed errorID:UPCTPTradeErrorCode_SendSubscribeMarketDataRequestFailed nRequestID:0]];
        }
    }
}

- (void)clearScribeMarketDatas {
    [self.subScribeMarketDatas removeAllObjects];
}

- (void)subScribeMarketDataResult:(UPRspInfoModel *)pRspInfo {
    if (pRspInfo) {
        NSLog(@"SubScribeMarketDataResult errorID: %i, error: %@", (int)pRspInfo.ErrorID, pRspInfo.ErrorMsg);
    }
}

- (NSInteger)indexOfMarketDataModel:(UPRspDepthMarketDataModel *)marketDataModel {
    NSInteger index = -1;
    if (![marketDataModel isKindOfClass:[UPRspDepthMarketDataModel class]]) {
        index = -2;
    } else {
        if (self.marketDatas.count > 0) {
            for (NSInteger i = 0; i < self.marketDatas.count; i++) {
                UPRspDepthMarketDataModel *model = self.marketDatas[i];
                if ([model.InstrumentID isEqual:marketDataModel.InstrumentID]) {
                    return i;
                }
            }
        }
    }
    return index;
}

- (void)onRtnDepthMarketData:(UPRspDepthMarketDataModel *)marketDataModel {
    if ([marketDataModel isKindOfClass:[UPRspDepthMarketDataModel class]]) {
        [self.requestQueue receiveResponse:@[marketDataModel] error:nil nRequestID:SUBSCRIBE_MARKETDATA_REQUESTID];
    }
}

- (void)unSubScribeMarketData:(NSArray *)instrumentIDs {
    if ([self requestStatus:MdLogedin] && instrumentIDs.count > 0) {
        int instrumentsCount = (int)instrumentIDs.count;
        char **ppInstrumentID = NULL;
        ppInstrumentID = (char **)malloc(instrumentsCount*sizeof(char *));
        for (int i = 0; i < instrumentsCount; i++) {
            NSString *instrumentID = instrumentIDs[i];
            int count = (int)[instrumentID length];
            ppInstrumentID[i] = (char *)malloc(count);
            strcpy(ppInstrumentID[i], [self string2Char:instrumentID]);
        }
        
        int rt;
        if (UPCTPRealTrade == self.tradeType) {
            rt = NULL != mdApi ? mdApi->UnSubscribeMarketData(ppInstrumentID, instrumentsCount) : -1;
        } else {
            rt = NULL != mdSimApi ? mdSimApi->UnSubscribeMarketData(ppInstrumentID, instrumentsCount) : -1;
        }
        
        // 释放内存
        for (int i = 0; i < instrumentsCount; i++) {
            free(ppInstrumentID[i]);
        }
        free(ppInstrumentID);
        
        if (!rt) {
            NSLog(@">>>>>>发送取消订阅行情请求成功");
        } else {
            NSLog(@">>>>>>发送取消订阅行情请求失败");
            [self unSubScribeMarketDataResult:[self rspInfoModel:UPCTPTradeError_SendSubscribeMarketDataRequestFailed errorID:UPCTPTradeErrorCode_SendSubscribeMarketDataRequestFailed nRequestID:0]];
        }
    }
}

- (void)unSubScribeMarketDataResult:(UPRspInfoModel *)pRspInfo {
    if (pRspInfo) {
        NSLog(@"UnSubScribeMarketDataResult errorID: %i, error: %@", (int)pRspInfo.ErrorID, pRspInfo.ErrorMsg);
    }
}

@end

@implementation UPCThostFtdcTraderUserLoginModel

@end
