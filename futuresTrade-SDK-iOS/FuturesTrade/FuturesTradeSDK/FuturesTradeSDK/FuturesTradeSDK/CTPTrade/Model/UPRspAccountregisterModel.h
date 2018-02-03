//
//  UPRspAccountregisterModel.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/8.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPModel.h"

@interface UPRspAccountregisterModel : UPCTPModel

///交易日期
@property (nonatomic, copy) NSString *TradeDay;
///银行编码
@property (nonatomic, copy) NSString *BankID;
///银行分支机构编码
@property (nonatomic, copy) NSString *BankBranchID;
///银行帐号
@property (nonatomic, copy) NSString *BankAccount;
///期货公司编码
@property (nonatomic, copy) NSString *BrokerID;
///期货公司分支机构编码
@property (nonatomic, copy) NSString *BrokerBranchID;
///投资者帐号
@property (nonatomic, copy) NSString *AccountID;
///证件类型
@property (nonatomic, assign) char IdCardType;
///证件号码
@property (nonatomic, copy) NSString *IdentifiedCardNo;
///客户姓名
@property (nonatomic, copy) NSString *CustomerName;
///币种代码
@property (nonatomic, copy) NSString *CurrencyID;
///开销户类别
@property (nonatomic, assign) char OpenOrDestroy;
///签约日期
@property (nonatomic, copy) NSString *RegDate;
///解约日期
@property (nonatomic, copy) NSString *OutDate;
///交易ID
@property (nonatomic, assign) int TID;
///客户类型
@property (nonatomic, assign) char CustType;
///银行帐号类型
@property (nonatomic, assign) char BankAccType;

@end
