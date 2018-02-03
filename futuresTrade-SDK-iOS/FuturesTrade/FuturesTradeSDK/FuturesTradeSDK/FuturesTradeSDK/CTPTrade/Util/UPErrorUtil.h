//
//  UPErrorUtil.h
//  FuturesTrade
//
//  Created by LiuLian on 17/8/16.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UPRspInfoModel;

@interface UPErrorUtil : NSObject

+ (NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)code;
+ (NSError *)errorWithRspInfo:(UPRspInfoModel *)pRspInfo;
+ (NSString *)errorDomainWithReqCode:(NSInteger)reqCode;

@end
