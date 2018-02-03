//
//  UPFuturesTradeLoginFooterView.h
//  FuturesTradeDemo
//
//  Created by LiuLian on 17/8/28.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UPFuturesTradeLoginFooterBlock)(void);

@interface UPFuturesTradeLoginFooterView : UIView

@property (nonatomic, copy) UPFuturesTradeLoginFooterBlock block;
+ (instancetype)loginFooterView;
- (void)enableLogin;
- (void)disableLogin;

@end
