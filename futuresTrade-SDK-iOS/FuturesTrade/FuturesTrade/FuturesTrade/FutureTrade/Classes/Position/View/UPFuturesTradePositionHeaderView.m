//
//  UPFuturesTradePositionHeaderView.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/6.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradePositionHeaderView.h"
#import <FuturesTradeSDK/UPCTPModelHeader.h>
#import "UPFuturesTradeCaculateUtil.h"

@interface UPFuturesTradePositionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *currentEquityLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet UILabel *canUseMarginLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalProfitLabel;

@end

@implementation UPFuturesTradePositionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (UPFuturesTradePositionHeaderView *)futuresTradePositionHeaderView {
    UPFuturesTradePositionHeaderView *positionHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"FuturesTradeBundle.bundle/UPFuturesTradePositionHeaderView" owner:nil options:nil] firstObject];
    return positionHeaderView;
}

- (void)setTradingAccountModel:(UPRspTradingAccountModel *)tradingAccountModel {
    if ([tradingAccountModel isKindOfClass:[UPRspTradingAccountModel class]]) {
        _profitLabel.text = [UPFuturesTradeNumberUtil double2String:tradingAccountModel.CurrMargin];
        [UPFuturesTradeColorUtil setupLabelColor:_profitLabel value:tradingAccountModel.CurrMargin];
        
        double dynamicEquity = [UPFuturesTradeCaculateUtil dynamicEquity:tradingAccountModel];
        _currentEquityLabel.text = [UPFuturesTradeNumberUtil double2String:dynamicEquity];
        [UPFuturesTradeColorUtil setupLabelColor:_currentEquityLabel value:dynamicEquity];
        
        _canUseMarginLabel.text = [UPFuturesTradeNumberUtil double2String:tradingAccountModel.Available];
        [UPFuturesTradeColorUtil setupLabelColor:_canUseMarginLabel value:tradingAccountModel.Available];
        
        double profit = [UPFuturesTradeCaculateUtil profit:tradingAccountModel];
        _totalProfitLabel.text = [UPFuturesTradeNumberUtil double2String:profit];
        [UPFuturesTradeColorUtil setupLabelColor:_totalProfitLabel value:profit];
    }
}

@end
