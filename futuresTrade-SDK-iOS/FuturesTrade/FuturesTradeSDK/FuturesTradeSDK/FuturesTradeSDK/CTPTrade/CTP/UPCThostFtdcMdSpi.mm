//
//  UPCThostFtdcMdSpi.cpp
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/23.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#include "UPCThostFtdcMdSpi.h"
#include <iostream>
#import "UPCTPSimRequestQueue.h"

struct CTPMdStruct
{
    UPCThostFtdcTraderService *cthostFtdcTraderService;
};

// MARK: Constructor
UPCThostFtdcMdSpi::UPCThostFtdcMdSpi(int tradeType)
{
    UPCThostFtdcTraderService *service = (0 == tradeType) ? [[UPCTPRequestQueue sharedRequestQueue] cThostFtdcTraderService] : [[UPCTPSimRequestQueue sharedSimRequestQueue] cThostFtdcTraderService];
    ctpMdStruct = new CTPMdStruct;
    ctpMdStruct->cthostFtdcTraderService = service;
}

UPCThostFtdcMdSpi::~UPCThostFtdcMdSpi()
{
    delete ctpMdStruct;
}

// MARK: CTP回调
void UPCThostFtdcMdSpi::OnFrontConnected()
{
    std::cout << "=====CTP行情建立网络连接成功=====" << std::endl;
    [this->ctpMdStruct->cthostFtdcTraderService connectMdCTPResult:YES];
}

void UPCThostFtdcMdSpi::OnFrontDisconnected(int nReason)
{
    std::cout << "=====CTP行情网络连接断开=====" << std::endl;
    [this->ctpMdStruct->cthostFtdcTraderService onMdFrontDisconnected:NO];
}

void UPCThostFtdcMdSpi::OnHeartBeatWarning(int nTimeLapse)
{
    std::cerr << "=====CTP行情网络心跳超时=====" << std::endl;
    std::cerr << "距上次连接时间： " << nTimeLapse << std::endl;
    [this->ctpMdStruct->cthostFtdcTraderService onMdHeartBeatWarning:nTimeLapse];
}

void UPCThostFtdcMdSpi::OnRspError(KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    std::cout << "=====CTP行情建立网络连接失败=====" << std::endl;
    [this->ctpMdStruct->cthostFtdcTraderService connectMdCTPResult:NO];
}

void UPCThostFtdcMdSpi::OnRspUserLogin(KingstarAPI::CThostFtdcRspUserLoginField *pRspUserLogin, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====CTP行情账户登录成功=====" << std::endl;
        
        UPRspUserLoginModel *loginModel = [[UPRspUserLoginModel alloc] init];
        if (NULL != pRspUserLogin) {
            std::cout << "交易日： " << pRspUserLogin->TradingDay << std::endl;
            std::cout << "登录时间： " << pRspUserLogin->LoginTime << std::endl;
            std::cout << "经纪商： " << pRspUserLogin->BrokerID << std::endl;
            std::cout << "帐户名： " << pRspUserLogin->UserID << std::endl;
            
            loginModel.TradingDay = char2String(pRspUserLogin->TradingDay);
            loginModel.LoginTime = char2String(pRspUserLogin->LoginTime);
            loginModel.BrokerID = char2String(pRspUserLogin->BrokerID);
            loginModel.UserID = char2String(pRspUserLogin->UserID);
            loginModel.SystemName = char2String(pRspUserLogin->SystemName);
            loginModel.FrontID = pRspUserLogin->FrontID;
            loginModel.SessionID = pRspUserLogin->SessionID;
            loginModel.MaxOrderRef = char2String(pRspUserLogin->MaxOrderRef);
            loginModel.SHFETime = char2String(pRspUserLogin->SHFETime);
            loginModel.DCETime = char2String(pRspUserLogin->DCETime);
            loginModel.CZCETime = char2String(pRspUserLogin->CZCETime);
            loginModel.FFEXTime = char2String(pRspUserLogin->FFEXTime);
            loginModel.nRequestID = nRequestID;
        }
        [this->ctpMdStruct->cthostFtdcTraderService mdReqUserLoginResult:loginModel pRspInfo:nil];
    }
    else
    {
        std::cout << "=====CTP行情账户登录失败=====" << std::endl;
        [this->ctpMdStruct->cthostFtdcTraderService mdReqUserLoginResult:nil pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
    }
}

