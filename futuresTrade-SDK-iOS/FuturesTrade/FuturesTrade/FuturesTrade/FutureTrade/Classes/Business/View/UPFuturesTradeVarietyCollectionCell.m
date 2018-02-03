//
//  UPFuturesTradeVarietyCollectionCell.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/4.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeVarietyCollectionCell.h"

NSString * const UPFuturesTradeVarietyCollectionCellReuseId = @"UPFuturesTradeVarietyCollectionCell";

@interface UPFuturesTradeVarietyCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@end

@implementation UPFuturesTradeVarietyCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _indexLabel.minimumScaleFactor = 0.6;
}

- (void)setupIndex:(NSString *)index {
    _indexLabel.text = index;
}

@end
