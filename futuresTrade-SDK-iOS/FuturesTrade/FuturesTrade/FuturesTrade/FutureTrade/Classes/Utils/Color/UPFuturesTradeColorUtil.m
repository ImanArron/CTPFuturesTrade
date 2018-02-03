//
//  UPFuturesTradeColorUtil.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/28.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeColorUtil.h"
#import "UPFuturesTradeMacros.h"

@implementation UPFuturesTradeColorUtil

+ (void)setupLabelColor:(UILabel *)label value:(double)value {
    if (value > 0) {
        label.textColor = UPColorFromRGB(0xe63c39);
    } else if (value < 0) {
        label.textColor = UPColorFromRGB(0x38ab48);
    } else {
        label.textColor = UPColorFromRGB(0x808080);
    }
}

@end
