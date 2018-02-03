//
//  UPRspInfoModel.h
//  FuturesTrade
//
//  Created by UP-LiuL on 17/8/14.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPCTPModel.h"

@interface UPRspInfoModel : UPCTPModel

///错误代码
@property (nonatomic, assign) NSInteger ErrorID;
///错误信息
@property (nonatomic, copy) NSString *ErrorMsg;

@end
