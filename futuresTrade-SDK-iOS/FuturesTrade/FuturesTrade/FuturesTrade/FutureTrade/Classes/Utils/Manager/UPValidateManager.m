//
//  UPValidatorManager.m
//  PurchaseTool
//
//  Created by hubupc on 2017/8/8.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPValidateManager.h"

@implementation UPValidateManager

+ (BOOL)isValidatePhone:(NSString *)text {
    if (!text) {
        return NO;
    }
    
    NSString *photoRange = @"^1(1[0-9]|2[0-9]|3[0-9]|4[0-9]|5[0-9]|6[0-9]|7[0-9]|8[0-9]|9[0-9])\\d{8}$";//正则表达式
    NSPredicate *regexMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",photoRange];
    BOOL result = [regexMobile evaluateWithObject:text];
    if (result) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isValidateIP:(NSString *)text {
    NSString  *urlRegEx =@"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:text];
}

@end
