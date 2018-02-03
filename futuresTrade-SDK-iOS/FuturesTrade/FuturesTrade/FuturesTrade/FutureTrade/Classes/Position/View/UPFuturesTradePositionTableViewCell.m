//
//  UPFuturesTradePositionTableViewCell.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/6.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradePositionTableViewCell.h"
#import <FuturesTradeSDK/UPCTPModelHeader.h>
#import "UPFuturesTradeSearchUtil.h"
#import <FuturesTradeSDK/UPCTPTradeManager.h>
#import "UPFuturesTradeCaculateUtil.h"

NSString * const UPFuturesTradePositionTableViewCellReuseId = @"UPFuturesTradePositionTableViewCell";

@interface UPFuturesTradePositionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitAndLossLabel;
@property (weak, nonatomic) IBOutlet UIView *positionInfoView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UIView *seperatorView;
@property (weak, nonatomic) IBOutlet UIView *operationView;
@property (strong, nonatomic) NSMutableArray<UILabel *> *labels;

@end

@implementation UPFuturesTradePositionTableViewCell

- (NSMutableArray<UILabel *> *)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _typeLabel.layer.masksToBounds = YES;
    _typeLabel.layer.cornerRadius = 2.f;
    for (UIButton *button in _buttons) {
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 2.f;
        button.layer.borderColor = UPColorFromRGB(0x5871a6).CGColor;
        button.layer.borderWidth = 0.5;
    }
    
    NSArray *identifiers = @[
                            @"开仓均价",
                            @"现价",
                            @"持仓数量",
                            @"可用"
                            ];
    CGFloat width = kFutursTradeScreenWidth/identifiers.count;
    for (NSInteger i = 0; i < identifiers.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.frame = CGRectMake(width*i, 0, width, 69.5);
        [_positionInfoView addSubview:view];
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.frame = CGRectMake(5, 15, width - 10, 22);
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.font = [UIFont systemFontOfSize:16];
        valueLabel.textColor = UPColorFromRGB(0x333333);
        valueLabel.text = DEFAULT_PLACEHOLDER;
        [view addSubview:valueLabel];
        [self.labels addObject:valueLabel];
        
        UILabel *identifierLabel = [[UILabel alloc] init];
        identifierLabel.backgroundColor = [UIColor clearColor];
        identifierLabel.frame = CGRectMake(5, 38, width - 10, 15);
        identifierLabel.textAlignment = NSTextAlignmentCenter;
        identifierLabel.font = [UIFont systemFontOfSize:12];
        identifierLabel.textColor = UPColorFromRGB(0x808080);
        identifierLabel.text = identifiers[i];
        [view addSubview:identifierLabel];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRspInvestorPositionModel:(UPRspInvestorPositionModel *)rspInvestorPositionModel {
    _nameLabel.text = UPFuturesTradeIsValidateString(rspInvestorPositionModel.InstrumentID) ? [UPFuturesTradeSearchUtil searchInstrumentName:rspInvestorPositionModel.InstrumentID inInstruments:[UPCTPTradeManager instruments:_tradeType] tradeType:_tradeType] : DEFAULT_PLACEHOLDER;
    _codeLabel.text = UPFuturesTradeIsValidateString(rspInvestorPositionModel.InstrumentID) ? rspInvestorPositionModel.InstrumentID : DEFAULT_PLACEHOLDER;
    _typeLabel.text = [UPFuturesTradeStringUtil posiDirection:rspInvestorPositionModel.PosiDirection];
    if (rspInvestorPositionModel.PosiDirection == '2') {
        _typeLabel.backgroundColor = UPColorFromRGB(0xEA4C2D);
    } else {
        _typeLabel.backgroundColor = UPColorFromRGB(0x38AB48);
    }
    _profitAndLossLabel.text = [UPFuturesTradeNumberUtil double2String:rspInvestorPositionModel.PositionProfit];
    [UPFuturesTradeColorUtil setupLabelColor:_profitAndLossLabel value:rspInvestorPositionModel.PositionProfit];
    for (NSInteger i = 0; i < self.labels.count; i++) {
        UILabel *label = self.labels[i];
        if (0 == i) {
            double openAmout = [UPFuturesTradeCaculateUtil openAmount:rspInvestorPositionModel tradeType:_tradeType];
            label.text = [UPFuturesTradeNumberUtil double2String:openAmout];
        } else if (1 == i) {
            label.text = [UPFuturesTradeNumberUtil double2String:rspInvestorPositionModel.LastPrice];
        } else if (2 == i) {
            label.text = [NSString stringWithFormat:@"%@", @(rspInvestorPositionModel.Position)];
        } else if (3 == i) {
            label.text = [NSString stringWithFormat:@"%i", [UPFuturesTradeCaculateUtil canUseNum:rspInvestorPositionModel]];
        }
    }
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

- (IBAction)buttonClicked:(UIButton *)sender {
    if (_block) {
        _block(sender.tag);
    }
}

@end
