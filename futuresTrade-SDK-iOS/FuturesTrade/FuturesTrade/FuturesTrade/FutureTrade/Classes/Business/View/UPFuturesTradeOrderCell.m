//
//  UPFuturesTradeOrderCell.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/5.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeOrderCell.h"
#import <FuturesTradeSDK/UPCTPModelHeader.h>
#import "UPFuturesTradeSearchUtil.h"
#import <FuturesTradeSDK/UPCTPTradeManager.h>

NSString * const UPFuturesTradeOrderCellReuseId = @"UPFuturesTradeOrderCell";

@interface UPFuturesTradeOrderCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *seperatorView;
@property (weak, nonatomic) IBOutlet UIView *operationView;

// 用于成交的cell，以便将撤单和成交的cell进行复用
@property (weak, nonatomic) IBOutlet UILabel *tradePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeTypeLabel;

@end

@implementation UPFuturesTradeOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _button.layer.masksToBounds = YES;
    _button.layer.cornerRadius = 2.f;
    _button.layer.borderColor = UPColorFromRGB(0x5871a6).CGColor;
    _button.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonClicked:(id)sender {
    if (_block) {
        _block(0);
    }
}

- (void)setViewModel:(id)viewModel {
    if ([viewModel isKindOfClass:[UPRspOrderModel class]]) {
        UPRspOrderModel *rspOrderModel = viewModel;
        [self setRspOrderModel:rspOrderModel];
    } else if ([viewModel isKindOfClass:[UPRspTradeModel class]]) {
        UPRspTradeModel *rspTradeModel = viewModel;
        [self setRspTradeModel:rspTradeModel];
    }
}

- (void)setRspOrderModel:(UPRspOrderModel *)rspOrderModel {
    _nameLabel.text = UPFuturesTradeIsValidateString(rspOrderModel.InstrumentID) ? [UPFuturesTradeSearchUtil searchInstrumentName:rspOrderModel.InstrumentID inInstruments:[UPCTPTradeManager instruments:_tradeType] tradeType:_tradeType] : DEFAULT_PLACEHOLDER;
    _codeLabel.text = UPFuturesTradeIsValidateString(rspOrderModel.InstrumentID) ? rspOrderModel.InstrumentID : DEFAULT_PLACEHOLDER;
    _typeLabel.text = [UPFuturesTradeStringUtil posiDetailDirection:rspOrderModel.Direction];
    if (rspOrderModel.Direction == '0') {
        _typeLabel.textColor = UPColorFromRGB(0xEA4C2D);
    } else {
        _typeLabel.textColor = UPColorFromRGB(0x38AB48);
    }
    _numLabel.text = [NSString stringWithFormat:@"%@", @(rspOrderModel.VolumeTotalOriginal)];
    _priceLabel.text = [UPFuturesTradeNumberUtil double2String:rspOrderModel.LimitPrice];
    NSString *statusMsg = [rspOrderModel.StatusMsg copy];
    if (!statusMsg.length) {
        statusMsg = [UPFuturesTradeStringUtil orderStatusForDisplay:rspOrderModel.OrderStatus];
    }
    _statusLabel.text = statusMsg;
    _timeLabel.text = UPFuturesTradeIsValidateString(rspOrderModel.InsertTime) ? rspOrderModel.InsertTime : DEFAULT_PLACEHOLDER;
    
    _tradePriceLabel.hidden = YES;
    _tradeNumLabel.hidden = YES;
    _tradeTypeLabel.hidden = YES;
}

- (void)setRspTradeModel:(UPRspTradeModel *)rspTradeModel {
    _tradePriceLabel.hidden = NO;
    _tradeNumLabel.hidden = NO;
    _tradeTypeLabel.hidden = NO;
    _priceLabel.hidden = YES;
    _numLabel.hidden = YES;
    _typeLabel.hidden = YES;
    
    _nameLabel.text = UPFuturesTradeIsValidateString(rspTradeModel.InstrumentID) ? [UPFuturesTradeSearchUtil searchInstrumentName:rspTradeModel.InstrumentID inInstruments:[UPCTPTradeManager instruments:_tradeType] tradeType:_tradeType] : DEFAULT_PLACEHOLDER;
    _codeLabel.text = UPFuturesTradeIsValidateString(rspTradeModel.InstrumentID) ? rspTradeModel.InstrumentID : DEFAULT_PLACEHOLDER;
    _tradePriceLabel.text = [UPFuturesTradeNumberUtil double2String:rspTradeModel.Price];
    _tradeNumLabel.text = [NSString stringWithFormat:@"%i", rspTradeModel.Volume];
    _tradeTypeLabel.text = [UPFuturesTradeStringUtil tradeDirection:rspTradeModel.Direction];
    if (rspTradeModel.Direction == '0') {
        _tradeTypeLabel.textColor = UPColorFromRGB(0xEA4C2D);
    } else {
        _tradeTypeLabel.textColor = UPColorFromRGB(0x38AB48);
    }
    // 成交时间
    _statusLabel.text = UPFuturesTradeIsValidateString(rspTradeModel.TradeTime) ? rspTradeModel.TradeTime : DEFAULT_PLACEHOLDER;
    // 成交编号
    _timeLabel.text = UPFuturesTradeIsValidateString(rspTradeModel.TradeID) ? [UPFuturesTradeStringUtil trimWhiteSpace:rspTradeModel.TradeID] : DEFAULT_PLACEHOLDER;
}

- (void)setupOperationShowStatus:(BOOL)show {
    [UIView animateWithDuration:.3 animations:^{
        if (show) {
            _seperatorView.hidden = YES;
            _operationView.hidden = NO;
        } else {
            _seperatorView.hidden = NO;
            _operationView.hidden = YES;
        }
    }];
}

@end
