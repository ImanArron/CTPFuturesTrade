//
//  UPRspNotifyQueryAccountModel.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/18.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPModel.h"

@interface UPRspNotifyQueryAccountModel : UPCTPModel

///业务功能码
@property (nonatomic, copy) NSString *TradeCode;
///银行代码
@property (nonatomic, copy) NSString *BankID;
///银行分支机构代码
@property (nonatomic, copy) NSString *BankBranchID;
///期商代码
@property (nonatomic, copy) NSString *BrokerID;
///期商分支机构代码
@property (nonatomic, copy) NSString *BrokerBranchID;
///交易日期
@property (nonatomic, copy) NSString *TradeDate;
///交易时间
@property (nonatomic, copy) NSString *TradeTime;
///银行流水号
@property (nonatomic, copy) NSString *BankSerial;
///交易系统日期
@property (nonatomic, copy) NSString *TradingDay;
///银期平台消息流水号
@property (nonatomic, assign) int PlateSerial;
///最后分片标志
@property (nonatomic, assign) char LastFragment;
///会话号
@property (nonatomic, assign) double SessionID;
///客户姓名
@property (nonatomic, copy) NSString *CustomerName;
///证件类型
@property (nonatomic, assign) char IdCardType;
///证件号码
@property (nonatomic, copy) NSString *IdentifiedCardNo;
///客户类型
@property (nonatomic, assign) char CustType;
///银行帐号
@property (nonatomic, copy) NSString *BankAccount;
///银行密码
@property (nonatomic, copy) NSString *BankPassWord;
///投资者帐号
@property (nonatomic, copy) NSString *AccountID;
///期货密码
@property (nonatomic, copy) NSString *Password;
///期货公司流水号
@property (nonatomic, assign) int FutureSerial;
///安装编号
@property (nonatomic, assign) int InstallID;
///用户标识
@property (nonatomic, copy) NSString *UserID;
///验证客户证件号码标志
@property (nonatomic, assign) char VerifyCertNoFlag;
///币种代码
@property (nonatomic, copy) NSString *CurrencyID;
///摘要
@property (nonatomic, copy) NSString *Digest;
///银行帐号类型
@property (nonatomic, assign) char BankAccType;
///渠道标志
@property (nonatomic, copy) NSString *DeviceID;
///期货单位帐号类型
@property (nonatomic, assign) char BankSecuAccType;
///期货公司银行编码
@property (nonatomic, copy) NSString *BrokerIDByBank;
///期货单位帐号
@property (nonatomic, copy) NSString *BankSecuAcc;
///银行密码标志
@property (nonatomic, assign) char BankPwdFlag;
///期货资金密码核对标志
@property (nonatomic, assign) char SecuPwdFlag;
///交易柜员
@property (nonatomic, copy) NSString *OperNo;
///请求编号
@property (nonatomic, assign) int RequestID;
///交易ID
@property (nonatomic, assign) int TID;
///银行可用金额
@property (nonatomic, assign) double BankUseAmount;
///银行可取金额
@property (nonatomic, assign) double BankFetchAmount;
///错误代码
@property (nonatomic, assign) int ErrorID;
///错误信息
@property (nonatomic, copy) NSString *ErrorMsg;

@end

