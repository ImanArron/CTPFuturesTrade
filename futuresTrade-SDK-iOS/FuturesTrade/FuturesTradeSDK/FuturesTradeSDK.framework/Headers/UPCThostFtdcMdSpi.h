//
//  UPCThostFtdcMdSpi.hpp
//  UPFuturesTrade
//
//  Created by UP-LiuL on 17/9/23.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#ifndef UPCThostFtdcMdSpi_hpp
#define UPCThostFtdcMdSpi_hpp

#include <stdio.h>
#include "KSMdApiEx.h"
#import <UIKit/UIKit.h>

@class UPRspInfoModel;

struct CTPMdStruct;

class UPCThostFtdcMdSpi : public KingstarAPI::CThostFtdcMdSpi
{
    CTPMdStruct *ctpMdStruct;
    // ---- ctp_api部分回调接口 ---- //
public:
    UPCThostFtdcMdSpi(int);
    ~UPCThostFtdcMdSpi();
    
    ///当客户端与交易后台建立起通信连接时（还未登录前），该方法被调用。
    void OnFrontConnected();
    
    ///当客户端与交易后台通信连接断开时，该方法被调用。当发生这个情况后，API会自动重新连接，客户端可不做处理。
    ///@param nReason 错误原因
    ///        0x1001 网络读失败
    ///        0x1002 网络写失败
    ///        0x2001 接收心跳超时
    ///        0x2002 发送心跳失败
    ///        0x2003 收到错误报文
    void OnFrontDisconnected(int nReason);
    
    ///心跳超时警告。当长时间未收到报文时，该方法被调用。
    ///@param nTimeLapse 距离上次接收报文的时间
    void OnHeartBeatWarning(int nTimeLapse);
    
    ///错误应答
    void OnRspError(KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///登录请求响应
    void OnRspUserLogin(KingstarAPI::CThostFtdcRspUserLoginField *pRspUserLogin, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///登出请求响应
    void OnRspUserLogout(KingstarAPI::CThostFtdcUserLogoutField *pUserLogout, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
     
    ///订阅行情应答
    void OnRspSubMarketData(KingstarAPI::CThostFtdcSpecificInstrumentField *pSpecificInstrument, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///取消订阅行情应答
    void OnRspUnSubMarketData(KingstarAPI::CThostFtdcSpecificInstrumentField *pSpecificInstrument, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
    
    ///深度行情通知
    void OnRtnDepthMarketData(KingstarAPI::CThostFtdcDepthMarketDataField *pDepthMarketData);
    
    // ---- 自定义函数 ---- //
public:
    private:
        NSString *char2String(const char *nullTerminatedCString);
        UPRspInfoModel *CThostFtdcRspInfoField2UPRspInfoModel(KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID);
        bool isErrorRspInfo(KingstarAPI::CThostFtdcRspInfoField *pRspInfo); // 是否收到错误信息
};

#endif /* UPCThostFtdcMdSpi_hpp */
