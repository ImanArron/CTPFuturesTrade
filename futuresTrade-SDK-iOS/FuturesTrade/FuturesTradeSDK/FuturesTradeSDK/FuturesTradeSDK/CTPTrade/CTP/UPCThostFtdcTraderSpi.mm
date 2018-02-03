//
//  UPCThostFtdcTraderSpi.cpp
//  FuturesTrade
//
//  Created by LiuLian on 17/8/11.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#include "UPCThostFtdcTraderSpi.h"
#include <iostream>
#import "UPCTPSimRequestQueue.h"

struct CTPTradeStruct
{
    UPCThostFtdcTraderService *cthostFtdcTraderService;
};

// MARK: Constructor
UPCThostFtdcTraderSpi::UPCThostFtdcTraderSpi(int tradeType)
{
    UPCThostFtdcTraderService *service = (0 == tradeType) ? [[UPCTPRequestQueue sharedRequestQueue] cThostFtdcTraderService] : [[UPCTPSimRequestQueue sharedSimRequestQueue] cThostFtdcTraderService];
    ctpTradeStruct = new CTPTradeStruct;
    ctpTradeStruct->cthostFtdcTraderService = service;
}

UPCThostFtdcTraderSpi::~UPCThostFtdcTraderSpi()
{
    delete ctpTradeStruct;
}

// MARK: Char to String
NSString *char2String(const char *nullTerminatedCString)
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

// MARK: CTP回调
void UPCThostFtdcTraderSpi::OnFrontConnected()
{
    std::cout << "=====建立网络连接成功=====" << std::endl;
    [this->ctpTradeStruct->cthostFtdcTraderService connectCTPResult:YES];
}

void UPCThostFtdcTraderSpi::OnRspError(KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    std::cout << "=====建立网络连接失败=====" << std::endl;
    [this->ctpTradeStruct->cthostFtdcTraderService connectCTPResult:NO];
}

void UPCThostFtdcTraderSpi::OnFrontDisconnected(int nReason)
{
    std::cerr << "=====网络连接断开=====" << std::endl;
    std::cerr << "错误码： " << nReason << std::endl;
    [this->ctpTradeStruct->cthostFtdcTraderService onFrontDisconnected:nReason];
}

void UPCThostFtdcTraderSpi::OnHeartBeatWarning(int nTimeLapse)
{
    std::cerr << "=====网络心跳超时=====" << std::endl;
    std::cerr << "距上次连接时间： " << nTimeLapse << std::endl;
    [this->ctpTradeStruct->cthostFtdcTraderService onHeartBeatWarning:nTimeLapse];
}

void UPCThostFtdcTraderSpi::OnRspUserLogin(
                                           KingstarAPI::CThostFtdcRspUserLoginField *pRspUserLogin,
                                           KingstarAPI::CThostFtdcRspInfoField *pRspInfo,
                                           int nRequestID,
                                           bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====账户登录成功=====" << std::endl;
        
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
        [this->ctpTradeStruct->cthostFtdcTraderService reqUserLoginResult:loginModel pRspInfo:nil];
    }
    else
    {
        [this->ctpTradeStruct->cthostFtdcTraderService reqUserLoginResult:nil pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
    }
}

void UPCThostFtdcTraderSpi::OnRspUserLogout(
                                     KingstarAPI::CThostFtdcUserLogoutField *pUserLogout,
                                     KingstarAPI::CThostFtdcRspInfoField *pRspInfo,
                                     int nRequestID,
                                     bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====账户登出成功=====" << std::endl;
        if (NULL != pUserLogout) {
            std::cout << "经纪商： " << pUserLogout->BrokerID << std::endl;
            std::cout << "帐户名： " << pUserLogout->UserID << std::endl;
        }
    }
    
    [this->ctpTradeStruct->cthostFtdcTraderService reqUserLogoutResult:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
}

void UPCThostFtdcTraderSpi::OnRspSettlementInfoConfirm(
                                                KingstarAPI::CThostFtdcSettlementInfoConfirmField *pSettlementInfoConfirm,
                                                KingstarAPI::CThostFtdcRspInfoField *pRspInfo,
                                                int nRequestID,
                                                bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====投资者结算结果确认成功=====" << std::endl;
        std::cout << "确认日期： " << pSettlementInfoConfirm->ConfirmDate << std::endl;
        std::cout << "确认时间： " << pSettlementInfoConfirm->ConfirmTime << std::endl;
    }
    else
    {
        std::cout << "=====投资者结算结果确认失败=====" << std::endl;
    }
}

NSMutableArray *instruments;
void UPCThostFtdcTraderSpi::OnRspQryInstrument(
                                        KingstarAPI::CThostFtdcInstrumentField *pInstrument,
                                        KingstarAPI::CThostFtdcRspInfoField *pRspInfo,
                                        int nRequestID,
                                        bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
//        std::cout << "=====查询合约结果成功=====" << std::endl;
        
        if (!instruments) {
            instruments = [NSMutableArray array];
        }
        
        UPRspInstrumentModel *instrumentModel = [[UPRspInstrumentModel alloc] init];
        if (NULL != pInstrument) {
//            std::cout << "交易所代码： " << pInstrument->ExchangeID << std::endl;
//            std::cout << "合约代码： " << pInstrument->InstrumentID << std::endl;
//            std::cout << "合约在交易所的代码： " << pInstrument->ExchangeInstID << std::endl;
//            std::cout << "到期日： " << pInstrument->EndDelivDate << std::endl;
//            std::cout << "当前交易状态： " << pInstrument->IsTrading << std::endl;
            
            instrumentModel.InstrumentID = char2String(pInstrument->InstrumentID);
            instrumentModel.ExchangeID = char2String(pInstrument->ExchangeID);
            instrumentModel.InstrumentName = char2String(pInstrument->InstrumentName);
            instrumentModel.ExchangeInstID = char2String(pInstrument->ExchangeInstID);
            instrumentModel.ProductID = char2String(pInstrument->ProductID);
            instrumentModel.ProductClass = pInstrument->ProductClass;
            instrumentModel.DeliveryYear = pInstrument->DeliveryYear;
            instrumentModel.DeliveryMonth = pInstrument->DeliveryMonth;
            instrumentModel.MaxMarketOrderVolume = pInstrument->MaxMarketOrderVolume;
            instrumentModel.MinMarketOrderVolume = pInstrument->MinMarketOrderVolume;
            instrumentModel.MaxLimitOrderVolume = pInstrument->MaxLimitOrderVolume;
            instrumentModel.MinLimitOrderVolume = pInstrument->MinLimitOrderVolume;
            instrumentModel.VolumeMultiple = pInstrument->VolumeMultiple;
            instrumentModel.PriceTick = pInstrument->PriceTick;
            instrumentModel.CreateDate = char2String(pInstrument->CreateDate);
            instrumentModel.OpenDate = char2String(pInstrument->OpenDate);
            instrumentModel.ExpireDate = char2String(pInstrument->ExpireDate);
            instrumentModel.StartDelivDate = char2String(pInstrument->StartDelivDate);
            instrumentModel.EndDelivDate = char2String(pInstrument->EndDelivDate);
            instrumentModel.InstLifePhase = pInstrument->InstLifePhase;
            instrumentModel.IsTrading = pInstrument->IsTrading;
            instrumentModel.PositionType = pInstrument->PositionType;
            instrumentModel.PositionDateType = pInstrument->PositionDateType;
            instrumentModel.LongMarginRatio = pInstrument->LongMarginRatio;
            instrumentModel.ShortMarginRatio = pInstrument->ShortMarginRatio;
            [instruments addObject:instrumentModel];
        }
        
        if (bIsLast) {
            [this->ctpTradeStruct->cthostFtdcTraderService reqQueryInstrumentsResult:[instruments copy]];
            instruments = nil;
        }
    }
    else
    {
        std::cout << "=====查询合约结果失败=====" << std::endl;
        instruments = nil;
    }
}

