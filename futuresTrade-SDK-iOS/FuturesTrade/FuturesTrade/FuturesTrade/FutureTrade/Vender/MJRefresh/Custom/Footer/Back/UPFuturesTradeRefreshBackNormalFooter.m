//
//  UPFuturesTradeRefreshBackNormalFooter.m
//  UPFuturesTradeRefreshExample
//
//  Created by UPFuturesTrade Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "UPFuturesTradeRefreshBackNormalFooter.h"
#import "NSBundle+UPFuturesTradeRefresh.h"

@interface UPFuturesTradeRefreshBackNormalFooter()
{
    __unsafe_unretained UIImageView *_arrowView;
}
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation UPFuturesTradeRefreshBackNormalFooter
#pragma mark - 懒加载子控件
- (UIImageView *)arrowView
{
    if (!_arrowView) {
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[NSBundle UPFuturesTrade_arrowImage]];
        [self addSubview:_arrowView = arrowView];
    }
    return _arrowView;
}


- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.loadingView = nil;
    [self setNeedsLayout];
}
#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.UPFuturesTrade_w * 0.5;
    if (!self.stateLabel.hidden) {
        arrowCenterX -= self.labelLeftInset + self.stateLabel.UPFuturesTrade_textWith * 0.5;
    }
    CGFloat arrowCenterY = self.UPFuturesTrade_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 箭头
    if (self.arrowView.constraints.count == 0) {
        self.arrowView.UPFuturesTrade_size = self.arrowView.image.size;
        self.arrowView.center = arrowCenter;
    }
    
    // 圈圈
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = arrowCenter;
    }
    
    self.arrowView.tintColor = self.stateLabel.textColor;
}

- (void)setState:(UPFuturesTradeRefreshState)state
{
    UPFuturesTradeRefreshCheckState
    
    // 根据状态做事情
    if (state == UPFuturesTradeRefreshStateIdle) {
        if (oldState == UPFuturesTradeRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            [UIView animateWithDuration:UPFuturesTradeRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.loadingView.alpha = 1.0;
                [self.loadingView stopAnimating];
                
                self.arrowView.hidden = NO;
            }];
        } else {
            self.arrowView.hidden = NO;
            [self.loadingView stopAnimating];
            [UIView animateWithDuration:UPFuturesTradeRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];
        }
    } else if (state == UPFuturesTradeRefreshStatePulling) {
        self.arrowView.hidden = NO;
        [self.loadingView stopAnimating];
        [UIView animateWithDuration:UPFuturesTradeRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformIdentity;
        }];
    } else if (state == UPFuturesTradeRefreshStateRefreshing) {
        self.arrowView.hidden = YES;
        [self.loadingView startAnimating];
    } else if (state == UPFuturesTradeRefreshStateNoMoreData) {
        self.arrowView.hidden = YES;
        [self.loadingView stopAnimating];
    }
}

@end
