//
//  UPFuturesTradeQueryCell.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/7.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeQueryCell.h"

NSString * const UPFuturesTradeQueryCellReuseId = @"UPFuturesTradeQueryCell";

@interface UPFuturesTradeQueryCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation UPFuturesTradeQueryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupNameLabel:(NSString *)name {
    _nameLabel.text = name;
}

@end
