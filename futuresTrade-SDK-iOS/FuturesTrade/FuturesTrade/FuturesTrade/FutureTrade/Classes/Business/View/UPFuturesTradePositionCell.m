//
//  UPFuturesTradePositionCell.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/30.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradePositionCell.h"
#import <FuturesTradeSDK/UPCTPModelHeader.h>
#import "UPFuturesTradeSearchUtil.h"
#import <FuturesTradeSDK/UPCTPTradeManager.h>
#import "UPFuturesTradeCaculateUtil.h"

NSString * const UPFuturesTradePositionCellReuseId = @"UPFuturesTradePositionCell";

@interface UPFuturesTradePositionCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *canUseNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *openPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitAndLossLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UIView *seperatorView;
@property (weak, nonatomic) IBOutlet UIView *operationView;

@end

@implementation UPFuturesTradePositionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _positionTypeLabel.layer.masksToBounds = YES;
    _positionTypeLabel.layer.cornerRadius = 2.f;
    for (UIButton *button in _buttons) {
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 2.f;
        button.layer.borderColor = UPColorFromRGB(0x5871a6).CGColor;
        button.layer.borderWidth = 0.5;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonClicked:(UIButton *)sender {
    if (_block) {
        _block(sender.tag);
    }
}

- (void)setRspInvestorPositionModel:(UPRspInvestorPositionModel *)rspInvestorPositionModel {
    _nameLabel.text = UPFuturesTradeIsValidateString(rspInvestorPositionModel.InstrumentID) ? [UPFuturesTradeSearchUtil searchInstrumentName:rspInvestorPositionModel.InstrumentID inInstruments:[UPCTPTradeManager instruments:_tradeType] tradeType:_tradeType] : DEFAULT_PLACEHOLDER;
    _codeLabel.text = UPFuturesTradeIsValidateString(rspInvestorPositionModel.InstrumentID) ? rspInvestorPositionModel.InstrumentID : DEFAULT_PLACEHOLDER;
    _positionTypeLabel.text = [UPFuturesTradeStringUtil posiDirection:rspInvestorPositionModel.PosiDirection];
    if (rspInvestorPositionModel.PosiDirection == '2') {
        _positionTypeLabel.backgroundColor = UPColorFromRGB(0xEA4C2D);
    } else {
        _positionTypeLabel.backgroundColor = UPColorFromRGB(0x38AB48);
    }
    _positionNumLabel.text = [NSString stringWithFormat:@"%@", @(rspInvestorPositionModel.Position)];
    _canUseNumLabel.text = [NSString stringWithFormat:@"%i", [UPFuturesTradeCaculateUtil canUseNum:rspInvestorPositionModel]];
    double openAmout = [UPFuturesTradeCaculateUtil openAmount:rspInvestorPositionModel tradeType:_tradeType];
    _openPriceLabel.text = [UPFuturesTradeNumberUtil double2String:openAmout];
    _profitAndLossLabel.text = [UPFuturesTradeNumberUtil double2String:rspInvestorPositionModel.PositionProfit];
    [UPFuturesTradeColorUtil setupLabelColor:_profitAndLossLabel value:rspInvestorPositionModel.PositionProfit];
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
