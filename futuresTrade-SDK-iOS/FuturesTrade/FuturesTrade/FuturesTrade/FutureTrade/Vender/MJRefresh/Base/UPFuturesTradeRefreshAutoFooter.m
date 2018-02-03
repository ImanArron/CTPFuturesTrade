//
//  UPFuturesTradeRefreshAutoFooter.m
//  UPFuturesTradeRefreshExample
//
//  Created by UPFuturesTrade Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "UPFuturesTradeRefreshAutoFooter.h"

@interface UPFuturesTradeRefreshAutoFooter()
@end

@implementation UPFuturesTradeRefreshAutoFooter

#pragma mark - 初始化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) { // 新的父控件
        if (self.hidden == NO) {
            self.scrollView.UPFuturesTrade_insetB += self.UPFuturesTrade_h;
        }
        
        // 设置位置
        self.UPFuturesTrade_y = _scrollView.UPFuturesTrade_contentH;
    } else { // 被移除了
        if (self.hidden == NO) {
            self.scrollView.UPFuturesTrade_insetB -= self.UPFuturesTrade_h;
        }
    }
}

#pragma mark - 过期方法
- (void)setAppearencePercentTriggerAutoRefresh:(CGFloat)appearencePercentTriggerAutoRefresh
{
    self.triggerAutomaticallyRefreshPercent = appearencePercentTriggerAutoRefresh;
}

- (CGFloat)appearencePercentTriggerAutoRefresh
{
    return self.triggerAutomaticallyRefreshPercent;
}

#pragma mark - 实现父类的方法
- (void)prepare
{
    [super prepare];
    
    // 默认底部控件100%出现时才会自动刷新
    self.triggerAutomaticallyRefreshPercent = 1.0;
    
    // 设置为默认状态
    self.automaticallyRefresh = YES;
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    // 设置位置
    self.UPFuturesTrade_y = self.scrollView.UPFuturesTrade_contentH;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.state != UPFuturesTradeRefreshStateIdle || !self.automaticallyRefresh || self.UPFuturesTrade_y == 0) return;
    
    if (_scrollView.UPFuturesTrade_insetT + _scrollView.UPFuturesTrade_contentH > _scrollView.UPFuturesTrade_h) { // 内容超过一个屏幕
        // 这里的_scrollView.UPFuturesTrade_contentH替换掉self.UPFuturesTrade_y更为合理
        if (_scrollView.UPFuturesTrade_offsetY >= _scrollView.UPFuturesTrade_contentH - _scrollView.UPFuturesTrade_h + self.UPFuturesTrade_h * self.triggerAutomaticallyRefreshPercent + _scrollView.UPFuturesTrade_insetB - self.UPFuturesTrade_h) {
            // 防止手松开时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) return;
            
            // 当底部刷新控件完全出现时，才刷新
            [self beginRefreshing];
        }
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
    if (self.state != UPFuturesTradeRefreshStateIdle) return;
    
    if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {// 手松开
        if (_scrollView.UPFuturesTrade_insetT + _scrollView.UPFuturesTrade_contentH <= _scrollView.UPFuturesTrade_h) {  // 不够一个屏幕
            if (_scrollView.UPFuturesTrade_offsetY >= - _scrollView.UPFuturesTrade_insetT) { // 向上拽
                [self beginRefreshing];
            }
        } else { // 超出一个屏幕
            if (_scrollView.UPFuturesTrade_offsetY >= _scrollView.UPFuturesTrade_contentH + _scrollView.UPFuturesTrade_insetB - _scrollView.UPFuturesTrade_h) {
                [self beginRefreshing];
            }
        }
    }
}

- (void)setState:(UPFuturesTradeRefreshState)state
{
    UPFuturesTradeRefreshCheckState
    
    if (state == UPFuturesTradeRefreshStateRefreshing) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self executeRefreshingCallback];
        });
    } else if (state == UPFuturesTradeRefreshStateNoMoreData || state == UPFuturesTradeRefreshStateIdle) {
        if (UPFuturesTradeRefreshStateRefreshing == oldState) {
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }
    }
}

- (void)setHidden:(BOOL)hidden
{
    BOOL lastHidden = self.isHidden;
    
    [super setHidden:hidden];
    
    if (!lastHidden && hidden) {
        self.state = UPFuturesTradeRefreshStateIdle;
        
        self.scrollView.UPFuturesTrade_insetB -= self.UPFuturesTrade_h;
    } else if (lastHidden && !hidden) {
        self.scrollView.UPFuturesTrade_insetB += self.UPFuturesTrade_h;
        
        // 设置位置
        self.UPFuturesTrade_y = _scrollView.UPFuturesTrade_contentH;
    }
}
@end
