//
//  UPValidatorManager.h
//  PurchaseTool
//
//  Created by hubupc on 2017/8/8.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPValidateManager : NSObject

+ (BOOL)isValidatePhone:(NSString *)text;

+ (BOOL)isValidateIP:(NSString *)text;

@end
