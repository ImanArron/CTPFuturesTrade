//
//  UPFuturesTradeFundStatusCell.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/8.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeFundStatusCell.h"

NSString * const UPFuturesTradeFundStatusCellReuseId = @"UPFuturesTradeFundStatusCell";

@interface UPFuturesTradeFundStatusCell ()

@property (weak, nonatomic) IBOutlet UILabel *identifierLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation UPFuturesTradeFundStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(UPFuturesTradeFundStatusCellModel *)viewModel {
    _identifierLabel.text = UPFuturesTradeIsValidateString(viewModel.identifier) ? viewModel.identifier : DEFAULT_PLACEHOLDER;
    if (viewModel.value) {
        _valueLabel.hidden = NO;
        _valueLabel.text = UPFuturesTradeIsValidateString(viewModel.value) ? viewModel.value : DEFAULT_PLACEHOLDER;
    } else {
        _valueLabel.hidden = YES;
        
    }
    
    if (viewModel.name) {
        _nameLabel.hidden = NO;
        _nameLabel.text = UPFuturesTradeIsValidateString(viewModel.name) ? viewModel.name : DEFAULT_PLACEHOLDER;
    } else {
        _nameLabel.hidden = YES;
    }
}

@end

@implementation UPFuturesTradeFundStatusCellModel


@end
