//
//  UPCThostFtdcTraderSpi.hpp
//  FuturesTrade
//
//  Created by UP-LiuL on 17/8/11.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#ifndef UPCThostFtdcTraderSpi_hpp
#define UPCThostFtdcTraderSpi_hpp

#include <stdio.h>
#include "KSTraderApiEx.h"

@class UPRspInfoModel;

struct CTPTradeStruct;

class UPCThostFtdcTraderSpi : public KingstarAPI::CThostFtdcTraderSpi
{
    CTPTradeStruct *ctpTradeStruct;
    
// ---- ctp_api部分回调接口 ---- //
public:
    UPCThostFtdcTraderSpi(int);
    ~UPCThostFtdcTraderSpi();
    
    ///当客户端与交易后台建立起通信连接时（还未登录前），该方法被调用。
    void OnFrontConnected();
    
    ///登录请求响应
    void OnRspUserLogin(KingstarAPI::CThostFtdcRspUserLoginField *pRspUserLogin, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///错误应答
    void OnRspError(KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///当客户端与交易后台通信连接断开时，该方法被调用。当发生这个情况后，API会自动重新连接，客户端可不做处理。
    void OnFrontDisconnected(int nReason);
    
    ///心跳超时警告。当长时间未收到报文时，该方法被调用。
    void OnHeartBeatWarning(int nTimeLapse);
    
    ///登出请求响应
    void OnRspUserLogout(KingstarAPI::CThostFtdcUserLogoutField *pUserLogout, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///投资者结算结果确认响应
    void OnRspSettlementInfoConfirm(KingstarAPI::CThostFtdcSettlementInfoConfirmField *pSettlementInfoConfirm, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///请求查询合约响应
    void OnRspQryInstrument(KingstarAPI::CThostFtdcInstrumentField *pInstrument, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///请求查询资金账户响应
    void OnRspQryTradingAccount(KingstarAPI::CThostFtdcTradingAccountField *pTradingAccount, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///请求查询投资者持仓响应
    void OnRspQryInvestorPosition(KingstarAPI::CThostFtdcInvestorPositionField *pInvestorPosition, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    ///请求查询投资者持仓明细响应
    void OnRspQryInvestorPositionDetail(KingstarAPI::CThostFtdcInvestorPositionDetailField *pInvestorPositionDetail, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///请求查询成交响应
    void OnRspQryTrade(KingstarAPI::CThostFtdcTradeField *pTrade, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///报单录入请求响应
    void OnRspOrderInsert(KingstarAPI::CThostFtdcInputOrderField *pInputOrder, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///报单操作请求响应
    void OnRspOrderAction(KingstarAPI::CThostFtdcInputOrderActionField *pInputOrderAction, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///报单通知
    void OnRtnOrder(KingstarAPI::CThostFtdcOrderField *pOrder);
    
    ///成交通知
    void OnRtnTrade(KingstarAPI::CThostFtdcTradeField *pTrade);
    
    ///请求查询行情响应
    void OnRspQryDepthMarketData(KingstarAPI::CThostFtdcDepthMarketDataField *pDepthMarketData, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///请求查询合约保证金率响应
    void OnRspQryInstrumentMarginRate(KingstarAPI::CThostFtdcInstrumentMarginRateField *pInstrumentMarginRate, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询报单响应
    void OnRspQryOrder(KingstarAPI::CThostFtdcOrderField *pOrder, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///请求查询转帐银行响应
    void OnRspQryTransferBank(KingstarAPI::CThostFtdcTransferBankField *pTransferBank, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///请求查询转帐流水响应
    void OnRspQryTransferSerial(KingstarAPI::CThostFtdcTransferSerialField *pTransferSerial, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///请求查询银期签约关系响应
    void OnRspQryAccountregister(KingstarAPI::CThostFtdcAccountregisterField *pAccountregister, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///期货发起银行资金转期货应答
    void OnRspFromBankToFutureByFuture(KingstarAPI::CThostFtdcReqTransferField *pReqTransfer, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///期货发起期货资金转银行应答
    void OnRspFromFutureToBankByFuture(KingstarAPI::CThostFtdcReqTransferField *pReqTransfer, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///期货发起查询银行余额应答
    void OnRspQueryBankAccountMoneyByFuture(KingstarAPI::CThostFtdcReqQueryAccountField *pReqQueryAccount, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///期货发起查询银行余额通知
    void OnRtnQueryBankBalanceByFuture(KingstarAPI::CThostFtdcNotifyQueryAccountField *pNotifyQueryAccount);
    
    // ---- 自定义函数 ---- //
public:
    private:
        UPRspInfoModel *CThostFtdcRspInfoField2UPRspInfoModel(KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID);
        bool isErrorRspInfo(KingstarAPI::CThostFtdcRspInfoField *pRspInfo); // 是否收到错误信息
};

#endif /* UPCThostFtdcTraderSpi_hpp */
