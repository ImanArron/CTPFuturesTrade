//
//  UPFuturesTradeBusinessHeaderView.h
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/30.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const UPFuturesTradeBusinessHeaderViewReuseId;

typedef void(^UPFuturesTradeBusinessHeaderBlock)(NSInteger);

@interface UPFuturesTradeBusinessHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) UPFuturesTradeBusinessHeaderBlock block;
- (void)setupTabView;

@end
