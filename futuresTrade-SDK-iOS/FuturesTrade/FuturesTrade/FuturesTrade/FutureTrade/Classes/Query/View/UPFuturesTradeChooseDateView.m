//
//  UPFuturesTradeChooseDateView.m
//  UPFuturesTrade
//
//  Created by LiuLian on 17/9/8.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeChooseDateView.h"

@interface UPFuturesTradeChooseDateView ()

@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

@end

@implementation UPFuturesTradeChooseDateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (UPFuturesTradeChooseDateView *)futuresTradeChooseDateView {
    UPFuturesTradeChooseDateView *chooseDateView = [[[NSBundle mainBundle] loadNibNamed:@"FuturesTradeBundle.bundle/UPFuturesTradeChooseDateView" owner:nil options:nil] firstObject];
    [chooseDateView setupDate];
    return chooseDateView;
}

- (void)setupDate {
    NSString *date = [UPBaseDateUtil currentDate:@"yyyy年MM月dd日"];
    [self setupStartDate:date];
    [self setupEndDate:date];
}

- (IBAction)dateClicked:(UIButton *)sender {
    if (_block) {
        _block(sender.tag);
    }
}

- (void)setupStartDate:(NSString *)date {
    _startDateLabel.text = date;
}

- (void)setupEndDate:(NSString *)date {
    _endDateLabel.text = date;
}

@end
