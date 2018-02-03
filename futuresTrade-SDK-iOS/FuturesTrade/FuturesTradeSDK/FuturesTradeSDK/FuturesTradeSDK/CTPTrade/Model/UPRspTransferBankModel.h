//
//  UPRspTransferBankModel.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/7.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPModel.h"

@interface UPRspTransferBankModel : UPCTPModel

///银行代码
@property (nonatomic, copy) NSString *BankID;
///银行分中心代码
@property (nonatomic, copy) NSString *BankBrchID;
///银行名称
@property (nonatomic, copy) NSString *BankName;
///是否活跃
@property (nonatomic, assign) int IsActive;

@end
