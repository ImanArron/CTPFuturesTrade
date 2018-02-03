//
//  UPFuturesTradeFundStatusSectionHeaderView.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/8.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeTransferSerialSectionHeaderView.h"

NSString * const UPFuturesTradeTransferSerialSectionHeaderViewReuseId = @"UPFuturesTradeTransferSerialSectionHeaderView";

@interface UPFuturesTradeTransferSerialSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation UPFuturesTradeTransferSerialSectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setupLabel:(NSString *)text {
    _label.text = text;
}

@end
