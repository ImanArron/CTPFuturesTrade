//
//  UPFuturesTradeStringUtil.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/31.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeStringUtil.h"
#import "UPFuturesTradeMacros.h"
#import <FuturesTradeSDK/UPCTPModelHeader.h>

@implementation UPFuturesTradeStringUtil

+ (NSString *)posiDirection:(char)posiDirection {
    if (posiDirection == '2') {
        return @"多仓";
    } else if (posiDirection == '3') {
        return @"空仓";
    } else if (posiDirection == '1') {
        return @"净";
    }
    
    return DEFAULT_PLACEHOLDER;
}

+ (BOOL)isMultipleWarehouse:(char)posiDirection {
    return (posiDirection == '2');
}

+ (NSString *)posiDetailDirection:(char)posiDetailDirection {
    if (posiDetailDirection == '0') {
        return @"多仓";
    } else if (posiDetailDirection == '1') {
        return @"空仓";
    }
    
    return DEFAULT_PLACEHOLDER;
}

+ (NSString *)tradeDirection:(char)direction {
    if (direction == '0') {
        return @"买";
    } else if (direction == '1') {
        return @"卖";
    }
    
    return DEFAULT_PLACEHOLDER;
}

+ (NSString *)trimWhiteSpace:(const NSString *)str {
    NSString *result = nil;
    if (str) {
        result = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return result;
}

+ (NSString *)orderStatus:(char)orderStatus {
    if (orderStatus == '0') {
        return @"全部成交";
    } else if (orderStatus == '1') {
        return @"部分成交，订单还在交易所撮合队列中";
    } else if (orderStatus == '2') {
        return @"部分成交，订单不在交易所撮合队列中";
    } else if (orderStatus == '3') {
        return @"未成交，订单还在交易所撮合队列中";
    } else if (orderStatus == '4') {
        return @"未成交，订单不在交易所撮合队列中";
    } else if (orderStatus == '5') {
        return @"已撤销";
    } else if (orderStatus == 'a') {
        return @"未知-订单已提交交易所，未从交易所收到确认信息";
    } else if (orderStatus == 'b') {
        return @"尚未触发";
    } else if (orderStatus == 'c') {
        return @"已触发";
    }
    
    return EMPTY;
}

+ (NSString *)orderStatusForDisplay:(char)orderStatus {
    if (orderStatus == '0') {
        return @"全部成交";
    } else if (orderStatus == '1' || orderStatus == '2') {
        return @"部分成交";
    } else if (orderStatus == '3' || orderStatus == '4') {
        return @"未成交";
    } else if (orderStatus == '5') {
        return @"已撤销";
    } else if (orderStatus == 'a') {
        return @"未知";
    } else if (orderStatus == 'b') {
        return @"尚未触发";
    } else if (orderStatus == 'c') {
        return @"已触发";
    }
    
    return EMPTY;
}

+ (BOOL)canDeletedOrder:(char)orderStatus {
    if (orderStatus == '1' || orderStatus == '3') {
        return YES;
    }
    
    return NO;
}

+ (NSString *)transferAvailabilityFlag:(char)availabilityFlag {
    if (availabilityFlag == '0') {
        return @"未确认";
    } else if (availabilityFlag == '1') {
        return @"有效";
//        return @"操作成功";
    } else if (availabilityFlag == '2') {
        return @"冲正";
    }
    
    return EMPTY;
}

+ (NSString *)orderSubmitStatus:(char)orderSubmitStatus {
    if (orderSubmitStatus == '0') {
        return @"已经提交";
    } else if (orderSubmitStatus == '1') {
        return @"撤单已经提交";
    } else if (orderSubmitStatus == '2') {
        return @"修改已经提交";
    } else if (orderSubmitStatus == '3') {
        return @"已经接受";
    } else if (orderSubmitStatus == '4') {
        return @"报单已经被拒绝";
    } else if (orderSubmitStatus == '5') {
        return @"撤单已经被拒绝";
    } else if (orderSubmitStatus == '6') {
        return @"改单已经被拒绝";
    }
    
    return EMPTY;
}

+ (NSString *)orderHint:(id)object {
    NSMutableString *hint = [NSMutableString string];
    if ([object isKindOfClass:[UPRspOrderModel class]]) {
        UPRspOrderModel *orderModel = (UPRspOrderModel *)object;
        [hint appendFormat:@"%@, %@, %@", orderModel.InstrumentID, [UPFuturesTradeStringUtil tradeDirection:orderModel.Direction], [UPFuturesTradeStringUtil orderSubmitStatus:orderModel.OrderSubmitStatus]];
    } else if ([object isKindOfClass:[UPRspTradeModel class]]) {
        UPRspTradeModel *tradeModel = (UPRspTradeModel *)object;
        [hint appendFormat:@"%@, %@, %@", tradeModel.InstrumentID, [UPFuturesTradeStringUtil tradeDirection:tradeModel.Direction], @"报单成功成交"];
    }
    
    return [hint copy];
}

@end
