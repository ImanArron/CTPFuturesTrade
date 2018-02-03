//
//  UPFuturesTradeNumberUtil.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/28.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeNumberUtil.h"
#import "UPFuturesTradeMacros.h"

@implementation UPFuturesTradeNumberUtil

+ (NSString *)double2String:(double)value {
    if (value != 0) {
        NSString *string = [NSString stringWithFormat:@"%.2f", value];
        return [self retainAfterDot:[string copy]];
    }
    
    return ZERO_PLACEHOLDER;
}

+ (NSString *)retainAfterDot:(NSString *)string {
    if (string.length > 0 && NSNotFound != [string rangeOfString:@"."].location) {
        NSArray *components = [string componentsSeparatedByString:@"."];
        if (components.count > 1) {
            NSString *integerString = components[0];
            NSString *floatString = components[1];
            if (fabs(floatString.doubleValue) < 0.001) {
                return integerString;
            }
        }
    }
    
    return string;
}

+ (NSString *)long2String:(long)value {
    return [NSString stringWithFormat:@"%@", @(value)];
}

+ (NSInteger)numberOfDotInString:(NSString *)string {
    NSInteger numOfDot = 0;
    if (UPFuturesTradeIsValidateString(string)) {
        const char *c = [string UTF8String];
        for (NSInteger i = 0; i < string.length; i++) {
            if ('.' == c[i]) {
                numOfDot += 1;
            }
        }
    }
    return numOfDot;
}

+ (NSInteger)numberAfterDotInString:(NSString *)string {
    NSInteger numberAfterDot = 0;
    if (UPFuturesTradeIsValidateString(string)) {
        NSRange dotRange = [string rangeOfString:@"."];
        if (NSNotFound != dotRange.location) {
            NSString *tempString = [string substringFromIndex:dotRange.length + dotRange.location];
            if (UPFuturesTradeIsValidateString(tempString)) {
                numberAfterDot = tempString.length;
            }
        }
    }
    return numberAfterDot;
}

+ (BOOL)containsOnlyNumberAndPoint:(NSString *)string {
    if (UPFuturesTradeIsValidateString(string)) {
        const char *c = [string UTF8String];
        for (NSInteger i = 0; i < string.length; i++) {
            if (!((c[i] >= 48 && c[i] <= 57) || 46 == c[i])) {
                return NO;
            }
        }
        
        return YES;
    }
    
    return NO;
}


@end
