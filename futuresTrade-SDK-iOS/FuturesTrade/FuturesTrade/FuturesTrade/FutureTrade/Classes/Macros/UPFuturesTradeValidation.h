//
//  UPFuturesTradeValidation.h
//  FuturesTradeDemo
//
//  Created by LiuLian on 17/8/28.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#ifndef UPFuturesTradeValidation_h
#define UPFuturesTradeValidation_h

// 判断一个数组是否合法
#define UPFuturesTradeIsValidateArr(arr) (([arr isKindOfClass:[NSArray class]] && arr.count > 0))
// 判断一个字典是否合法
#define UPFuturesTradeIsValidateDic(dic) ([dic isKindOfClass:[NSDictionary class]] && dic.count > 0)
// 判断一个NSString是否合法
#define UPFuturesTradeIsValidateString(str) (([str isKindOfClass:[NSString class]]) && ([str length] > 0) && (![str isEqualToString:@"(null)"]) && ((NSNull *) str != [NSNull null]) && (![str isEqualToString:@"<null>"]))


#endif /* UPFuturesTradeValidation_h */