void UPCThostFtdcTraderSpi::OnRspQryTradingAccount(
                                            KingstarAPI::CThostFtdcTradingAccountField *pTradingAccount,
                                            KingstarAPI::CThostFtdcRspInfoField *pRspInfo,
                                            int nRequestID,
                                            bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====查询投资者资金账户成功=====" << std::endl;
        
        UPRspTradingAccountModel *tradingAccount = [[UPRspTradingAccountModel alloc] init];
        if (NULL != pTradingAccount) {
            std::cout << "投资者账号： " << pTradingAccount->AccountID << std::endl;
            std::cout << "可用资金： " << pTradingAccount->Available << std::endl;
            std::cout << "可取资金： " << pTradingAccount->WithdrawQuota << std::endl;
            std::cout << "当前保证金: " << pTradingAccount->CurrMargin << std::endl;
            std::cout << "平仓盈亏： " << pTradingAccount->CloseProfit << std::endl;
            
            tradingAccount.BrokerID = char2String(pTradingAccount->BrokerID);
            tradingAccount.AccountID = char2String(pTradingAccount->AccountID);
            tradingAccount.PreMortgage = pTradingAccount->PreMortgage;
            tradingAccount.PreCredit = pTradingAccount->PreCredit;
            tradingAccount.PreDeposit = pTradingAccount->PreDeposit;
            tradingAccount.PreBalance = pTradingAccount->PreBalance;
            tradingAccount.PreMargin = pTradingAccount->PreMargin;
            tradingAccount.InterestBase = pTradingAccount->InterestBase;
            tradingAccount.Interest = pTradingAccount->Interest;
            tradingAccount.Deposit = pTradingAccount->Deposit;
            tradingAccount.Withdraw = pTradingAccount->Withdraw;
            tradingAccount.FrozenMargin = pTradingAccount->FrozenMargin;
            tradingAccount.FrozenCash = pTradingAccount->FrozenCash;
            tradingAccount.FrozenCommission = pTradingAccount->FrozenCommission;
            tradingAccount.CurrMargin = pTradingAccount->CurrMargin;
            tradingAccount.CashIn = pTradingAccount->CashIn;
            tradingAccount.Commission = pTradingAccount->Commission;
            tradingAccount.CloseProfit = pTradingAccount->CloseProfit;
            tradingAccount.PositionProfit = pTradingAccount->PositionProfit;
            tradingAccount.Balance = pTradingAccount->Balance;
            tradingAccount.Available = pTradingAccount->Available;
            tradingAccount.WithdrawQuota = pTradingAccount->WithdrawQuota;
            tradingAccount.Reserve = pTradingAccount->Reserve;
            tradingAccount.TradingDay = char2String(pTradingAccount->TradingDay);
            tradingAccount.SettlementID = pTradingAccount->SettlementID;
            tradingAccount.Credit = pTradingAccount->Credit;
            tradingAccount.Mortgage = pTradingAccount->Mortgage;
            tradingAccount.ExchangeMargin = pTradingAccount->ExchangeMargin;
            tradingAccount.DeliveryMargin = pTradingAccount->DeliveryMargin;
            tradingAccount.ExchangeDeliveryMargin = pTradingAccount->ExchangeDeliveryMargin;
            tradingAccount.nRequestID = nRequestID;
        }
        
        [this->ctpTradeStruct->cthostFtdcTraderService reqQueryTradingAccountResult:tradingAccount pRspInfo:nil];
    }
    else
    {
        std::cout << "=====查询投资者资金账户失败=====" << std::endl;
        [this->ctpTradeStruct->cthostFtdcTraderService reqQueryTradingAccountResult:nil pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
    }
}

