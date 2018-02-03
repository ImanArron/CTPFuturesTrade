//
//  UPFuturesTradeVarietyInfoView.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/8/28.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeVarietyInfoView.h"

@interface UPFuturesTradeVarietyInfoView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *riseAndFallLabel;
@property (weak, nonatomic) IBOutlet UILabel *amplitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;

@end

@implementation UPFuturesTradeVarietyInfoView

+ (UPFuturesTradeVarietyInfoView *)futuresTradeVarietyInfoView {
    UPFuturesTradeVarietyInfoView *varietyInfoView = [[[NSBundle mainBundle] loadNibNamed:@"FuturesTradeBundle.bundle/UPFuturesTradeVarietyInfoView" owner:nil options:nil] firstObject];
    [varietyInfoView setupView];
    return varietyInfoView;
}

- (void)setupView {
    _searchImageView.image = [UIImage imageNamed:@"FuturesTradeBundle.bundle/futures_trade_10"];
}

- (IBAction)searchClicked:(id)sender {
    if (_searchBlock) {
        _searchBlock();
    }
}

- (void)setViewModel:(UPFuturesTradeVarietyInfoViewModel *)viewModel {
    _nameLabel.text = UPFuturesTradeIsValidateString(viewModel.name) ? viewModel.name : @"请选择合约";
    _priceLabel.text = [UPFuturesTradeNumberUtil double2String:viewModel.price];
    _riseAndFallLabel.text = [UPFuturesTradeNumberUtil double2String:viewModel.riseAndFall];
    _amplitudeLabel.text = [NSString stringWithFormat:@"%.2f%@", 100.f*viewModel.amplitude, @"%"];
    [UPFuturesTradeColorUtil setupLabelColor:_priceLabel value:viewModel.riseAndFall];
    [UPFuturesTradeColorUtil setupLabelColor:_riseAndFallLabel value:viewModel.riseAndFall];
    [UPFuturesTradeColorUtil setupLabelColor:_amplitudeLabel value:viewModel.riseAndFall];
    _buyNumLabel.text = [UPFuturesTradeNumberUtil long2String:viewModel.buyNum];
    _buyPriceLabel.text = [UPFuturesTradeNumberUtil double2String:viewModel.buyPrice];
    _sellNumLabel.text = [UPFuturesTradeNumberUtil long2String:viewModel.sellNum];
    _sellPriceLabel.text = [UPFuturesTradeNumberUtil double2String:viewModel.sellPrice];
}

@end

@implementation UPFuturesTradeVarietyInfoViewModel



@end
