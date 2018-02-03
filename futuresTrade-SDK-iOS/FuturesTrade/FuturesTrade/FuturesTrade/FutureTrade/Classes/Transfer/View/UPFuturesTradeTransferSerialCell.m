//
//  UPFuturesTradeTransferSerialCell.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/9.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeTransferSerialCell.h"
#import <FuturesTradeSDK/UPCTPModelHeader.h>
#import "UPFuturesTradeTransferUtil.h"

NSString * const UPFuturesTradeTransferSerialCellReuseId = @"UPFuturesTradeTransferSerialCell";

@interface UPFuturesTradeTransferSerialCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@end

@implementation UPFuturesTradeTransferSerialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSerialModel:(UPRspTransferSerialModel *)serialModel {
    _timeLabel.text = serialModel.TradingDay;
    _amountLabel.text = [UPFuturesTradeNumberUtil double2String:serialModel.TradeAmount];
    _statusLabel.text = [UPFuturesTradeStringUtil transferAvailabilityFlag:serialModel.AvailabilityFlag];
    _directionLabel.text = [UPFuturesTradeTransferUtil transferDirection:serialModel.TradeCode];
}

@end