NSMutableArray *investorPositions;
void UPCThostFtdcTraderSpi::OnRspQryInvestorPosition(
                                              KingstarAPI::CThostFtdcInvestorPositionField *pInvestorPosition,
                                              KingstarAPI::CThostFtdcRspInfoField *pRspInfo,
                                              int nRequestID,
                                              bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====查询投资者持仓成功=====" << std::endl;
        if (pInvestorPosition)
        {
            if (NULL != pInvestorPosition) {
                std::cout << "合约代码： " << pInvestorPosition->InstrumentID << std::endl;
                std::cout << "开仓价格： " << pInvestorPosition->OpenAmount << std::endl;
                std::cout << "开仓量： " << pInvestorPosition->OpenVolume << std::endl;
                std::cout << "开仓方向： " << pInvestorPosition->PosiDirection << std::endl;
                std::cout << "占用保证金：" << pInvestorPosition->UseMargin << std::endl;
            }
        }
        else
        {
            std::cout << "----->该合约未持仓" << std::endl;
        }
        
        // 策略交易
        std::cout << "=====开始进入策略交易=====" << std::endl;
        
        if (!investorPositions) {
            investorPositions = [NSMutableArray array];
        }
        
        if (NULL != pInvestorPosition) {
            UPRspInvestorPositionModel *investorPosition = [[UPRspInvestorPositionModel alloc] init];
            investorPosition.InstrumentID = char2String(pInvestorPosition->InstrumentID);
            investorPosition.BrokerID = char2String(pInvestorPosition->BrokerID);
            investorPosition.InvestorID = char2String(pInvestorPosition->InvestorID);
            investorPosition.PosiDirection = pInvestorPosition->PosiDirection;
            investorPosition.HedgeFlag = pInvestorPosition->HedgeFlag;
            investorPosition.PositionDate = pInvestorPosition->PositionDate;
            investorPosition.YdPosition = pInvestorPosition->YdPosition;
            investorPosition.Position = pInvestorPosition->Position;
            investorPosition.LongFrozen = pInvestorPosition->LongFrozen;
            investorPosition.ShortFrozen = pInvestorPosition->ShortFrozen;
            investorPosition.LongFrozenAmount = pInvestorPosition->LongFrozenAmount;
            investorPosition.ShortFrozenAmount = pInvestorPosition->ShortFrozenAmount;
            investorPosition.OpenVolume = pInvestorPosition->OpenVolume;
            investorPosition.CloseVolume = pInvestorPosition->CloseVolume;
            investorPosition.OpenAmount = pInvestorPosition->OpenAmount;
            investorPosition.CloseAmount = pInvestorPosition->CloseAmount;
            investorPosition.PositionCost = pInvestorPosition->PositionCost;
            investorPosition.PreMargin = pInvestorPosition->PreMargin;
            investorPosition.UseMargin = pInvestorPosition->UseMargin;
            investorPosition.FrozenMargin = pInvestorPosition->FrozenMargin;
            investorPosition.FrozenCash = pInvestorPosition->FrozenCash;
            investorPosition.FrozenCommission = pInvestorPosition->FrozenCommission;
            investorPosition.CashIn = pInvestorPosition->CashIn;
            investorPosition.Commission = pInvestorPosition->Commission;
            investorPosition.CloseProfit = pInvestorPosition->CloseProfit;
            investorPosition.PositionProfit = pInvestorPosition->PositionProfit;
            investorPosition.PreSettlementPrice = pInvestorPosition->PreSettlementPrice;
            investorPosition.SettlementPrice = pInvestorPosition->SettlementPrice;
            investorPosition.TradingDay = char2String(pInvestorPosition->TradingDay);
            investorPosition.SettlementID = pInvestorPosition->SettlementID;
            investorPosition.OpenCost = pInvestorPosition->OpenCost;
            investorPosition.ExchangeMargin = pInvestorPosition->ExchangeMargin;
            investorPosition.CombPosition = pInvestorPosition->CombPosition;
            investorPosition.CombLongFrozen = pInvestorPosition->CombLongFrozen;
            investorPosition.CombShortFrozen = pInvestorPosition->CombShortFrozen;
            investorPosition.CloseProfitByDate = pInvestorPosition->CloseProfitByDate;
            investorPosition.CloseProfitByTrade = pInvestorPosition->CloseProfitByTrade;
            investorPosition.TodayPosition = pInvestorPosition->TodayPosition;
            investorPosition.MarginRateByMoney = pInvestorPosition->MarginRateByMoney;
            investorPosition.MarginRateByVolume = pInvestorPosition->MarginRateByVolume;
            investorPosition.nRequestID = nRequestID;
            [investorPositions addObject:investorPosition];
        }
        
        if (bIsLast) {
            [this->ctpTradeStruct->cthostFtdcTraderService reqQueryInvestorPositionResult:[investorPositions copy] pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
            investorPositions = nil;
        }
    }
    else
    {
        std::cout << "=====查询投资者持仓失败=====" << std::endl;
        [this->ctpTradeStruct->cthostFtdcTraderService reqQueryInvestorPositionResult:nil pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
        investorPositions = nil;
    }
}

NSMutableArray *investorPositionDetails;
void UPCThostFtdcTraderSpi::OnRspQryInvestorPositionDetail(
                                                           KingstarAPI::CThostFtdcInvestorPositionDetailField *pInvestorPositionDetail,
                                                           KingstarAPI::CThostFtdcRspInfoField *pRspInfo,
                                                           int nRequestID,
                                                           bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====查询投资者持仓明细成功=====" << std::endl;
        if (pInvestorPositionDetail)
        {
            std::cout << "合约代码： " << pInvestorPositionDetail->InstrumentID << std::endl;
        }
        else
        {
            
        }
        
        
        if (!investorPositionDetails) {
            investorPositionDetails = [NSMutableArray array];
        }
        
        if (NULL != pInvestorPositionDetail) {
            UPRspInvestorPositionDetailModel *investorPosition = [[UPRspInvestorPositionDetailModel alloc] init];
            investorPosition.InstrumentID = char2String(pInvestorPositionDetail->InstrumentID);
            investorPosition.BrokerID = char2String(pInvestorPositionDetail->BrokerID);
            investorPosition.InvestorID = char2String(pInvestorPositionDetail->InvestorID);
            investorPosition.HedgeFlag = pInvestorPositionDetail->HedgeFlag;
            investorPosition.Direction = pInvestorPositionDetail->Direction;
            investorPosition.OpenDate = char2String(pInvestorPositionDetail->OpenDate);
            investorPosition.TradeID = char2String(pInvestorPositionDetail->TradeID);
            investorPosition.Volume = pInvestorPositionDetail->Volume;
            investorPosition.OpenPrice = pInvestorPositionDetail->OpenPrice;
            investorPosition.TradingDay = char2String(pInvestorPositionDetail->TradingDay);
            investorPosition.SettlementID = pInvestorPositionDetail->SettlementID;
            investorPosition.TradeType = pInvestorPositionDetail->TradeType;
            investorPosition.CombInstrumentID = char2String(pInvestorPositionDetail->CombInstrumentID);
            investorPosition.ExchangeID = char2String(pInvestorPositionDetail->ExchangeID);
            investorPosition.CloseProfitByDate = pInvestorPositionDetail->CloseProfitByDate;
            investorPosition.CloseProfitByTrade = pInvestorPositionDetail->CloseProfitByTrade;
            investorPosition.PositionProfitByDate = pInvestorPositionDetail->PositionProfitByDate;
            investorPosition.PositionProfitByTrade = pInvestorPositionDetail->PositionProfitByTrade;
            investorPosition.Margin = pInvestorPositionDetail->Margin;
            investorPosition.ExchMargin = pInvestorPositionDetail->ExchMargin;
            investorPosition.MarginRateByMoney = pInvestorPositionDetail->MarginRateByMoney;
            investorPosition.MarginRateByVolume = pInvestorPositionDetail->MarginRateByVolume;
            investorPosition.LastSettlementPrice = pInvestorPositionDetail->LastSettlementPrice;
            investorPosition.SettlementPrice = pInvestorPositionDetail->SettlementPrice;
            investorPosition.CloseVolume = pInvestorPositionDetail->CloseVolume;
            investorPosition.CloseAmount = pInvestorPositionDetail->CloseAmount;
            investorPosition.nRequestID = nRequestID;
            [investorPositionDetails addObject:investorPosition];
        }
        
        if (bIsLast) {
            [this->ctpTradeStruct->cthostFtdcTraderService reqQueryInvestorPositionDetailResult:[investorPositionDetails copy] pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
            investorPositionDetails = nil;
        }
    }
    else
    {
        std::cout << "=====查询投资者持仓明细失败=====" << std::endl;
        [this->ctpTradeStruct->cthostFtdcTraderService reqQueryInvestorPositionDetailResult:nil pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
        investorPositionDetails = nil;
    }
}

NSMutableArray *trades;
void UPCThostFtdcTraderSpi::OnRspQryTrade(
                                          KingstarAPI::CThostFtdcTradeField *pTrade,
                                          KingstarAPI::CThostFtdcRspInfoField *pRspInfo,
                                          int nRequestID,
                                          bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====查询投资者成交成功=====" << std::endl;
        
        if (!trades) {
            trades = [NSMutableArray array];
        }
        
        if (NULL != pTrade) {
            std::cout << "合约代码： " << pTrade->InstrumentID << std::endl;
            
            UPRspTradeModel *trade = [[UPRspTradeModel alloc] init];
            trade.BrokerID = char2String(pTrade->BrokerID);
            trade.InvestorID = char2String(pTrade->InvestorID);
            trade.InstrumentID = char2String(pTrade->InstrumentID);
            trade.OrderRef = char2String(pTrade->OrderRef);
            trade.UserID = char2String(pTrade->UserID);
            trade.ExchangeID = char2String(pTrade->ExchangeID);
            trade.TradeID = char2String(pTrade->TradeID);
            trade.Direction = pTrade->Direction;
            trade.OrderSysID = char2String(pTrade->OrderSysID);
            trade.ParticipantID = char2String(pTrade->ParticipantID);
            trade.ClientID = char2String(pTrade->ClientID);
            trade.TradingRole = pTrade->TradingRole;
            trade.ExchangeInstID = char2String(pTrade->ExchangeInstID);
            trade.OffsetFlag = pTrade->OffsetFlag;
            trade.HedgeFlag = pTrade->HedgeFlag;
            trade.Price = pTrade->Price;
            trade.Volume = pTrade->Volume;
            trade.TradeDate = char2String(pTrade->TradeDate);
            trade.TradeTime = char2String(pTrade->TradeTime);
            trade.TradeType = pTrade->TradeType;
            trade.PriceSource = pTrade->PriceSource;
            trade.TraderID = char2String(pTrade->TraderID);
            trade.OrderLocalID = char2String(pTrade->OrderLocalID);
            trade.ClearingPartID = char2String(pTrade->ClearingPartID);
            trade.BusinessUnit = char2String(pTrade->BusinessUnit);
            trade.SequenceNo = pTrade->SequenceNo;
            trade.TradingDay = char2String(pTrade->TradingDay);
            trade.SettlementID = pTrade->SettlementID;
            trade.BrokerOrderSeq = pTrade->BrokerOrderSeq;
            trade.TradeSource = pTrade->TradeSource;
            trade.nRequestID = nRequestID;
            [trades addObject:trade];
        }
        
        if (bIsLast) {
            [trades sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                UPRspTradeModel *trade1 = obj1;
                UPRspTradeModel *trade2 = obj2;
                return [[trade2.TradingDay stringByAppendingString:trade2.TradeTime] compare:[trade1.TradingDay stringByAppendingString:trade1.TradeTime]];
            }];
            [this->ctpTradeStruct->cthostFtdcTraderService reqQueryTradeResult:[trades copy] pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
            trades = nil;
        }
    }
    else
    {
        std::cout << "=====查询投资者成交失败=====" << std::endl;
        [this->ctpTradeStruct->cthostFtdcTraderService reqQueryInvestorPositionResult:nil pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
        trades = nil;
    }
}

void UPCThostFtdcTraderSpi::OnRspOrderInsert(
                                      KingstarAPI::CThostFtdcInputOrderField *pInputOrder,
                                      KingstarAPI::CThostFtdcRspInfoField *pRspInfo,
                                      int nRequestID,
                                      bool bIsLast)
{
    std::cout << "=====OnRspOrderInsert=====" << std::endl;
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====报单录入成功=====" << std::endl;
        
        if (NULL != pInputOrder) {
            std::cout << "合约代码： " << pInputOrder->InstrumentID << std::endl;
            std::cout << "价格： " << pInputOrder->LimitPrice << std::endl;
            std::cout << "数量： " << pInputOrder->VolumeTotalOriginal << std::endl;
            std::cout << "开仓方向： " << pInputOrder->Direction << std::endl;
            
            UPRspOrderInsertModel *pRspOrderInsert = [[UPRspOrderInsertModel alloc] init];
            pRspOrderInsert.BrokerID = char2String(pInputOrder->BrokerID);
            pRspOrderInsert.InvestorID = char2String(pInputOrder->InvestorID);
            pRspOrderInsert.InstrumentID = char2String(pInputOrder->InstrumentID);
            pRspOrderInsert.OrderRef = char2String(pInputOrder->OrderRef);
            pRspOrderInsert.UserID = char2String(pInputOrder->UserID);
            pRspOrderInsert.OrderPriceType = pInputOrder->OrderPriceType;
            pRspOrderInsert.Direction = pInputOrder->Direction;
            pRspOrderInsert.CombOffsetFlag = char2String(pInputOrder->CombOffsetFlag);
            pRspOrderInsert.CombHedgeFlag = char2String(pInputOrder->CombHedgeFlag);
            pRspOrderInsert.LimitPrice = pInputOrder->LimitPrice;
            pRspOrderInsert.VolumeTotalOriginal = pInputOrder->VolumeTotalOriginal;
            pRspOrderInsert.TimeCondition = pInputOrder->TimeCondition;
            pRspOrderInsert.GTDDate = char2String(pInputOrder->GTDDate);
            pRspOrderInsert.VolumeCondition = pInputOrder->VolumeCondition;
            pRspOrderInsert.MinVolume = pInputOrder->MinVolume;
            pRspOrderInsert.ContingentCondition = pInputOrder->ContingentCondition;
            pRspOrderInsert.StopPrice = pInputOrder->StopPrice;
            pRspOrderInsert.ForceCloseReason = pInputOrder->ForceCloseReason;
            pRspOrderInsert.IsAutoSuspend = pInputOrder->IsAutoSuspend;
            pRspOrderInsert.BusinessUnit = char2String(pInputOrder->BusinessUnit);
            pRspOrderInsert.RequestID = pInputOrder->RequestID;
            pRspOrderInsert.UserForceClose = pInputOrder->UserForceClose;
            pRspOrderInsert.IsSwapOrder = pInputOrder->IsSwapOrder;
            pRspOrderInsert.nRequestID = nRequestID;
        }
        
//        [this->ctpTradeStruct->cthostFtdcTraderService reqOrderInsertResult:pRspOrderInsert pRspInfo:nil];
    }
    else
    {
        [this->ctpTradeStruct->cthostFtdcTraderService reqOrderInsertResult:nil pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
    }
}

void UPCThostFtdcTraderSpi::OnRtnOrder(KingstarAPI::CThostFtdcOrderField *pOrder)
{
    char str[10];
    sprintf(str, "%d", pOrder->OrderSubmitStatus);
    int orderState = atoi(str) - 48;	//报单状态0=已经提交，3=已经接受
    sprintf(str, "%d", orderState);
    std::cout << "=====报单状态=====: " << orderState << std::endl;
    std::cout << "=====收到报单应答=====" << std::endl;
    
    UPRspOrderModel *order = [[UPRspOrderModel alloc] init];
    if (NULL != pOrder) {
        order.BrokerID = char2String(pOrder->BrokerID);
        order.InvestorID = char2String(pOrder->InvestorID);
        order.InstrumentID = char2String(pOrder->InstrumentID);
        order.OrderRef = char2String(pOrder->OrderRef);
        order.UserID = char2String(pOrder->UserID);
        order.OrderPriceType = pOrder->OrderPriceType;
        order.Direction = pOrder->Direction;
        order.CombOffsetFlag = char2String(pOrder->CombOffsetFlag);
        order.CombHedgeFlag = char2String(pOrder->CombHedgeFlag);
        order.LimitPrice = pOrder->LimitPrice;
        order.VolumeTotalOriginal = pOrder->VolumeTotalOriginal;
        order.TimeCondition = pOrder->TimeCondition;
        order.GTDDate = char2String(pOrder->GTDDate);
        order.VolumeCondition = pOrder->VolumeCondition;
        order.MinVolume = pOrder->MinVolume;
        order.ContingentCondition = pOrder->ContingentCondition;
        order.StopPrice = pOrder->StopPrice;
        order.ForceCloseReason = pOrder->ForceCloseReason;
        order.IsAutoSuspend = pOrder->IsAutoSuspend;
        order.BusinessUnit = char2String(pOrder->BusinessUnit);
        order.RequestID = pOrder->RequestID;
        order.IsAutoSuspend = pOrder->RequestID;
        order.OrderLocalID = char2String(pOrder->OrderLocalID);
        order.ExchangeID = char2String(pOrder->ExchangeID);
        order.ParticipantID = char2String(pOrder->ParticipantID);
        order.ClientID = char2String(pOrder->ClientID);
        order.ExchangeInstID = char2String(pOrder->ExchangeInstID);
        order.TraderID = char2String(pOrder->TraderID);
        order.InstallID = pOrder->InstallID;
        order.OrderSubmitStatus = pOrder->OrderSubmitStatus;
        order.NotifySequence = pOrder->NotifySequence;
        order.TradingDay = char2String(pOrder->TradingDay);
        order.SettlementID = pOrder->SettlementID;
        order.OrderSysID = char2String(pOrder->OrderSysID);
        order.OrderSource = pOrder->OrderSource;
        order.OrderStatus = pOrder->OrderStatus;
        order.OrderType = pOrder->OrderType;
        order.VolumeTraded = pOrder->VolumeTraded;
        order.VolumeTotal = pOrder->VolumeTotal;
        order.InsertDate = char2String(pOrder->InsertDate);
        order.InsertTime = char2String(pOrder->InsertTime);
        order.ActiveTime = char2String(pOrder->ActiveTime);
        order.SuspendTime = char2String(pOrder->SuspendTime);
        order.UpdateTime = char2String(pOrder->UpdateTime);
        order.CancelTime = char2String(pOrder->CancelTime);
        order.ActiveTraderID = char2String(pOrder->ActiveTraderID);
        order.ClearingPartID = char2String(pOrder->ClearingPartID);
        order.SequenceNo = pOrder->SequenceNo;
        order.FrontID = pOrder->FrontID;
        order.SessionID = pOrder->SessionID;
        order.UserProductInfo = char2String(pOrder->UserProductInfo);
        order.StatusMsg = char2String(pOrder->StatusMsg);
        order.UserForceClose = pOrder->UserForceClose;
        order.ActiveUserID = char2String(pOrder->ActiveUserID);
        order.BrokerOrderSeq = pOrder->BrokerOrderSeq;
        order.RelativeOrderSysID = char2String(pOrder->RelativeOrderSysID);
        order.ZCETotalTradedVolume = pOrder->ZCETotalTradedVolume;
        order.IsSwapOrder = pOrder->IsSwapOrder;
        order.nRequestID = [char2String(pOrder->OrderRef) intValue];
    }
    [this->ctpTradeStruct->cthostFtdcTraderService reqOrderInsertResult:order pRspInfo:nil];
    [[NSNotificationQueue defaultQueue] enqueueNotification:[NSNotification notificationWithName:ORDER_ACTION_NOTIFICATION object:order] postingStyle:NSPostASAP];
}

void UPCThostFtdcTraderSpi::OnRtnTrade(KingstarAPI::CThostFtdcTradeField *pTrade)
{
    std::cout << "=====报单成功成交=====" << std::endl;
    
    UPRspTradeModel *trade = [[UPRspTradeModel alloc] init];
    if (NULL != pTrade) {
        std::cout << "成交时间： " << pTrade->TradeTime << std::endl;
        std::cout << "合约代码： " << pTrade->InstrumentID << std::endl;
        std::cout << "成交价格： " << pTrade->Price << std::endl;
        std::cout << "成交量： " << pTrade->Volume << std::endl;
        std::cout << "开平仓方向： " << pTrade->Direction << std::endl;
        
        trade.BrokerID = char2String(pTrade->BrokerID);
        trade.InvestorID = char2String(pTrade->InvestorID);
        trade.InstrumentID = char2String(pTrade->InstrumentID);
        trade.OrderRef = char2String(pTrade->OrderRef);
        trade.UserID = char2String(pTrade->UserID);
        trade.ExchangeID = char2String(pTrade->ExchangeID);
        trade.TradeID = char2String(pTrade->TradeID);
        trade.Direction = pTrade->Direction;
        trade.OrderSysID = char2String(pTrade->OrderSysID);
        trade.ParticipantID = char2String(pTrade->ParticipantID);
        trade.ClientID = char2String(pTrade->ClientID);
        trade.TradingRole = pTrade->TradingRole;
        trade.ExchangeInstID = char2String(pTrade->ExchangeInstID);
        trade.OffsetFlag = pTrade->OffsetFlag;
        trade.HedgeFlag = pTrade->HedgeFlag;
        trade.Price = pTrade->Price;
        trade.Volume = pTrade->Volume;
        trade.TradeDate = char2String(pTrade->TradeDate);
        trade.TradeTime = char2String(pTrade->TradeTime);
        trade.TradeType = pTrade->TradeType;
        trade.PriceSource = pTrade->PriceSource;
        trade.TraderID = char2String(pTrade->TraderID);
        trade.OrderLocalID = char2String(pTrade->OrderLocalID);
        trade.ClearingPartID = char2String(pTrade->ClearingPartID);
        trade.BusinessUnit = char2String(pTrade->BusinessUnit);
        trade.SequenceNo = pTrade->SequenceNo;
        trade.TradingDay = char2String(pTrade->TradingDay);
        trade.SettlementID = pTrade->SettlementID;
        trade.BrokerOrderSeq = pTrade->BrokerOrderSeq;
        trade.TradeSource = pTrade->TradeSource;
    }
    [[NSNotificationQueue defaultQueue] enqueueNotification:[NSNotification notificationWithName:ORDER_ACTION_NOTIFICATION object:trade] postingStyle:NSPostNow];
}

void UPCThostFtdcTraderSpi::OnRspOrderAction(
                                             KingstarAPI::CThostFtdcInputOrderActionField *pInputOrderAction,
                                             KingstarAPI::CThostFtdcRspInfoField *pRspInfo,
                                             int nRequestID,
                                             bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====报单操作成功=====" << std::endl;
        
        if (bIsLast) {
            UPRspOrderActionModel *actionModel = [[UPRspOrderActionModel alloc] init];
            if (NULL != pInputOrderAction) {
                std::cout << "合约代码： " << pInputOrderAction->InstrumentID << std::endl;
                std::cout << "操作标志： " << pInputOrderAction->ActionFlag;
                
                actionModel.BrokerID = char2String(pInputOrderAction->BrokerID);
                actionModel.InvestorID = char2String(pInputOrderAction->InvestorID);
                actionModel.OrderActionRef = pInputOrderAction->OrderActionRef;
                actionModel.OrderRef = char2String(pInputOrderAction->OrderRef);
                actionModel.RequestID = pInputOrderAction->RequestID;
                actionModel.FrontID = pInputOrderAction->FrontID;
                actionModel.SessionID = pInputOrderAction->SessionID;
                actionModel.ExchangeID = char2String(pInputOrderAction->ExchangeID);
                actionModel.OrderSysID = char2String(pInputOrderAction->OrderSysID);
                actionModel.ActionFlag = pInputOrderAction->ActionFlag;
                actionModel.LimitPrice = pInputOrderAction->LimitPrice;
                actionModel.VolumeChange = pInputOrderAction->VolumeChange;
                actionModel.UserID = char2String(pInputOrderAction->UserID);
                actionModel.InstrumentID = char2String(pInputOrderAction->InstrumentID);
                actionModel.nRequestID = nRequestID;
            }
            
            [this->ctpTradeStruct->cthostFtdcTraderService reqOrderActionResult:actionModel pRspInfo:nil];
        }
    }
    else
    {
        [this->ctpTradeStruct->cthostFtdcTraderService reqOrderActionResult:nil pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
    }
}

NSMutableArray *qryOrders = [NSMutableArray array];
void UPCThostFtdcTraderSpi::OnRspQryOrder(
                                          KingstarAPI::CThostFtdcOrderField *pOrder,
                                          KingstarAPI::CThostFtdcRspInfoField *pRspInfo,
                                          int nRequestID,
                                          bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====查询报单成功=====" << std::endl;
        if (!qryOrders) {
            qryOrders = [NSMutableArray array];
        }
        
        if (NULL != pOrder) {
            UPRspOrderModel *order = [[UPRspOrderModel alloc] init];
            order.BrokerID = char2String(pOrder->BrokerID);
            order.InvestorID = char2String(pOrder->InvestorID);
            order.InstrumentID = char2String(pOrder->InstrumentID);
            order.OrderRef = char2String(pOrder->OrderRef);
            order.UserID = char2String(pOrder->UserID);
            order.OrderPriceType = pOrder->OrderPriceType;
            order.Direction = pOrder->Direction;
            order.CombOffsetFlag = char2String(pOrder->CombOffsetFlag);
            order.CombHedgeFlag = char2String(pOrder->CombHedgeFlag);
            order.LimitPrice = pOrder->LimitPrice;
            order.VolumeTotalOriginal = pOrder->VolumeTotalOriginal;
            order.TimeCondition = pOrder->TimeCondition;
            order.GTDDate = char2String(pOrder->GTDDate);
            order.VolumeCondition = pOrder->VolumeCondition;
            order.MinVolume = pOrder->MinVolume;
            order.ContingentCondition = pOrder->ContingentCondition;
            order.StopPrice = pOrder->StopPrice;
            order.ForceCloseReason = pOrder->ForceCloseReason;
            order.IsAutoSuspend = pOrder->IsAutoSuspend;
            order.BusinessUnit = char2String(pOrder->BusinessUnit);
            order.IsAutoSuspend = pOrder->RequestID;
            order.OrderLocalID = char2String(pOrder->OrderLocalID);
            order.ExchangeID = char2String(pOrder->ExchangeID);
            order.ParticipantID = char2String(pOrder->ParticipantID);
            order.ClientID = char2String(pOrder->ClientID);
            order.ExchangeInstID = char2String(pOrder->ExchangeInstID);
            order.TraderID = char2String(pOrder->TraderID);
            order.InstallID = pOrder->InstallID;
            order.OrderSubmitStatus = pOrder->OrderSubmitStatus;
            order.NotifySequence = pOrder->NotifySequence;
            order.TradingDay = char2String(pOrder->TradingDay);
            order.SettlementID = pOrder->SettlementID;
            order.OrderSysID = char2String(pOrder->OrderSysID);
            order.OrderSource = pOrder->OrderSource;
            order.OrderStatus = pOrder->OrderStatus;
            order.OrderType = pOrder->OrderType;
            order.VolumeTraded = pOrder->VolumeTraded;
            order.VolumeTotal = pOrder->VolumeTotal;
            order.InsertDate = char2String(pOrder->InsertDate);
            order.InsertTime = char2String(pOrder->InsertTime);
            order.ActiveTime = char2String(pOrder->ActiveTime);
            order.SuspendTime = char2String(pOrder->SuspendTime);
            order.UpdateTime = char2String(pOrder->UpdateTime);
            order.CancelTime = char2String(pOrder->CancelTime);
            order.ActiveTraderID = char2String(pOrder->ActiveTraderID);
            order.ClearingPartID = char2String(pOrder->ClearingPartID);
            order.SequenceNo = pOrder->SequenceNo;
            order.FrontID = pOrder->FrontID;
            order.SessionID = pOrder->SessionID;
            order.UserProductInfo = char2String(pOrder->UserProductInfo);
            order.StatusMsg = char2String(pOrder->StatusMsg);
            order.UserForceClose = pOrder->UserForceClose;
            order.ActiveUserID = char2String(pOrder->ActiveUserID);
            order.BrokerOrderSeq = pOrder->BrokerOrderSeq;
            order.RelativeOrderSysID = char2String(pOrder->RelativeOrderSysID);
            order.ZCETotalTradedVolume = pOrder->ZCETotalTradedVolume;
            order.IsSwapOrder = pOrder->IsSwapOrder;
            order.nRequestID = nRequestID;
            [qryOrders addObject:order];
        }
        
        if (bIsLast) {
            [qryOrders sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                UPRspOrderModel *order1 = obj1;
                UPRspOrderModel *order2 = obj2;
                return [[order2.InsertDate stringByAppendingString:order2.InsertTime] compare:[order1.InsertDate stringByAppendingString:order1.InsertTime]];
            }];
            [this->ctpTradeStruct->cthostFtdcTraderService reqQueryOrderResult:[qryOrders copy] pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
            qryOrders = nil;
        }
    }
    else
    {
        std::cout << "=====查询报单失败=====" << std::endl;
        [this->ctpTradeStruct->cthostFtdcTraderService reqQueryOrderResult:nil pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
        qryOrders = nil;
    }
}

NSMutableArray *depthMarketDatas;
void UPCThostFtdcTraderSpi::OnRspQryDepthMarketData(
                                                    KingstarAPI::CThostFtdcDepthMarketDataField *pDepthMarketData,
                                                    KingstarAPI::CThostFtdcRspInfoField *pRspInfo,
                                                    int nRequestID,
                                                    bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====请求查询深度行情成功=====" << std::endl;
        
        if (!depthMarketDatas) {
            depthMarketDatas = [NSMutableArray array];
        }
        
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
            [depthMarketDatas addObject:depthMarketDataModel];
        }
        
        if (bIsLast) {
            [this->ctpTradeStruct->cthostFtdcTraderService reqQueryDepthMarketResult:[depthMarketDatas copy] pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
            depthMarketDatas = nil;
        }
    }
    else
    {
        std::cout << "=====请求查询深度行情失败=====" << std::endl;
        [this->ctpTradeStruct->cthostFtdcTraderService reqQueryDepthMarketResult:nil pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
        depthMarketDatas = nil;
    }
}

NSMutableArray *instrumentMarginRates;
void UPCThostFtdcTraderSpi::OnRspQryInstrumentMarginRate(KingstarAPI::CThostFtdcInstrumentMarginRateField *pInstrumentMarginRate, KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====请求查询合约保证金率成功=====" << std::endl;
        
        if (!instrumentMarginRates) {
            instrumentMarginRates = [NSMutableArray array];
        }
        
        if (NULL != pInstrumentMarginRate) {
            UPRspInstrumentMarginRateModel *marginRateModel = [[UPRspInstrumentMarginRateModel alloc] init];
            marginRateModel.InstrumentID = char2String(pInstrumentMarginRate->InstrumentID);
            marginRateModel.InvestorRange = pInstrumentMarginRate->InvestorRange;
            marginRateModel.BrokerID = char2String(pInstrumentMarginRate->BrokerID);
            marginRateModel.InvestorID = char2String(pInstrumentMarginRate->InvestorID);
            marginRateModel.HedgeFlag = pInstrumentMarginRate->HedgeFlag;
            marginRateModel.LongMarginRatioByMoney = pInstrumentMarginRate->LongMarginRatioByMoney;
            marginRateModel.LongMarginRatioByVolume = pInstrumentMarginRate->LongMarginRatioByVolume;
            marginRateModel.ShortMarginRatioByMoney = pInstrumentMarginRate->ShortMarginRatioByMoney;
            marginRateModel.ShortMarginRatioByVolume = pInstrumentMarginRate->ShortMarginRatioByVolume;
            marginRateModel.IsRelative = pInstrumentMarginRate->IsRelative;
            [instrumentMarginRates addObject:marginRateModel];
        }
        
        if (bIsLast) {
            [this->ctpTradeStruct->cthostFtdcTraderService reqQueryInstrumentMarginRateResult:[instrumentMarginRates copy] pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
            instrumentMarginRates = nil;
        }
    }
    else
    {
        std::cout << "=====请求查询合约保证金率失败=====" << std::endl;
        [this->ctpTradeStruct->cthostFtdcTraderService reqQueryInstrumentMarginRateResult:nil pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
        instrumentMarginRates = nil;
    }
}

NSMutableArray *banks;
void UPCThostFtdcTraderSpi::OnRspQryTransferBank(
                                                 KingstarAPI::CThostFtdcTransferBankField *pTransferBank,
                                                 KingstarAPI::CThostFtdcRspInfoField *pRspInfo,
                                                 int nRequestID,
                                                 bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====请求查询转账银行成功=====" << std::endl;
        
        if (!banks) {
            banks = [NSMutableArray array];
        }
        
        UPRspTransferBankModel *bankModel = [[UPRspTransferBankModel alloc] init];
        if (NULL != pTransferBank) {
            bankModel.BankID = char2String(pTransferBank->BankID);
            bankModel.BankBrchID = char2String(pTransferBank->BankBrchID);
            bankModel.BankName = char2String(pTransferBank->BankName);
            bankModel.IsActive = pTransferBank->IsActive;
            [banks addObject:bankModel];
        }
        
        if (bIsLast) {
            [this->ctpTradeStruct->cthostFtdcTraderService reqQueryTransferBankResult:[banks copy] pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
            banks = nil;
        }
    }
    else
    {
        std::cout << "=====请求查询转账银行失败=====" << std::endl;
        [this->ctpTradeStruct->cthostFtdcTraderService reqQueryTransferBankResult:nil pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
        banks = nil;
    }
}

NSMutableArray *serials;
void UPCThostFtdcTraderSpi::OnRspQryTransferSerial(
                                                   KingstarAPI::CThostFtdcTransferSerialField *pTransferSerial,
                                                   KingstarAPI::CThostFtdcRspInfoField *pRspInfo,
                                                   int nRequestID,
                                                   bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====请求查询转账流水成功=====" << std::endl;
        
        if (!serials) {
            serials = [NSMutableArray array];
        }
        
        if (NULL != pTransferSerial) {
            std::cout << "交易代码： " << pTransferSerial->TradeCode << std::endl;
            std::cout << "交易金额： " << pTransferSerial->TradeAmount << std::endl;
            
            UPRspTransferSerialModel *serialModel = [[UPRspTransferSerialModel alloc] init];
            serialModel.PlateSerial = pTransferSerial->PlateSerial;
            serialModel.TradeDate = char2String(pTransferSerial->TradeDate);
            serialModel.TradingDay = char2String(pTransferSerial->TradingDay);
            serialModel.TradeTime = char2String(pTransferSerial->TradeTime);
            serialModel.TradeCode = char2String(pTransferSerial->TradeCode);
            serialModel.SessionID = pTransferSerial->SessionID;
            serialModel.BankID = char2String(pTransferSerial->BankID);
            serialModel.BankBranchID = char2String(pTransferSerial->BankBranchID);
            serialModel.BankAccType = pTransferSerial->BankAccType;
            serialModel.BankAccount = char2String(pTransferSerial->BankAccount);
            serialModel.BankSerial = char2String(pTransferSerial->BankSerial);
            serialModel.BrokerID = char2String(pTransferSerial->BrokerID);
            serialModel.BrokerBranchID = char2String(pTransferSerial->BrokerBranchID);
            serialModel.FutureAccType = pTransferSerial->FutureAccType;
            serialModel.AccountID = char2String(pTransferSerial->AccountID);
            serialModel.InvestorID = char2String(pTransferSerial->InvestorID);
            serialModel.FutureSerial = pTransferSerial->FutureSerial;
            serialModel.IdCardType = pTransferSerial->IdCardType;
            serialModel.IdentifiedCardNo = char2String(pTransferSerial->IdentifiedCardNo);
            serialModel.CurrencyID = char2String(pTransferSerial->CurrencyID);
            serialModel.TradeAmount = pTransferSerial->TradeAmount;
            serialModel.CustFee = pTransferSerial->CustFee;
            serialModel.BrokerFee = pTransferSerial->BrokerFee;
            serialModel.AvailabilityFlag = pTransferSerial->AvailabilityFlag;
            serialModel.OperatorCode = char2String(pTransferSerial->OperatorCode);
            serialModel.BankNewAccount = char2String(pTransferSerial->BankNewAccount);
            serialModel.ErrorID = pTransferSerial->ErrorID;
            serialModel.ErrorMsg = char2String(pTransferSerial->ErrorMsg);
            [serials addObject:serialModel];
        }
        
        if (bIsLast) {
            [this->ctpTradeStruct->cthostFtdcTraderService reqQueryTransferSerialResult:[serials copy] pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
            serials = nil;
        }
    }
    else
    {
        std::cout << "=====请求查询转账流水失败=====" << std::endl;
        [this->ctpTradeStruct->cthostFtdcTraderService reqQueryTransferSerialResult:nil pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
        serials = nil;
    }
}

NSMutableArray *accountregisters;
void UPCThostFtdcTraderSpi::OnRspQryAccountregister(
                                                    KingstarAPI::CThostFtdcAccountregisterField *pAccountregister,
                                                    KingstarAPI::CThostFtdcRspInfoField *pRspInfo,
                                                    int nRequestID,
                                                    bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====请求查询银期签约关系成功=====" << std::endl;
        
        if (!accountregisters) {
            accountregisters = [NSMutableArray array];
        }
        
        if (NULL != pAccountregister) {
            UPRspAccountregisterModel *accountregisterModel = [[UPRspAccountregisterModel alloc] init];
            accountregisterModel.TradeDay = char2String(pAccountregister->TradeDay);
            accountregisterModel.BankID = char2String(pAccountregister->BankID);
            accountregisterModel.BankBranchID = char2String(pAccountregister->BankBranchID);
            accountregisterModel.BankAccount = char2String(pAccountregister->BankAccount);
            accountregisterModel.BrokerID = char2String(pAccountregister->BrokerID);
            accountregisterModel.BrokerBranchID = char2String(pAccountregister->BrokerBranchID);
            accountregisterModel.AccountID = char2String(pAccountregister->AccountID);
            accountregisterModel.IdCardType = pAccountregister->IdCardType;
            accountregisterModel.IdentifiedCardNo = char2String(pAccountregister->IdentifiedCardNo);
            accountregisterModel.CustomerName = char2String(pAccountregister->CustomerName);
            accountregisterModel.CurrencyID = char2String(pAccountregister->CurrencyID);
            accountregisterModel.OpenOrDestroy = pAccountregister->OpenOrDestroy;
            accountregisterModel.RegDate = char2String(pAccountregister->RegDate);
            accountregisterModel.OutDate = char2String(pAccountregister->OutDate);
            accountregisterModel.TID = pAccountregister->TID;
            accountregisterModel.CustType = pAccountregister->CustType;
            accountregisterModel.BankAccType = pAccountregister->BankAccType;
            [accountregisters addObject:accountregisterModel];
        }
        
        if (bIsLast) {
            [this->ctpTradeStruct->cthostFtdcTraderService reqQueryAccountregisterResult:[accountregisters copy] pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
            accountregisters = nil;
        }
    }
    else
    {
        std::cout << "=====请求查询银期签约关系失败=====" << std::endl;
        [this->ctpTradeStruct->cthostFtdcTraderService reqQueryAccountregisterResult:nil pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
        accountregisters = nil;
    }
}

NSMutableArray *transfers;
void UPCThostFtdcTraderSpi::OnRspFromBankToFutureByFuture(
                                   KingstarAPI::CThostFtdcReqTransferField *pReqTransfer,
                                   KingstarAPI::CThostFtdcRspInfoField *pRspInfo,
                                   int nRequestID,
                                   bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====请求银行转期货成功=====" << std::endl;
        
        if (!transfers) {
            transfers = [NSMutableArray array];
        }
        
        if (NULL != pReqTransfer) {
            UPRspTransferModel *transferModel = [[UPRspTransferModel alloc] init];
            [transfers addObject:transferModel];
        }
        
        if (bIsLast) {
            [this->ctpTradeStruct->cthostFtdcTraderService reqBetweenBankAndFutureResult:[transfers copy] pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
            transfers = nil;
        }
    }
    else
    {
        std::cout << "=====请求银行转期货失败=====" << std::endl;
        [this->ctpTradeStruct->cthostFtdcTraderService reqBetweenBankAndFutureResult:nil pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
        accountregisters = nil;
    }
}

void UPCThostFtdcTraderSpi::OnRspFromFutureToBankByFuture(
                                                          KingstarAPI::CThostFtdcReqTransferField *pReqTransfer,
                                                          KingstarAPI::CThostFtdcRspInfoField *pRspInfo,
                                                          int nRequestID,
                                                          bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====请求期货转银行成功=====" << std::endl;
        
        if (!transfers) {
            transfers = [NSMutableArray array];
        }
        
        if (NULL != pReqTransfer) {
            UPRspTransferModel *transferModel = [[UPRspTransferModel alloc] init];
            [transfers addObject:transferModel];
        }
        
        if (bIsLast) {
            [this->ctpTradeStruct->cthostFtdcTraderService reqBetweenBankAndFutureResult:[transfers copy] pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
            transfers = nil;
        }
    }
    else
    {
        std::cout << "=====请求期货转银行失败=====" << std::endl;
        [this->ctpTradeStruct->cthostFtdcTraderService reqBetweenBankAndFutureResult:nil pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
        accountregisters = nil;
    }
}

int nQueryBankAccountMoneyByFutureRequestID;
void UPCThostFtdcTraderSpi::OnRspQueryBankAccountMoneyByFuture(
                                                               KingstarAPI::CThostFtdcReqQueryAccountField *pReqQueryAccount,
                                                               KingstarAPI::CThostFtdcRspInfoField *pRspInfo,
                                                               int nRequestID,
                                                               bool bIsLast)
{
    nQueryBankAccountMoneyByFutureRequestID = nRequestID;
    if (!isErrorRspInfo(pRspInfo))
    {
        std::cout << "=====请求查询银行余额成功=====" << std::endl;
    }
    else
    {
        std::cout << "=====请求查询银行余额失败=====" << std::endl;
        [this->ctpTradeStruct->cthostFtdcTraderService reqQueryBankAccountMoneyByFutureResult:nil pRspInfo:CThostFtdcRspInfoField2UPRspInfoModel(pRspInfo, nRequestID)];
    }
}

void UPCThostFtdcTraderSpi::OnRtnQueryBankBalanceByFuture(KingstarAPI::CThostFtdcNotifyQueryAccountField *pNotifyQueryAccount)
{
    UPRspNotifyQueryAccountModel *accountModel = [[UPRspNotifyQueryAccountModel alloc] init];
    if (NULL != pNotifyQueryAccount) {
        accountModel.TradeCode = char2String(pNotifyQueryAccount->TradeCode);
        accountModel.BankID = char2String(pNotifyQueryAccount->BankID);
        accountModel.BankBranchID = char2String(pNotifyQueryAccount->BankBranchID);
        accountModel.BrokerID = char2String(pNotifyQueryAccount->BrokerID);
        accountModel.BrokerBranchID = char2String(pNotifyQueryAccount->BrokerBranchID);
        accountModel.TradingDay = char2String(pNotifyQueryAccount->TradingDay);
        accountModel.TradeTime = char2String(pNotifyQueryAccount->TradeTime);
        accountModel.TradeDate = char2String(pNotifyQueryAccount->TradeDate);
        accountModel.BankSerial = char2String(pNotifyQueryAccount->BankSerial);
        accountModel.PlateSerial = pNotifyQueryAccount->PlateSerial;
        accountModel.LastFragment = pNotifyQueryAccount->LastFragment;
        accountModel.SessionID = pNotifyQueryAccount->SessionID;
        accountModel.CustomerName = char2String(pNotifyQueryAccount->CustomerName);
        accountModel.IdCardType = pNotifyQueryAccount->IdCardType;
        accountModel.IdentifiedCardNo = char2String(pNotifyQueryAccount->IdentifiedCardNo);
        accountModel.CustType = pNotifyQueryAccount->CustType;
        accountModel.BankAccount = char2String(pNotifyQueryAccount->BankAccount);
        accountModel.BankPassWord = char2String(pNotifyQueryAccount->BankPassWord);
        accountModel.AccountID = char2String(pNotifyQueryAccount->AccountID);
        accountModel.Password = char2String(pNotifyQueryAccount->Password);
        accountModel.FutureSerial = pNotifyQueryAccount->FutureSerial;
        accountModel.InstallID = pNotifyQueryAccount->InstallID;
        accountModel.UserID = char2String(pNotifyQueryAccount->UserID);
        accountModel.VerifyCertNoFlag = pNotifyQueryAccount->VerifyCertNoFlag;
        accountModel.CurrencyID = char2String(pNotifyQueryAccount->CurrencyID);
        accountModel.Digest = char2String(pNotifyQueryAccount->Digest);
        accountModel.BankAccType = pNotifyQueryAccount->BankAccType;
        accountModel.DeviceID = char2String(pNotifyQueryAccount->DeviceID);
        accountModel.BankSecuAccType = pNotifyQueryAccount->BankSecuAccType;
        accountModel.BrokerIDByBank = char2String(pNotifyQueryAccount->BrokerIDByBank);
        accountModel.BankSecuAcc = char2String(pNotifyQueryAccount->BankSecuAcc);
        accountModel.BankPwdFlag = pNotifyQueryAccount->BankPwdFlag;
        accountModel.SecuPwdFlag = pNotifyQueryAccount->SecuPwdFlag;
        accountModel.OperNo = char2String(pNotifyQueryAccount->OperNo);
        accountModel.RequestID = pNotifyQueryAccount->RequestID;
        accountModel.TID = pNotifyQueryAccount->TID;
        accountModel.BankUseAmount = pNotifyQueryAccount->BankUseAmount;
        accountModel.BankFetchAmount = pNotifyQueryAccount->BankFetchAmount;
        accountModel.ErrorID = pNotifyQueryAccount->ErrorID;
        accountModel.ErrorMsg = char2String(pNotifyQueryAccount->ErrorMsg);
        accountModel.nRequestID = nQueryBankAccountMoneyByFutureRequestID;
    }
    [this->ctpTradeStruct->cthostFtdcTraderService reqQueryBankAccountMoneyByFutureResult:accountModel pRspInfo:nil];
}

// MARK: 自定义函数
UPRspInfoModel *UPCThostFtdcTraderSpi::CThostFtdcRspInfoField2UPRspInfoModel(KingstarAPI::CThostFtdcRspInfoField *pRspInfo, int nRequestID)
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

bool UPCThostFtdcTraderSpi::isErrorRspInfo(KingstarAPI::CThostFtdcRspInfoField *pRspInfo)
{
    bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
    if (bResult)
        std::cerr << "返回错误--->>> ErrorID=" << pRspInfo->ErrorID << ", ErrorMsg=" << pRspInfo->ErrorMsg << std::endl;
    return bResult;
}
