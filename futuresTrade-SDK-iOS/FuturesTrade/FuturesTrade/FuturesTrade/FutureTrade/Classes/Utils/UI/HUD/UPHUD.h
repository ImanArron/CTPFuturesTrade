//
//  UPHUD.h
//  PurchaseTool
//
//  Created by hubupc on 2017/8/1.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kToastDelayTime 2   // 秒

@interface UPHUD : NSObject

/**
 * @brief 显示提示文字，然后自动消失
 *
 * @param view 添加到的视图
 * @param text 文字
 */
+ (void)showToast:(UIView *)view withText:(NSString *)text;

/**
 * @brief 显示提示文字，不消失
 *
 * @param view 添加到的视图
 * @param text 文字图
 */
+ (void)showHUD:(UIView *)view withText:(NSString *)text;

/**
 * @brief 显示进度条，不消失
 *
 * @param view 添加到的视图
 */
+ (void)showHUD:(UIView *)view;

/**
 * @brief 隐藏HUD
 *
 * @param view 添加到的视图
 */
+ (void)hideHUD:(UIView *)view;

@end

