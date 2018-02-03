//
//  UPFuturesTradeVarietyKeyBoardCell.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/4.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeVarietyKeyBoardCell.h"

NSString * const UPFuturesTradeVarietyKeyBoardCellReuseId = @"UPFuturesTradeVarietyKeyBoardCell";

@interface UPFuturesTradeVarietyKeyBoardCell ()

@property (weak, nonatomic) IBOutlet UILabel *instrumentLabel;

@end

@implementation UPFuturesTradeVarietyKeyBoardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupInstrument:(NSString *)instrumentId {
    _instrumentLabel.text = instrumentId;
}

@end
