//
//  UPHUD.m
//  PurchaseTool
//
//  Created by hubupc on 2017/8/1.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPHUD.h"
#import "UPFuturesTradeProgressHUD.h"

#define MBTAG   98999

@implementation UPHUD

+ (void)showToast:(UIView *)view withText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        UPFuturesTradeProgressHUD *hud = [UPFuturesTradeProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = UPFuturesTradeProgressHUDModeText;
        hud.detailsLabel.text = text;
        hud.removeFromSuperViewOnHide = YES;
        hud.userInteractionEnabled = NO;
        [hud hideAnimated:YES afterDelay:kToastDelayTime];
    });
}

+ (void)showHUD:(UIView *)view withText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        UPFuturesTradeProgressHUD *hud = [UPFuturesTradeProgressHUD showHUDAddedTo:view animated:YES];
        hud.tag = MBTAG;
        hud.label.text = text;
    });
}

+ (void)showHUD:(UIView *)view {
    [self showHUD:view withText:@""];
}

+ (void)hideHUD:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        UPFuturesTradeProgressHUD *mb = (UPFuturesTradeProgressHUD *)[view viewWithTag:MBTAG];
        if (nil != mb || ![mb isHidden]) {
            [mb removeFromSuperview];
        }
    });
}

@end
