//
//  UPRspTransferSerialModel.h
//  UPFuturesTrade
//
//  Created by UP-LiuL on 17/9/7.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPModel.h"

@interface UPRspTransferSerialModel : UPCTPModel

///平台流水号
@property (nonatomic, assign) int PlateSerial;
///交易发起方日期
@property (nonatomic, copy) NSString *TradeDate;
///交易日期
@property (nonatomic, copy) NSString *TradingDay;
///交易时间
@property (nonatomic, copy) NSString *TradeTime;
///交易代码
@property (nonatomic, copy) NSString *TradeCode;
///会话编号
@property (nonatomic, assign) int SessionID;
///银行编码
@property (nonatomic, copy) NSString *BankID;
///银行分支机构编码
@property (nonatomic, copy) NSString *BankBranchID;
///银行帐号类型
@property (nonatomic, assign) char BankAccType;
///银行帐号
@property (nonatomic, copy) NSString *BankAccount;
///银行流水号
@property (nonatomic, copy) NSString *BankSerial;
///期货公司编码
@property (nonatomic, copy) NSString *BrokerID;
///期商分支机构代码
@property (nonatomic, copy) NSString *BrokerBranchID;
///期货公司帐号类型
@property (nonatomic, assign) char FutureAccType;
///投资者帐号
@property (nonatomic, copy) NSString *AccountID;
///投资者代码
@property (nonatomic, copy) NSString *InvestorID;
///期货公司流水号
@property (nonatomic, assign) int FutureSerial;
///证件类型
@property (nonatomic, assign) char IdCardType;
///证件号码
@property (nonatomic, copy) NSString *IdentifiedCardNo;
///币种代码
@property (nonatomic, copy) NSString *CurrencyID;
///交易金额
@property (nonatomic, assign) double TradeAmount;
///应收客户费用
@property (nonatomic, assign) double CustFee;
///应收期货公司费用
@property (nonatomic, assign) double BrokerFee;
///有效标志
@property (nonatomic, assign) char AvailabilityFlag;
///操作员
@property (nonatomic, copy) NSString *OperatorCode;
///新银行帐号
@property (nonatomic, copy) NSString *BankNewAccount;
///错误代码
@property (nonatomic, assign) int ErrorID;
///错误信息
@property (nonatomic, copy) NSString *ErrorMsg;

@end
