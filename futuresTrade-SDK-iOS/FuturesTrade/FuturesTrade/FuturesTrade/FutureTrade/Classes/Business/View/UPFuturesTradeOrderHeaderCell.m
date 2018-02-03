//
//  UPFuturesTradeOrderHeaderCell.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/5.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeOrderHeaderCell.h"

NSString * const UPFuturesTradeOrderHeaderCellReuseId = @"UPFuturesTradeOrderHeaderCell";

@interface UPFuturesTradeOrderHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *identifier2Label;
@property (weak, nonatomic) IBOutlet UILabel *identifier3Label;
@property (weak, nonatomic) IBOutlet UILabel *identifier4Label;
@property (weak, nonatomic) IBOutlet UILabel *identifier5Label;

@end

@implementation UPFuturesTradeOrderHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupIdentifiers:(NSArray *)identifiers {
    if (identifiers.count > 3) {
        _identifier2Label.text = identifiers[0];
        _identifier3Label.text = identifiers[1];
        _identifier4Label.text = identifiers[2];
        _identifier5Label.text = identifiers[3];
    }
}

@end
