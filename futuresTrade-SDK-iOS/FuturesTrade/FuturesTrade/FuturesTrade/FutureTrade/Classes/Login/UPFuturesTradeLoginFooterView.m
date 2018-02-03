//
//  UPFuturesTradeLoginFooterView.m
//  FuturesTradeDemo
//
//  Created by LiuLian on 17/8/28.
//  Copyright © 2017年 ferdinand. All rights reserved.
//

#import "UPFuturesTradeLoginFooterView.h"

@interface UPFuturesTradeLoginFooterView ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation UPFuturesTradeLoginFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)loginFooterView {
    UPFuturesTradeLoginFooterView *view = [[[NSBundle mainBundle] loadNibNamed:@"FuturesTradeBundle.bundle/UPFuturesTradeLoginFooterView" owner:nil options:nil] firstObject];
    [view disableLogin];
    return view;
}

- (IBAction)loginClicked:(id)sender {
    if (_block) {
        _block();
    }
}

- (void)enableLogin {
    _loginBtn.enabled = YES;
    _loginBtn.alpha = 1.f;
}

- (void)disableLogin {
    _loginBtn.enabled = NO;
    _loginBtn.alpha = 0.4f;
}

@end