void UPCThostFtdcMdSpi::OnRspUserLogout(KingstarAPI::CThostFtdcUserLogoutField *pUserLogout, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====CTP行情账户登出成功=====" << std::endl;
        if (NULL != pUserLogout) {
            std::cout << "经纪商： " << pUserLogout->BrokerID << std::endl;
            std::cout << "帐户名： " << pUserLogout->UserID << std::endl;
        }
    }
    else
    {
        std::cout << "=====CTP行情账户登出失败=====" << std::endl;
    }
    
    [this->ctpMdStruct->cthostFtdcTraderService mdReqUserLogoutResult:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
}

void UPCThostFtdcMdSpi::OnRspSubMarketData(KingstarAPI::CThostFtdcSpecificInstrumentField *pSpecificInstrument, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====订阅行情成功=====" << std::endl;
        if (NULL != pSpecificInstrument) {
            std::cout << "合约代码： " << pSpecificInstrument->InstrumentID << std::endl;
        }
        [this->ctpMdStruct->cthostFtdcTraderService subScribeMarketDataResult:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
    }
    else
    {
        std::cout << "=====订阅行情失败=====" << std::endl;
        [this->ctpMdStruct->cthostFtdcTraderService subScribeMarketDataResult:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
    }
}

void UPCThostFtdcMdSpi::OnRspUnSubMarketData(KingstarAPI::CThostFtdcSpecificInstrumentField *pSpecificInstrument, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====取消订阅行情成功=====" << std::endl;
        if (NULL != pSpecificInstrument) {
            std::cout << "合约代码： " << pSpecificInstrument->InstrumentID << std::endl;
        }
        [this->ctpMdStruct->cthostFtdcTraderService unSubScribeMarketDataResult:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
    }
    else
    {
        std::cout << "=====取消订阅行情失败=====" << std::endl;
        [this->ctpMdStruct->cthostFtdcTraderService unSubScribeMarketDataResult:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
    }
}

void UPCThostFtdcMdSpi::OnRtnDepthMarketData(KingstarAPI::CThostFtdcDepthMarketDataField *pDepthMarketData)
{
    std::cout << "=====行情详情通知=====" << std::endl;
    
    if (NULL != pDepthMarketData) {
        UPRspDepthMarketDataModel *depthMarketDataModel = [[UPRspDepthMarketDataModel alloc] init];
        depthMarketDataModel.TradingDay = char2String(pDepthMarketData->TradingDay);
        depthMarketDataModel.InstrumentID = char2String(pDepthMarketData->InstrumentID);
        depthMarketDataModel.ExchangeID = char2String(pDepthMarketData->ExchangeID);
        depthMarketDataModel.ExchangeInstID = char2String(pDepthMarketData->ExchangeInstID);
        depthMarketDataModel.LastPrice = pDepthMarketData->LastPrice;
        depthMarketDataModel.PreSettlementPrice = pDepthMarketData->PreSettlementPrice;
        depthMarketDataModel.PreClosePrice = pDepthMarketData->PreClosePrice;
        depthMarketDataModel.PreOpenInterest = pDepthMarketData->PreOpenInterest;
        depthMarketDataModel.OpenPrice = pDepthMarketData->OpenPrice;
        depthMarketDataModel.HighestPrice = pDepthMarketData->HighestPrice;
        depthMarketDataModel.LowestPrice = pDepthMarketData->LowestPrice;
        depthMarketDataModel.Volume = pDepthMarketData->Volume;
        depthMarketDataModel.Turnover = pDepthMarketData->Turnover;
        depthMarketDataModel.OpenInterest = pDepthMarketData->OpenInterest;
        depthMarketDataModel.ClosePrice = pDepthMarketData->ClosePrice;
        depthMarketDataModel.SettlementPrice = pDepthMarketData->SettlementPrice;
        depthMarketDataModel.UpperLimitPrice = pDepthMarketData->UpperLimitPrice;
        depthMarketDataModel.LowerLimitPrice = pDepthMarketData->LowerLimitPrice;
        depthMarketDataModel.PreDelta = pDepthMarketData->PreDelta;
        depthMarketDataModel.CurrDelta = pDepthMarketData->CurrDelta;
        depthMarketDataModel.UpdateTime = char2String(pDepthMarketData->UpdateTime);
        depthMarketDataModel.UpdateMillisec = pDepthMarketData->UpdateMillisec;
        depthMarketDataModel.BidPrice1 = pDepthMarketData->BidPrice1;
        depthMarketDataModel.BidVolume1 = pDepthMarketData->BidVolume1;
        depthMarketDataModel.AskPrice1 = pDepthMarketData->AskPrice1;
        depthMarketDataModel.AskVolume1 = pDepthMarketData->AskVolume1;
        depthMarketDataModel.BidPrice2 = pDepthMarketData->BidPrice2;
        depthMarketDataModel.BidVolume2 = pDepthMarketData->BidVolume2;
        depthMarketDataModel.AskPrice2 = pDepthMarketData->AskPrice2;
        depthMarketDataModel.AskVolume2 = pDepthMarketData->AskVolume2;
        depthMarketDataModel.BidPrice3 = pDepthMarketData->BidPrice3;
        depthMarketDataModel.BidVolume3 = pDepthMarketData->BidVolume3;
        depthMarketDataModel.AskPrice3 = pDepthMarketData->AskPrice3;
        depthMarketDataModel.AskVolume3 = pDepthMarketData->AskVolume3;
        depthMarketDataModel.BidPrice4 = pDepthMarketData->BidPrice4;
        depthMarketDataModel.BidVolume4 = pDepthMarketData->BidVolume4;
        depthMarketDataModel.AskPrice4 = pDepthMarketData->AskPrice4;
        depthMarketDataModel.AskVolume4 = pDepthMarketData->AskVolume4;
        depthMarketDataModel.BidPrice5 = pDepthMarketData->BidPrice5;
        depthMarketDataModel.BidVolume5 = pDepthMarketData->BidVolume5;
        depthMarketDataModel.AskPrice5 = pDepthMarketData->AskPrice5;
        depthMarketDataModel.AskVolume5 = pDepthMarketData->AskVolume5;
        depthMarketDataModel.AveragePrice = pDepthMarketData->AveragePrice;
        depthMarketDataModel.ActionDay = char2String(pDepthMarketData->ActionDay);
        [this->ctpMdStruct->cthostFtdcTraderService onRtnDepthMarketData:depthMarketDataModel];
    }
}

// MARK: 自定义函数
NSString *UPCThostFtdcMdSpi::char2String(const char *nullTerminatedCString)
{
    if (NULL != nullTerminatedCString && sizeof(nullTerminatedCString) > 0) {
        NSString *string = [NSString stringWithCString:nullTerminatedCString encoding:NSUTF8StringEncoding];
        if (!string) {
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
            string = [NSString stringWithCString:nullTerminatedCString encoding:enc];
        }
        return string;
    }
    
    return @"";
}


UPRspInfoModel *UPCThostFtdcMdSpi::CThostFtdcRspInfoField2UPRspInfoModel(KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID)
{
    UPRspInfoModel *infoModel = [[UPRspInfoModel alloc] init];
    infoModel.nRequestID = nRequestID;
    if (NULL != pRspInfo) {
        infoModel.ErrorID = pRspInfo->ErrorID;
        infoModel.ErrorMsg = char2String(pRspInfo->ErrorMsg);
    } else {
        infoModel.ErrorID = 0;
        infoModel.ErrorMsg = nil;
    }
    return infoModel;
}

bool UPCThostFtdcMdSpi::isErrorRspInfo(KingstarAPI::CThostFtdcRspInfoField *pRspInfo)
{
    bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
    if (bResult)
        std::cerr << "返回错误--->>> ErrorID=" << pRspInfo->ErrorID << ", ErrorMsg=" << pRspInfo->ErrorMsg << std::endl;
    return bResult;
}
